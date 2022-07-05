#ifndef WAV_H
#define WAV_H

struct Wav
{
    int file;
    int length;
};


int wav_read(struct Wav *wav,char *buf,int length);
struct Wav *wav_open(const char *filename);
void wav_close(struct Wav *wav);


#endif

