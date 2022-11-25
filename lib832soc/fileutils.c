
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <minfat.h>
#include <hw/spi.h>
#include <hw/uart.h>

#include <fileutils.h>

static fileTYPE file;

char *LoadFile(const char *filename)
{
	char *result=0;
	if(FileOpen(&file,filename))
	{
		printf("File size is %x\n",file.size);
		result=(char *)malloc(file.size);
		printf("Got buffer at %x\n",(int)result);
		if(result)
		{
			if(!FileRead(&file,result,file.size))
			{
				printf("Read failed\n");
				free(result);
				result=0;
			}
		}
	}
	return(result);
}


int MatchWildcard(const char *filename,int maxlen,void *userdata)
{
	int idx1=0,idx2=0,idxw=0;
	int c1,c2;
	const char *pattern;
	int casesensitive;
	if(!userdata)
		return(0);

	pattern=((struct wildcard_pattern *)userdata)->pattern;
	casesensitive=((struct wildcard_pattern *)userdata)->casesensitive;

//	printf("Matching %s against %s\n",filename,pattern);

	c1=pattern[idx1++];
	c2=filename[idx2++];
	
	while(c2)
	{
		if(c1=='*')
		{
			idxw=idx1;
			c1=pattern[idx1++];
		}
		if(!casesensitive)
		{
			c1&=~32;
			c2&=~32;
		}
		if((c1&~32)!=(c2&~32))
			idx1=idxw;
		c1=pattern[idx1++];
		c2=filename[idx2++];
		if(idx2>maxlen)
			c2=0;
		if(c1==0 && c2==0)
			return(1);
	}
	return(0);
}


static char filename[12];
char *FileSelector(struct wildcard_pattern *pattern)
{
	DIRENTRY *de;
	int idx=0;
	int c;

	de=0;	
	while(de=NextDirEntry(de ? 0 : 1,MatchWildcard,pattern))
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

	printf("%d mod files found, please choose.\n",idx);
	
	while(1)
	{
		c=getserial();
		if(c==27)
			return(0);
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
				de=NextDirEntry(de ? 0 : 1,MatchWildcard,pattern);
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


