#include <stdio.h>

#include <hw/interrupts.h>
#include <hw/hw_ringbuffer.h>

void hw_ringbuffer_init(struct hw_ringbuffer *r)
{
	hw_ringbuffer_clear(r);
	r->action=0;
	r->userdata=0;
}

void hw_ringbuffer_clear(struct hw_ringbuffer *r)
{
	r->in_hw=0;
	r->in_cpu=0;
	r->out_hw=0;
	r->out_cpu=0;
	r->overruns=0;
	r->flags=0;
}

void hw_ringbuffer_fill(struct hw_ringbuffer *r,int in)
{
	int newptr=(r->in_hw+1) & (HW_RINGBUFFER_SIZE-1);
	if(r->in_cpu==newptr)
		++r->overruns;
	r->inbuf[r->in_hw]=in;
	r->in_hw=newptr;
}


void hw_ringbuffer_write(struct hw_ringbuffer *r,int in)
{
	int enabled;
	int newptr=(r->out_cpu+1) & (HW_RINGBUFFER_SIZE-1);
	enabled=DisableInterrupts();
	while((r->out_hw==newptr) && r->action)
		r->action(r->userdata);
	r->outbuf[r->out_cpu]=in;
	r->out_cpu=newptr;
	if(r->action)
		r->action(r->userdata);
	if(enabled)
		EnableInterrupts();
}

int hw_ringbuffer_read(struct hw_ringbuffer *r)
{
	int enabled;
	unsigned char result;
	if(r->in_hw==r->in_cpu)
		return(-1);	// No characters ready
	enabled=DisableInterrupts();
	result=r->inbuf[r->in_cpu];
	r->in_cpu=(r->in_cpu+1) & (HW_RINGBUFFER_SIZE-1);
	if(enabled)
		EnableInterrupts();
	return(result);
}

int hw_ringbuffer_count(struct hw_ringbuffer *r)
{
	if(r->in_hw>=r->in_cpu)
		return(r->in_hw-r->in_cpu);
	return(r->in_hw+HW_RINGBUFFER_SIZE-r->in_cpu);
}

int hw_ringbuffer_overruns(struct hw_ringbuffer *r)
{
	int result=r->overruns;
	r->overruns=0;
	return(result);
}

