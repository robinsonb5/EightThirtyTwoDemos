#ifndef HW_RINGBUFFER_H
#define HW_RINGBUFFER_H

#define HW_RINGBUFFER_SIZE 16
struct hw_ringbuffer
{
	volatile int in_hw;
	volatile int in_cpu;
	volatile int out_hw;
	volatile int out_cpu;
	unsigned int inbuf[HW_RINGBUFFER_SIZE]; // Int is much easier than char for ZPU to deal with
	unsigned int outbuf[HW_RINGBUFFER_SIZE];
	void (*action)(void *userdata);
	void *userdata;
	int flags;
	int overruns;
};

#ifdef __cplusplus
extern "C" {
#endif

void hw_ringbuffer_init(struct hw_ringbuffer *r);
void hw_ringbuffer_clear(struct hw_ringbuffer *r);
void hw_ringbuffer_write(struct hw_ringbuffer *r,int in);
int hw_ringbuffer_read(struct hw_ringbuffer *r);
int hw_ringbuffer_count(struct hw_ringbuffer *r);

void hw_ringbuffer_fill(struct hw_ringbuffer *r,int in);
int hw_ringbuffer_overruns(struct hw_ringbuffer *r);
#ifdef __cplusplus
}
#endif

#endif
