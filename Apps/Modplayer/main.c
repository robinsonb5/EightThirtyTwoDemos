
#include <stdio.h>

#define NULL 0
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <minfat.h>

#include <hw/uart.h>
#include <hw/soundhw.h>

#include "replay.h"
fileTYPE *file;

static struct stat statbuf;


char *LoadFile(const char *filename)
{
	char *result=0;
	int fd=open(filename,0,O_RDONLY);
	printf("open() returned %d\n",fd);
	if((fd>0)&&!fstat(fd,&statbuf))
	{
		int n=statbuf.st_size; // 64-bit
		printf("File size is %d\n",n);
		result=(char *)malloc(n);
		printf("Got buffer at %x\n",(int)result);
		if(result)
		{
			if(read(fd,result,n)<0)
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


char getserial()
{
	int c=HW_UART(REG_UART);
	if(c&(1<<REG_UART_RXINT))
	{
		c&=0xff;
		return(c);
	}
	return(0);
}

char filename[12];
char *ModMenu()
{
	DIRENTRY *de;
	int idx=0;
	int c;

	ChangeDirectoryByCluster(0);
1	de=0;	
	while(de=NextDirEntry(de ? 0 : 1,matchfunc))
	{
		if(!(de->Attributes & ATTR_DIRECTORY))
		{
			char c=idx;
			if(idx>9)
				c+='A'-10;
			else
				c+='0';
			printf("%c: %s (%s)\n",c,de->Name,longfilename);
			++idx;
		}
	}

	printf("%d mod files found, please choose.\n");
	
	while(1)
	{
		c=getserial();
		if(c>='a')
			c-=('a'-'A');
		if(c>='A')
			c-='A'-('9'+1);

		if((c>='0') && (c<('0'+idx)))
		{
			de=0;
			idx=1+c-'0';
			ChangeDirectoryByCluster(0);
			while(idx)
			{
				de=NextDirEntry(de ? 0 : 1,matchfunc);
				if(!(de->Attributes & ATTR_DIRECTORY))
					--idx;
			}
			if(de)
				strncpy(filename,&de->Name[0],11);
			filename[11]=0;
			printf("Selected %s\n",filename);
			return(filename);
		}
	}
}



int main(int argc, char **argv)
{
	char *ptr;
	char *fn;
	while(1)
	{
		fn=ModMenu();
		if((ptr=LoadFile(fn)))
		{
			printf("File successfully loaded to %x\n",ptr);
			ptBuddyPlay(ptr,0);
			printf("Playing - press Esc to stop\n");
			while(getserial()!=27)
				;
			ptBuddyClose();
			free(ptr);
		}
		else
			printf("Loading failedn\n");
	}
	return(0);
}

