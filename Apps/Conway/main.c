// https://rosettacode.org/wiki/Conway's_Game_of_Life/C

#include <hw/uart.h>
#include <hw/vga.h>
#include <hw/timer.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define CELL(I,J) (field[size*(I)+(J)])
#define ALIVE(I,J) t[size*(I)+(J)] = 1
#define DEAD(I,J)  t[size*(I)+(J)] = 0
 
unsigned short *FrameBuffer;	// Frame Buffer pointer
int screenwidth=640;		// Initial screen width
int screenheigth=480;		// Initial screen heigth

#define BLINKER_SIZE 3
#define BLINKER_GEN 3
char small_blinker[] = {
      0,0,0,
      1,1,1,
      0,0,0
};
char temp_blinker[BLINKER_SIZE*BLINKER_SIZE];
 
#define FIELD_SIZE 45
#define FIELD_GEN 175
char field[FIELD_SIZE * FIELD_SIZE];
char temp_field[FIELD_SIZE*FIELD_SIZE];
 
/* set the cell i,j as alive */
#define SCELL(I,J) field[FIELD_SIZE*(I)+(J)] = 1
 
int count_alive(const char *field, int i, int j, int size)
{
   int x, y, a=0;
   for(x=i-1; x <= (i+1) ; x++)
   {
      for(y=j-1; y <= (j+1) ; y++)
      {
         if ( (x==i) && (y==j) ) continue;
         if ( (y<size) && (x<size) &&
              (x>=0)   && (y>=0) )
         {
              a += CELL(x,y);
         }
      }
   }
   return a;
}
 
void evolve(const char *field, char *t, int size)
{
   int i, j, alive, cs;
   for(i=0; i < size; i++)
   {
      for(j=0; j < size; j++)
      {
         alive = count_alive(field, i, j, size);
         cs = CELL(i,j);
         if ( cs )
         {
            if ( (alive > 3) || ( alive < 2 ) )
                DEAD(i,j);
            else
                ALIVE(i,j);
         } else {
            if ( alive == 3 )
                ALIVE(i,j);
            else
                DEAD(i,j);
         }
      }
   }
} 


void dump_field(const char *f, int size)
{
   int i;
   for (i=0; i < (size*size); i++)
   {
      if ( (i % size) == 0 ) printf("\n");
      printf("%c", f[i] ? 'X' : '.');
   }
   printf("\n");
}


// makeRect(xS,yS,xE,yE,color) - Draw a rectangle
void makeRect(unsigned int xS, unsigned int yS, unsigned int xE, unsigned int yE, unsigned int color)
{
	unsigned int x,y,yoff;
	for (y = yS; y <= yE; y += 1)
	{
		yoff = y * screenwidth;
		for (x = xS; x <= xE; x += 1)
		{
			*(FrameBuffer + x + yoff) = color;
		}
	}
}


#define cellSize 10

void dump_rectangles(const char *f, int size)
{
	unsigned int x;
	unsigned int y;
	//printf("(dump_rectangles): Reached function\n\r");
	for (y=0; y < size; y++)
	{
		// printf("(dump_rectangles): Y loop\n\r");
		for (x=0; x < size; x++)
		{
			// printf("(dump_rectangles): X loop\n\r");
			if (f[(y*size)+x] == 0)
				makeRect(x*cellSize,y*cellSize,(x*cellSize)+cellSize-1,(y*cellSize)+cellSize-1,0);
			else
				makeRect(x*cellSize,y*cellSize,(x*cellSize)+cellSize-1,(y*cellSize)+cellSize-1,Random());
		}
	}
}
 

void initDisplay(void)
{
	FrameBuffer=(short *)malloc(sizeof(short)*640*480);
	HW_VGA(FRAMEBUFFERPTR) = (int)FrameBuffer;
	memset(FrameBuffer,0,sizeof(short)*640*480);
}


int Random()
{
	static int random=0xe4219f;
	random=(random<<13)^(random>>6)^HW_TIMER(REG_TIMER_COUNTER);
	return(random);
}


int main(int argc, char **argv)
{
    int i;
    char *fa, *fb, *tt, op;
		unsigned short randomX;
		unsigned short randomY;
 
    op = 'g';
	
	initDisplay();

    switch ( op )
    {
      // case 'B':
      // case 'b':		// blinker test
        // fa = small_blinker;
        // fb = temp_blinker;
        // for(i=0; i< BLINKER_GEN; i++)
        // {
           // dump_field(fa, BLINKER_SIZE);
           // dump_rectangles(fa, BLINKER_SIZE);
           // evolve(fa, fb, BLINKER_SIZE);
           // tt = fb; fb = fa; fa = tt;
        // }
        // return 0;
      case 'G':
      case 'g':		// Glider
        for(i=0; i < (FIELD_SIZE*FIELD_SIZE) ; i++) field[i]=0;
        /* prepare the glider */
        //            SCELL(0, 1);
        //                          SCELL(1, 2);
        //SCELL(2, 0); SCELL(2, 1); SCELL(2, 2);
				// Put up 400 random cells
				for (i=0; i < 400; i++)
				{
					randomX = Random() % 45;
					randomY = Random() % 45;
					SCELL(randomX, randomY);
				}

        /* evolve */
        fa = field;
        fb = temp_field;
        for (i=0; i < FIELD_GEN; i++)
        {
           //tb_puts("Dumping frame\r\n");
           //dump_field(fa, FIELD_SIZE);
           //tb_puts("Dumped frame to tb\r\n");
           dump_rectangles(fa, FIELD_SIZE);
           //tb_puts("Dumped frame to fb\r\n");
		   		 evolve(fa, fb, FIELD_SIZE);
           tt = fb; fb = fa; fa = tt;
        }
        return 0;
      default:
        puts("no CA for this\n");
        break;
    }
    return 1;
}

