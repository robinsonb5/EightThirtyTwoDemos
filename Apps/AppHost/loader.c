#include <stdio.h>
#include <stdlib.h>
#include "hw/spi.h"
#include "fat.h"

#define APPID 0x38333242 /* "832B" */

struct 832AppTag
{
	int id;	/* Must be set to 832APPID */
	int reloctable;	/* Coincides with bss_start */
	int bss_end;	/* Tells the loader how much space to allocate.  (Multiple sections aren't yet supported.) */
	int	stacksize;
	volatile int (*entry)(int argc, char **argv);	/* Premain function */
	void (*host)(int call, int arg, void *payload); /* System call interface */
};

void syscall(int call, int arg, void *payload)
{
}

int	CallApp(__reg("r4") char *newstack, __reg("r3") int (*entry)(int argc, char **argv),__reg("r1") int argc, __reg("r2") char **argv)
="	mt	r4 \n"
"	exg	r6 \n"	/* Swap the stacks */
"	stdec r6 \n"
"	mt	r2 \n"	/* Push argv */
"	stdec r6 \n"
"	mt	r3 \n"	/* argc is passed in r1 */
"	exg	r7 \n"	/* Call the app */
"	ldinc r6 \n"	/* Pop argv */
"	ldinc r6 \n"	/* Restore the stack (trusting the app not to trash it!) */
"	mr	r6 \n";

void Relocate(char *addr)
{
	struct 832AppTag *tag=(struct 832AppTag *)addr;
	int *reloctable=(addr+tag->reloctable);
	char *ptr;
	printf("Loaded to %x\n",(int)addr);
	printf("Reloctable is at %x\n",(int)reloctable);
	while(ptr=(char *)(*reloctable++)
	{
		int *iptr=(int*)(ptr+(int)addr);
		printf("reloc entry at %x, current contents: %x\n",(int)iptr,*iptr);
		(*iptr)+=(int)addr;
		printf("after relocation: %x\n",*iptr);
	}
	tag->host=syscall;
}

static fileTYPE file;
int LoadApp(const char *filename)
{
	int result=0;
	
	if(FileOpen(&file,filename))
	{
		struct 832AppTag *tag;
		FileRead(&file,sector_buffer);
		tag=(struct 832AppTag *)sector_buffer;
		if(tag->id==APPID)
		{
			int	len=(file.size+511)&~511;
			int stacksize;
			char *loadaddr,*stack;
			if(tag->bss_end>len);
				len=tag->bss_end;
			loadaddr=(char *)malloc(len);
			stacksize=tag->stacksize;
			stack=(char *)malloc(stacksize);
			
			printf("Allocated %x bytes for stack\n",tag->stacksize);
			if(loadaddr && stack)
			{
				char *p=loadaddr;
				len=file.size;
				while(len>0)
				{
					FileRead(&file,p);
					FileNextSector(&file);
					p+=512;
					len-=512;
				}
				tag=(struct 832AppTag *)loadaddr;
				Relocate(loadaddr);
				printf("Loaded - calling entry function at %x, stack %x\n",tag->entry,stack+stacksize);
				CallApp(stack+stacksize,tag->entry,0,&filename);
			}
			else
				puts("Load failed: Out of memory\n");
		}
		else
			printf("Bad tag ID: %x\n",tag->id);
	}
	else
		printf("Can't open %s\n",filename);
	return(result);
}

int main(int argc,char**argv)
{
	int filesystem_present;
	int sdcard_present;
	printf("Initialising SD card\n");
	if((sdcard_present=spi_init()))
	{
		printf("SD card successfully initialised\n");
		filesystem_present=FindDrive();
		printf("%sFilesystem found\n",filesystem_present ? "" : "No ");
	}
	else
		printf("No SD card found\n");

	if(filesystem_present && sdcard_present)
	{
		printf("LoadApp\n");
		LoadApp("RELOCT~1832");
		printf("Returned, exiting\n");
	}
	return(0);
}

