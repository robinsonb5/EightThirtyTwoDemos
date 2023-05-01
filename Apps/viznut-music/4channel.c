extern void putbyte();

void main()
{
	int t;
	int t2;
	for(t=0;;t++) {
		t2=t>>6;
		putbyte(0,((t&4096)?((t*(t^t%255)|(t>>4))>>1):(t>>3)|((t&8192)?t<<2:t)));
		putbyte(1,(((t>>19) ^ t>>16)*64+63) & (t>>7|t|t>>6)*10+4*(t&t>>13|t>>6));
		putbyte(2,((t*(t>>8|t>>9)&46&t>>8))^(t&t>>13|t>>6));
		putbyte(3,(((t>>18) ^ t>>14)*48+15) & (t*5&(t>>7)|t*3&(t*4>>10)));
	}
}

