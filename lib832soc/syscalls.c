#include <sys/types.h>
#include <stdio.h>
#include <stdarg.h>
#include <errno.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <hw/uart.h>
#include <hw/spi.h>

#include "malloc.h"
#include "minfat.h"

// File table

#define MAX_FILES 8
static fileTYPE *Files[MAX_FILES];
#define FILEHANDLE(x) Files[(x)-2]


int __errno;
int *__error()
{
	return(&__errno);
}


// FIXME - bring these in.
extern void _init(void);

// Hardware initialisation
// Sets up RS232 baud rate and attempts to initialise the SD card, if present.

static int filesystem_present;

/* Constructor dependencies: minfat */
__constructor(120.syscalls) void _initsyscalls(void)
{
	int t;
	filesystem_present=0;
#ifdef DISABLE_FILESYSTEM
	printf("Filesystem disabled\n");
#else
	filesystem_present=FilesystemPresent();
	printf("%sFilesystem found\n",filesystem_present ? "" : "No ");
#endif
	printf("Initialising files\n");
	for(t=0;t<MAX_FILES;++t)
		Files[t]=0;
}


// Rudimentary filesystem support

__weak ssize_t write(int fd, const void *buf, size_t nbytes)
{
	const char *b=(const char *)buf;
	if((fd==1) || (fd==2)) // stdout/stderr
	{
		int c=nbytes;
		// Write to UART
		// FIXME - need to save any received bytes in a ring buffer.
		// FIXME - ultimately need to use interrupts here.

		while(nbytes--)
		{
			while(!(HW_UART(REG_UART)&(1<<REG_UART_TXREADY)))
				;
			HW_UART(REG_UART)=*b++;
		}
		return(nbytes);
	}
	else
	{
		if(FILEHANDLE(fd-3))
		{
			// We have a file - but we don't yet support writing.
			__errno=EACCES;
		}
		__errno=EBADF;
	}
	return (nbytes);
}


/*
 * read  -- read bytes from the serial port if fd==0, otherwise try and read from SD card
 */

__weak ssize_t read(int fd, void *buf, size_t nbytes)
{
	char *b=(char *)buf;
	if(fd==0) // stdin
	{
		// Read from UART
		while(nbytes--)
		{
			int in;
			while(!((in=HW_UART(REG_UART))&(1<<REG_UART_RXINT)))
				;
			*b++=in&0xff;
		}
		return(nbytes);
	}
	else
	{
#ifndef DISABLE_FILESYSTEM
		// Handle reading from SD card
		if(FILEHANDLE(fd))
		{
			int result;
			result=FileRead(FILEHANDLE(fd),b,nbytes);
			if(result<0)
				__errno=EIO;
			return(result);
		}
		else
#endif
			__errno=EBADF;
	}
	return(0);
}


__weak int access(const char *filename,int flags)
{
	if(!filesystem_present)
		return(-1);
	if(flags & W_OK)
		return(-1);
	if(FindDirEntry(filename))
		return(0);
	return(-1);
}


/*
 * open -- open a file descriptor.
 */
__weak int open(const char *buf,int flags, ...)  
{
	// FIXME - Take mode from the first varargs argument
	printf("in open()\n");
	if(filesystem_present) // Only support reads at present.
	{
#ifndef DISABLE_FILESYSTEM
		// Find a free FD
		int fd=3;
		while((fd-3)<MAX_FILES)
		{
			if(!FILEHANDLE(fd))
			{
				printf("Found spare fd: %d\n",fd);
				FILEHANDLE(fd)=malloc(sizeof(fileTYPE));
				if(FILEHANDLE(fd))
				{
					printf("Opening file...\n");
					if(FileOpen(FILEHANDLE(fd),buf))
					{
						printf("Success - returning\n");
						return(fd);
					}
					else
						free(FILEHANDLE(fd));
					__errno = ENOENT;
					printf("Open failed - returning -1\n");
					return(-1);
				}
			}
			++fd;
		}
#endif
	}
	else
	{
		printf("open() - no filesystem present\n");
		__errno = EIO;
	}
	return (-1);
}



/*
 * close
 */
__weak int close(int fd)  
{
	if(fd>2 && FILEHANDLE(fd))
		free(FILEHANDLE(fd));
	return (0);
}


__weak int ftruncate(int file, off_t length)
{
	return -1;
}


/*
 * unlink -- we just return an error since we don't support writes yet.
 */
__weak int unlink(const char *path)
{
	__errno = EIO;
	return (-1);
}


/*
 * lseek --  Since a serial port is non-seekable, we return an error.
 */
__weak off_t lseek(int fd,  off_t offset, int whence)
{
	if(fd<3)
	{
		__errno = ESPIPE;
		return ((off_t)-1);
	}
	else if(FILEHANDLE(fd))
	{
		int pos;
		if(whence==SEEK_CUR)
			pos=FileTell(FILEHANDLE(fd));
		else if(whence==SEEK_SET)
			pos=0;
		else if(whence==SEEK_END)
			pos=FILEHANDLE(fd)->size;
		else
		{
			__errno = EINVAL;
			return((off_t)-1);
		}

#ifndef DISABLE_FILESYSTEM
		FileSeek(FILEHANDLE(fd),pos+offset);
#endif
		return((off_t)FileTell(FILEHANDLE(fd)));
	}
}

/* we convert from bigendian to smallendian*/
#if 0
static long conv(char *a, int len) 
{
	long t=0;
	int i;
	for (i=0; i<len; i++)
	{
		t|=(((int)a[i])&0xff)<<((len-1-i)*8);
	}
	return t;
}
#endif
#if 0
static void convert(struct fio_stat *gdb_stat, struct stat *buf)
{
	memset(buf, 0, sizeof(*buf));
	buf->st_dev=conv(gdb_stat->fst_dev, sizeof(gdb_stat->fst_dev));
	buf->st_ino=conv(gdb_stat->fst_ino, sizeof(gdb_stat->fst_ino));
	buf->st_mode=conv(gdb_stat->fst_mode, sizeof(gdb_stat->fst_mode));
	buf->st_nlink=conv(gdb_stat->fst_nlink, sizeof(gdb_stat->fst_nlink));
	buf->st_uid=conv(gdb_stat->fst_uid, sizeof(gdb_stat->fst_uid));
	buf->st_gid=conv(gdb_stat->fst_gid, sizeof(gdb_stat->fst_gid));
	buf->st_rdev=conv(gdb_stat->fst_rdev, sizeof(gdb_stat->fst_rdev));
	buf->st_size=conv(gdb_stat->fst_size, sizeof(gdb_stat->fst_size));
}
#endif

__weak int fstat(int fd, struct stat *buf)
{
/*
 * fstat
 */
	printf("Clearing stat buffer at %x\n",(int)buf);
	memset(buf,0,sizeof(struct stat));
	printf("Done\n");
	if(fd<3)
	{
		printf("Setting mode to TTY\n");
		buf->st_mode = S_IFCHR;	/* Always pretend to be a tty */
		buf->st_blksize = 0;
	}
	else if(FILEHANDLE(fd))
	{
		printf("Filehandle is a file\n");
		buf->st_size = FILEHANDLE(fd)->size;
		printf("Setting st_size %ud\n",FILEHANDLE(fd)->size);
	}
	return (0);
}


__weak int stat(const char *path, struct stat *buf)
{
	__errno = EIO;
	return (-1);
}


/* Currently only supports a single path name from the current directory */
__weak int chdir(const char *path)
{
	DIRENTRY *d=FindDirEntry(path);
	if(d)
		ChangeDirectory(d);
	return(d ? 0 : -1);
}


__weak int isatty(int fd)
{
	/*
	 * isatty -- returns 1 if connected to a terminal device,
	 *           returns 0 if not. Since we're hooked up to a
	 *           serial port, we'll say yes and return a 1.
	 */
	return(fd < 3 ? 1 : 0);
}


int fgetc(FILE *f)
{
	unsigned char buf;
	if(f)
		return(FileGetCh(f));
	else
	{
		/* Read from UART */
		int in;
		while(!((in=HW_UART(REG_UART))&(1<<REG_UART_RXINT)))
			;
		return(in&0xff);
	}
}

void setbuf(FILE *f,char *buf)
{
	return; // NULL function
}

int fprintf(FILE *f,const char *fmt, ...)
{
//	if(fd<3)
//	{
		va_list ap;
		int ret;

		va_start(ap, fmt);
		ret = vprintf(fmt, ap);
		va_end(ap);
		return (ret);
//	}
//	else if(FILEHANDLE(fd))
//	{
		// We have a file - but we don't yet support writing.
//		__errno=EACCES;
//	}
//	__errno=EBADF;
//	return(0);
}


int abs(int i)
{
	return(i<0 ? -i : i);
}

