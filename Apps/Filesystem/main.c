
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sys/stat.h>

#include <minfat.h>
#include <hw/vga.h>

fileTYPE *file;

char string[]="Hello world!\n";


char *LoadFile(const char *filename)
{
	char *result=0;
	struct stat statbuf;
	int fd=open(filename,0,O_RDONLY);
	printf("open() returned %d\n",fd);
	if((fd>0)&&!fstat(fd,&statbuf))
	{
		int n;
		int size=statbuf.st_size; /* Caution - 64-bit value */
		result=(char *)malloc(size);
		if(result)
		{
			if(read(fd,result,size)<0)
			{
				printf("Read failed\n");
				free(result);
				result=0;
			}
		}
	}
	return(result);
}


int filename_matchwildcard(const char *str1, const char *str2,int maxlen,int casesensitive)
{
	int idx1=0,idx2=0,idxw=0;
	int c1,c2;
	c1=str1[idx1++];
	c2=str2[idx2++];
	while(c2)
	{
		if(c1=='*')
		{
			idxw=idx1;
			c1=str1[idx1++];
		}
		if(!casesensitive)
		{
			c1&=~32;
			c2&=~32;
		}
		if((c1&~32)!=(c2&~32))
			idx1=idxw;
		c1=str1[idx1++];
		c2=str2[idx2++];
		if(idx2>maxlen)
			c2=0;
		if(c1==0 && c2==0)
			return(1);
	}
	return(0);
}

int matchfunc(const char *str,int len)
{
	return(filename_matchwildcard("*mod",str,len,0));
}

int main(int argc, char **argv)
{
	char *ptr;
	int size;
	int cluster;
	int count=0;
	DIRENTRY *dir=0;

	if((ptr=LoadFile("PIC1    RAW")))
	{
		printf("File successfully loaded to %d\n",(int)ptr);
		HW_VGA(FRAMEBUFFERPTR)=(int)ptr;
	}
	else
		printf("Loading failed\n");

	dir=FindDirEntry("PARENT     ");
//	cluster=FindDirectory(0,"ADFS       ");
	if(dir)
	{
		printf("Found parent at %d\n",(int)dir);
		ChangeDirectory(dir);

		printf("Scanning directory\n");
		dir=0;
		while((dir=NextDirEntry(dir==0,0)))
		{
			if (dir->Name[0] != SLOT_EMPTY && dir->Name[0] != SLOT_DELETED) // valid entry??
			{
				printf("%s (%s)\n",dir->Name,longfilename);
			}
		}

		dir=FindDirEntry("SUBDIR     ");
		if(dir)
		{
			printf("Found subdir at %d\n",(int)dir);
			if(ValidateDirectory(ClusterFromDirEntry(dir)))
				printf("cluster valid\n");
			else
				printf("cluster not valid\n");
		}
	}

#if 0
	printf("Checking selected clusters for validity as directories...\n");
	printf("(Only the first is likely to be valid.)\n");

	for(cluster=0;cluster<0x7ffff;cluster+=0x1137)
	{
		if(ValidateDirectory(cluster))
			printf("cluster %d valid\n",cluster);
		else
			printf("cluster %d not valid\n",cluster);
	}
#endif
	printf("Scanning directory\n");
	dir=0;
	ChangeDirectoryByCluster(0);
	while((dir=NextDirEntry(dir==0,0)))
	{
		if (dir->Name[0] != SLOT_EMPTY && dir->Name[0] != SLOT_DELETED) // valid entry??
		{
			printf("%s (%s)\n",dir->Name,longfilename);
			++count;
		}
	}
	printf("Scanned %d directory entries in total\n",count);

	ChangeDirectoryByCluster(0);
	dir=0;
	while(dir=NextDirEntry(dir ? 0 : 1,matchfunc))
	{
		if(!(dir->Attributes & ATTR_DIRECTORY))
			printf("Mod file found: %s (%s)\n",dir->Name,longfilename);
	}

	return(0);
}

