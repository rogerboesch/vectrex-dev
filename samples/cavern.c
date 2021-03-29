// 
// File:   cavern.c
// Author: Graham Toal
// Info:   Experimental. Unfinished "Vecavern" example code, published by Graham Toal in Facebook group https://www.facebook.com/groups/vectrex
//
// Converted to Classics Coder and CMOC by Roger Boesch
//

#include <vectrex.h>

#pragma vx_copyright "2020"
#pragma vx_title_pos 0,-80
#pragma vx_title_size -8, 80
#pragma vx_title "g CAVERN"
#pragma vx_music vx_music_1

#define DISPLAY_WIDTH 32
#define ROCKS 2
#define ROCKWIDTH 4
#define ROCKSTYLES 16

static int8_t _height[256], _snake[8], _rockabshigh[256], _rockabslow[256];

int8_t _offset[2] = { 80, -80 }; 		// gap between top and bottom
uint8_t _rocky[ROCKS] = {0, 4}; 			// index into rockyhigh/low styles
int8_t _rockoffset[ROCKS] = { 0, 0 }; 	// position between the walls
uint8_t _rockstart[ROCKS] = {15,31}; 	// offset from left where rocks first appear

static uint8_t RANGE(unsigned int idx, unsigned int low, unsigned int high, long line, char *name) {
	if ((idx < low) || (idx > high)) {
  		for (;;);
  		(void)line; (void)name;
  	}

  	return (int8_t)idx;
}

#define XRANGE(i,low,high,line,name) _RANGE(i,low,high,line,name)
#define height(x) _height[RANGE(x,0,255,__LINE__,"height")]
#define snake(x) _snake[RANGE(x,0,7,__LINE__,"snake")]
#define rockabshigh(x) _rockabshigh[RANGE(x,0,255,__LINE__,"rockabshigh")]
#define rockabslow(x) _rockabslow[RANGE(x,0,255,__LINE__,"rockabslow")]
#define offset(x) _offset[RANGE(x,0,1,__LINE__,"offset")]
#define rocky(x) _rocky[RANGE(x,0,1,__LINE__,"rocky")]
#define rockoffset(x) _rockoffset[RANGE(x,0,1,__LINE__,"rockoffset")]
#define rockstart(x) _rockstart[RANGE(x,0,1,__LINE__,"rockstart")]

const int8_t _rockyhigh[ROCKWIDTH*ROCKSTYLES] = {
	0,  4, 10, 2,   -4,  8,  2, -2, 0,  4, 10, 2,   -4,  8,  2, -2,
	0,  4, 10, 2,   -4,  8,  2, -2, 0,  4, 10, 2,   -4,  8,  2, -2,
	0,  4, 10, 2,   -4,  8,  2, -2, 0,  4, 10, 2,   -4,  8,  2, -2,
	0,  4, 10, 2,   -4,  8,  2, -2, 0,  4, 10, 2,   -4,  8,  2, -2,
};

#define rockyhigh(x) _rockyhigh[RANGE(x,0,ROCKWIDTH*ROCKSTYLES-1,__LINE__,"rockyhigh")]
const int8_t _rockylow[ROCKWIDTH*ROCKSTYLES] = {
	0, -6, -2, 2,   -4, -6, -4, -2, 0, -6, -2, 2,   -4, -6, -4, -2,
	0, -6, -2, 2,   -4, -6, -4, -2, 0, -6, -2, 2,   -4, -6, -4, -2,
	0, -6, -2, 2,   -4, -6, -4, -2, 0, -6, -2, 2,   -4, -6, -4, -2,
	0, -6, -2, 2,   -4, -6, -4, -2, 0, -6, -2, 2,   -4, -6, -4, -2,
};
#define rockylow(x) _rockylow[RANGE(x,0,ROCKWIDTH*ROCKSTYLES-1,__LINE__,"rockylow")]

static int8_t rand8(uint8_t max) {
	return (int8_t)(((int) (Random() & (max - 1))) - ((int) max >> 1));
}

static void check_for_next_rock(uint8_t base) {
	uint8_t rock;
	uint8_t i;

	for (rock = 0; rock < ROCKS; rock++) {
		if (rockstart(rock) == base) { // dropping off left
    		for (i = 0; i < ROCKWIDTH; i++) { // wipe departing rock limits
				rockabshigh((base+i)&255) = -128;
				rockabslow((base+i)&255) = -128;
			}

			// now create new rock at RHS of screen
			rockstart(rock) = (base+DISPLAY_WIDTH)&255;
			rockoffset(rock) = height((base+DISPLAY_WIDTH)&255);

			if (Random()&1) {
        		rockoffset(rock) += (int)((unsigned int)Random() % (unsigned int)((unsigned int)offset(0)-14U));
      		}
			else {
        		rockoffset(rock) -= (int)((unsigned int)Random() % (unsigned int)((unsigned int)offset(0)-14U));
      		}
    	}
  	}
}

#define SEX5(i) (((int)(i)<<3)>>3)
static void do_explosion(int8_t y, int8_t x) {
	int8_t i;
	Moveto_d(y, x);

	for (i = 0; i < 16; i++) {
		Draw_Line_d(y=SEX5((Random()&31)), x=SEX5((Random()&31)));
		Draw_Line_d(-y, -x);
	}
}

int main(void) {
	const int8_t VERTICAL = 32;
	uint8_t timeout, i, j, base, xstep, movement;
	int8_t x, delta;

SOFT_RESTART:
	timeout = 225;

	offset(0) = 80;
	offset(1) = -80; // gap between top and bottom

	rocky(0) = 0;
	rocky(1) = 4;

	rockoffset(0) = 0;
	rockoffset(1) = 0; // position between the walls

	rockstart(0) = 15;
	rockstart(1) = 31;

	base = 0, xstep = 1, movement = 1; delta = 1;

	for (i = 0; i < 8; i++)
		snake(i) = 0;

		i = 0;
		do {
			rockabshigh(i) = -128;
			rockabslow(i) = -128;

			i = (i+1)&255;
		} while (i);

		height(0) = rand8(64);
		height(128) = rand8(64);
	
		for (j = (unsigned int) VERTICAL; j > 1; j /= 2) { // iterate like recursion
			i = 0;

			do { // subdivide heights
				height((base + i) & 255) += rand8(j);
				height((base + i + (j >> 1)) & 255) = height((base + i) & 255) + rand8(j);

				i = (i + j) & 255;
			} while (i);
		}

		i = 0;
		do { // linearly interpret 4 steps
			int8_t from = height((base + i) & 255), to = height((base + i + 4) & 255), diff = to - from;
			height((base + i + 2) & 255) = from + (diff >> 1);
			height((base + i + 1) & 255) = from + (diff >> 2);
			height((base + i + 3) & 255) = to - (diff >> 2);
			i = (i + 4) & 255;
		} while (i);

		// MAIN GAME LOOP
		while (TRUE) { 
			int8_t last, YJoy;
			uint8_t line;

			check_for_next_rock(base);

			Wait_Recal();
			controller_enable_1_y();
			Joy_Digital();

			YJoy = 0;

			if (controller_joystick_1_y() < -10)
				YJoy = -2;
			else if (controller_joystick_1_y() > 10)
				YJoy = 2;

			snake((base+7)&7) = snake((base+6)&7) + YJoy;

			Reset0Ref();
			Intensity_a (0x7F);
			set_scale (127);

			// draw snake
			if (delta == 0) {
				do_explosion((snake((base + 0)&7)), -128+8*8);
				timeout++;

				if (timeout == 0) {
					goto SOFT_RESTART;
				}
			} 
			else {
				Moveto_d(last = (snake((base + 0)&7)), -128);  // tail (0)

				for (i = 1; i < 8; i++) { // to head... (7)
					Draw_Line_d ((snake((base + i)&7)) - last, 8);
					last = snake((base + i)&7);
				}
			}

			// draw rocks
			{
				uint8_t rock, x;
				
				for (x = 0; x < DISPLAY_WIDTH; x++) { // scan across same area as is displayed
					for (rock = 0; rock < 2; rock++) { // check every rock
						// does a rock start at this screen position?
						if (((base+x)&255) == rockstart(rock)) {
							uint8_t stylebase;
							stylebase = rocky(rock);

							// upper half of rock
							Reset0Ref();
							Intensity_a(0x7F);
							set_scale(127);
							Moveto_d(last = rockoffset(rock)+rockyhigh((stylebase+0)&(ROCKWIDTH*ROCKSTYLES-1)), (int)(-128+x*8));
							
							rockabshigh((base+x+0)&255) = last;
							
							for (i = 1; i < ROCKWIDTH; i++) {
								Draw_Line_d (rockoffset(rock)+rockyhigh((stylebase+i)&(ROCKWIDTH*ROCKSTYLES-1)) - last, 8);
								rockabshigh((base+x+i)&255) = last = rockoffset(rock)+rockyhigh((stylebase+i)&(ROCKWIDTH*ROCKSTYLES-1));
							}

							// lower half of rock
							Reset0Ref();
							Intensity_a(0x4F);
							set_scale(127);
							Moveto_d(last = rockoffset(rock)+rockylow((stylebase+0)&(ROCKWIDTH*ROCKSTYLES-1)), (int)(-128+x*8));

							rockabslow((base+x+0)&255) = last;

							for (i = 1; i < ROCKWIDTH; i++) {
								Draw_Line_d (rockoffset(rock)+rockylow((stylebase+i)&(ROCKWIDTH*ROCKSTYLES-1)) - last, 8);
								rockabslow((base+x+i)&255) = last = rockoffset(rock)+rockylow((stylebase+i)&(ROCKWIDTH*ROCKSTYLES-1));
							}
						}
					}
				}
			}

			// draw cave
			for (line = 0; line < 2; line++) { // upper and lower walls
				int8_t vertical = offset(line);
				i = 0;
				x = -128;

				Reset0Ref();
				Intensity_a((line == 0 ? (unsigned int) 0x7F : (unsigned int)0x3F));
				set_scale(127);

				Moveto_d (last = vertical + height((base + i) & 255), x);

				do {
					x++;
					x &= (int)255;
					Draw_Line_d ((vertical + height((base + i)&255)) - last, 8);

					last = vertical + height((base + i)&255);
					i += xstep; i &= 255;
				} while (i < DISPLAY_WIDTH);

				if ((line == 0) && (snake((base+7)&7) >= vertical+height((base+7)&255))) {
					delta = 0;
					movement = 0; // end game when hit roof
				}
				else if ((line == 1) && (snake((base+7)&7) <= vertical+height((base+7)&255))) {
					delta = 0; 
					movement = 0; // end game when hit floor
				}
			}

			// test hitting rocks?
			if ((rockabshigh((base+7)&255) != -128)
				&& (snake((base+7)&7) <= rockabshigh((base+7)&255))
				&& (snake((base+7)&7) >= rockabslow((base+7)&255))
			) {
				delta = 0;
				movement = 0; // CRASHED!
			}

			// scroll
			base = (base + movement) & 255;

			if (base == 0) {
			offset(0) -= delta;
			offset(1) += delta; // 1 for test, 1 for live

			if (offset(0) <= 25) { // sort out signs later
				delta = 0; movement = 0; // post GAME OVER and do fanfare when cave is too narrow.
			}
		}
	}

	return 0;
}

