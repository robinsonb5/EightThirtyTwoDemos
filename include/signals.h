#ifndef SIGNALS_H
#define SIGNALS_H

void SetSignal(int signalbit);
int WaitSignal(int signalmask);
int TestSignal(int signalmask);

#endif

