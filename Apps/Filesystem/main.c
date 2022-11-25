
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sys/stat.h>

#include <minfat.h>
#include <fileutils.h>

#include <hw/vga.h>

fileTYPE *file;

char string[]="Hello world!\n";


int main(int argc, char **argv)
{
	char *ptr;
	int size;
	int cluster;
	int count=0;
	DIRENTRY *dir=0;
	struct wildcard_pattern pattern;

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
	while((dir=NextDirEntry(dir==0,0,0)))
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
	pattern.casesensitive=0;
	pattern.pattern="*.mod";
	while(dir=NextDirEntry(dir ? 0 : 1,MatchWildcard,&pattern))
	{
		if(!(dir->Attributes & ATTR_DIRECTORY))
			printf("Mod file found: %s (%s)\n",dir->Name,longfilename);
	}

	return(0);
}

