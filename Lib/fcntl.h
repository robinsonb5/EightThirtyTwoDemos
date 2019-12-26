#ifndef FCNTL_H
#define FCNTL_H

#include <sys/stat.h>
#include <stddef.h>

#define O_RDONLY 0
#define O_WRONLY 1
#define O_RDWR 2

ssize_t write(int fd, const void *buf, size_t nbytes);
ssize_t read(int fd, void *buf, size_t nbytes);
int access(const char *filename,int flags);
int open(const char *buf,int flags, ...);
int close(int fd);
int ftruncate(int file, off_t length);
int unlink(const char *path);
off_t lseek(int fd,  off_t offset, int whence);
int fstat(int fd, struct stat *buf);
int stat(const char *path, struct stat *buf);
int isatty(int fd);
void setbuf(FILE *f,char *buf);
int fprintf(FILE *f,const char *fmt, ...);
#endif

