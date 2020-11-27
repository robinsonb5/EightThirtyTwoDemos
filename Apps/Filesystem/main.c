
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sys/stat.h>

#include <fat.h>
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


int main(int argc, char **argv)
{
	char *ptr;
	int size;
	int cluster;
	DIRENTRY *dir=0;

	printf("Scanning directory\n");
	while((dir=NextDirEntry(dir==0)))
	{
		if (dir->Name[0] != SLOT_EMPTY && dir->Name[0] != SLOT_DELETED) // valid entry??
		{
			printf("%s (%s)\n",dir->Name,longfilename);
		}
	}
	if((ptr=LoadFile("PIC1    RAW")))
	{
		printf("File successfully loaded to %d\n",ptr);
		HW_VGA(FRAMEBUFFERPTR)=(int)ptr;
	}
	else
		printf("Loading failed\n");

	cluster=FindDirectory(0,"PARENT     ");
//	cluster=FindDirectory(0,"ADFS       ");
	if(cluster)
	{
		printf("Found parent at %ld\n",cluster);
		SetDirectory(cluster);

		printf("Scanning directory\n");
		dir=0;
		while((dir=NextDirEntry(dir==0)))
		{
			if (dir->Name[0] != SLOT_EMPTY && dir->Name[0] != SLOT_DELETED) // valid entry??
			{
				printf("%s (%s)\n",dir->Name,longfilename);
			}
		}

		cluster=FindDirectory(cluster,"SUBDIR     ");
		if(cluster)
		{
			printf("Found subdir at %ld\n",cluster);
			if(ValidateDirectory(cluster))
				printf("cluster valid\n");
			else
				printf("cluster not valid\n");
		}
	}

	for(cluster=0;cluster<0x7ffff;cluster+=0x1137)
	{
		if(ValidateDirectory(cluster))
			printf("cluster %ld valid\n",cluster);
		else
			printf("cluster %ld not valid\n",cluster);
	}

	return(0);
}

