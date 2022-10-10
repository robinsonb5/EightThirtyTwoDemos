#include <stdio.h>

#include <hw/interrupts.h>
#include <hw/ps2.h>
#include <hw/timer.h>
#include <hw/mousedriver.h>

static unsigned char mouse_initsequence[]=
{	
	0x1,0xff, // Send 1 byte reset sequence
	0x82,	// Wait for two bytes in return (in addition to the normal acknowledge byte)
//	1,0xf4,0, // Uncomment this line to leave the mouse in 3-byte mode
	8,0xf3,200,0xf3,100,0xf3,80,0xf2,1, // Send PS/2 wheel mode knock sequence...
	0x81,	// Receive device ID (should be 3 for wheel mice)
	1,0xf4,0	// Enable reporting.
};

struct ps2mouse_private
{
	int active;
	int init_idx;
	int packetsize;
	int timeout;
};

void mousedriver_ps2_handle(struct mousedriver *driver)
{
	static int capture=0;
	static int delay=0;
	static int timeout;
	static int txcount=0;
	static int rxcount=0;
	struct ps2mouse_private *priv;	
	if(!driver)
		return;

	priv=(struct ps2mouse_private *)driver->private;
	
	if(priv->active)
	{
		int ready=PS2MouseBytesReady();
		while(ready>=priv->packetsize)
		{
			int w1,w2,w3,w4;
			w1=PS2MouseRead();
			w2=PS2MouseRead();
			w3=PS2MouseRead();
			driver->buttons=w1&0x7;
			if(w1 & (1<<5))
				w3|=0xffffff00;
			if(w1 & (1<<4))
				w2|=0xffffff00;

			driver->dx+=w2;
			driver->dy-=w3;

			if(priv->packetsize==4)
			{
				w4=PS2MouseRead()&7;
				if(w4&4)
					w4|=0xfffffff8;
				driver->dz+=w4;
			}
			driver->changed=1;
			priv->timeout=0;
			ready=PS2MouseBytesReady();
		}
		if(ready>0 && ready<priv->packetsize)
		{
			if(!priv->timeout)
				priv->timeout=GetTimer(100);
			else if(CheckTimer(priv->timeout))
			{
				priv->timeout=0;
				priv->packetsize=7-priv->packetsize;
				printf("Mouse timeout, toggling wheel mouse to %d, %d bytes ready\n",priv->packetsize,PS2MouseBytesReady());
				while(PS2MouseBytesReady())
					PS2MouseRead();
				priv->timeout=0;
			}
		}	
		return;
	}

	if(!CheckTimer(delay))
		return;
	delay=GetTimer(20);
	
	if(!priv->init_idx)
	{
		while(PS2MouseRead()>-1)
			; // Drain the buffer;
		txcount=mouse_initsequence[priv->init_idx++];
		rxcount=0;
	}
	else
	{
		if(rxcount)
		{
			int q=PS2MouseRead();
			if(q>-1)
				--rxcount;
			else if(CheckTimer(timeout))
				priv->init_idx=0;
	
			if(!txcount && !rxcount)
			{
				int next=mouse_initsequence[priv->init_idx++];
				if(next&0x80)
				{
					rxcount=next&0x7f;
					priv->packetsize=(q==3) ? 4 : 3;
				}
				else
					txcount=next;
			}
		}
		else if(txcount)
		{
			PS2MouseWriteChar(mouse_initsequence[priv->init_idx++]);
			--txcount;
			if(!txcount)
				capture=1;
			rxcount=1;
			timeout=GetTimer(3500);	//3.5 seconds
		}
	}
	if(!rxcount && !txcount)
	{
		printf("Mouse initialised in %s mode\n",priv->packetsize==3 ? "normal" : "wheel");
		priv->active=1;
	}
	return;
}


static struct ps2mouse_private mouseprivate;

void mousedriver_ps2_init(struct mousedriver *driver)
{
	driver->private=&mouseprivate;
	mouseprivate.active=0;
	mouseprivate.packetsize=3;
	driver->dx=0;
	driver->dy=0;		
	driver->dz=0;
	driver->buttons=0;
	mousedriver_reset(driver);
}


void mousedriver_reset(struct mousedriver *driver)
{
	struct ps2mouse_private *priv;	
	if(!driver)
		return;

	priv=(struct ps2mouse_private *)driver->private;	
	priv->init_idx=0;
	priv->active=0;
	priv->timeout=0;
}

int mousedriver_get_event(struct mousedriver *driver)
{
	int result=0;
	if(driver)
	{
		result=driver->changed;
		driver->changed=0;
	}
	return result;
}

int mousedriver_get_buttons(struct mousedriver *driver)
{
	int result=0;
	if(driver)
	{
		result=driver->buttons;
	}
	return result;
}

int mousedriver_get_dx(struct mousedriver *driver)
{
	int result=0;
	if(driver)
	{
		result=driver->dx;
		driver->dx=0;
	}
	return result;
}

int mousedriver_get_dy(struct mousedriver *driver)
{
	int result=0;
	if(driver)
	{
		result=driver->dy;
		driver->dy=0;
	}
	return result;
}

int mousedriver_get_dz(struct mousedriver *driver)
{
	int result=0;
	if(driver)
	{
		result=driver->dz;
		driver->dz=0;
	}
	return result;
}

