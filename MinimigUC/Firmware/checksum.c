
// Endian-neutral checksum of a memory region...

unsigned int checksum(const unsigned char *a,int l)
{
	unsigned int sum=0;
	unsigned int t;
	while(l>0)
	{
		t=*a++;

		t<<=8;
		--l; t|=l>0 ? *a++ : 0;

		t<<=8;
		--l; t|=l>0 ? *a++ : 0;

		t<<=8;
		--l; t|=l>0 ? *a++ : 0;

		sum+=t;
		--l;
	}
	return(sum);
}

