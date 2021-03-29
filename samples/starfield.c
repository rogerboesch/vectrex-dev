// 
// File:   starfield.c
// Author: Malban
// Info:   Starfield example taken from http://malban.de/oldies/vectrex/vectrex-c-gcc
//
// Converted to Classics Coder and CMOC by Roger Boesch
//

#include <vectrex.h>

#pragma vx_copyright "2020"
#pragma vx_title_pos 0,-80
#pragma vx_title_size -8, 80
#pragma vx_title "g STARFIELD"
#pragma vx_music vx_music_1

#define MAX_BRIGHTNESS (0x7f)
#define TO_HALF_THREE 0
#define TO_THREE 1
#define TO_HALF_SIX 2
#define TO_SIX 3
#define TO_HALF_NINE 4
#define TO_NINE 5
#define TO_HALF_TWELF 6
#define TO_TWELF 7
#define HIGHEST_DIRECTION (TO_TWELF + 1)

#define HIGHEST_SPEED 4             // highest speed of the dots
#define SHOT_SCALE 120              // for positioning the dots on the screen
#define SHOTS 50                    // how many dots at one time?
#define DOT_BRIGHTNESS 5            // dot dwell time...
#define SHOT_INTERVALL 2            // how much time between reapearing

struct shot {
    signed short shot_counter;      // time keeper, when should it appear?
    int8_t direction;         
    uint8_t speed;
    int8_t x;
    int8_t y;
};

struct shot current_shots[SHOTS]; 

// This function sets up a random shop, going in one of eight
// possible directions from one end of the screen to another...

static void init_shot(struct shot *current_shot) {
    uint8_t choice = random() % 4;                          // start on which side? 
    uint8_t start = random();                               // start on which position? 
    current_shot->shot_counter = -1;                        // shotcounter negative -> active 
    current_shot->direction = random() % HIGHEST_DIRECTION; // random direction of shot 
    current_shot->speed = (random() & 3) + 1;               // random speed 
    
    if (choice == 0)  {                                     // do the starting 
        current_shot->y = -127;
        current_shot->x = start;
    }

    if (choice == 1) {
        current_shot->y = 127;
        current_shot->x = start;
    }
    
    if (choice == 2) {
        current_shot->y = start;
        current_shot->x = -127;
    }

    if (choice == 3) {
        current_shot->y = start;
        current_shot->x = 127;
    }
}

// Process one dot...

static void do_shot(struct shot *current_shot) {
 	moveto_d(0, 0);                  
 
    if (current_shot->shot_counter > 0) {  
        current_shot->shot_counter--;  
        
        if (current_shot->shot_counter == 0) {
            init_shot(current_shot);
        }

        return;                      
    }                             
    else {
        switch (current_shot->direction) {
            case TO_HALF_THREE: {  
                if ((current_shot->x > 120) || (current_shot->y > 120) ) {
                    current_shot->shot_counter = SHOT_INTERVALL;
                    return;
                }

                current_shot->x += current_shot->speed;
                current_shot->y += current_shot->speed;
                break;
            }

            case TO_THREE: {
                if (current_shot->x > 120) {
                    current_shot->shot_counter = SHOT_INTERVALL;
                    return;
                }

                current_shot->x += current_shot->speed;
                break;
            }

            case TO_HALF_SIX: {
                if ((current_shot->x > 120) || (current_shot->y < -120) ) {
                    current_shot->shot_counter = SHOT_INTERVALL;
                    return;
                }

                current_shot->x += current_shot->speed;
                current_shot->y -= current_shot->speed;
                break;
            }

            case TO_SIX: {
                if (current_shot->y < -120) {
                    current_shot->shot_counter = SHOT_INTERVALL;
                    return;
                }

                // otherwise process coordinated according to direction and speed 
                current_shot->y -= current_shot->speed;
                break;
            }

            case TO_HALF_NINE: {
                if ((current_shot->x < -120) || (current_shot->y < -120) ) {
                    current_shot->shot_counter = SHOT_INTERVALL;
                    return;
                }

                // otherwise process coordinated according to direction and speed 
                current_shot->x -= current_shot->speed;
                current_shot->y -= current_shot->speed;
                break;
            }

            case TO_NINE: {
                if (current_shot->x < -120) {
                    current_shot->shot_counter = SHOT_INTERVALL;
                    return;
                }

                // otherwise process coordinated according to direction and speed 
                current_shot->x -= current_shot->speed;
                break;
            }

            case TO_HALF_TWELF: {
                if ((current_shot->x < -120) || (current_shot->y > 120) ) {
                    current_shot->shot_counter = SHOT_INTERVALL;
                    return;
                }

                // otherwise process coordinated according to direction and speed 
                current_shot->x -= current_shot->speed;
                current_shot->y += current_shot->speed;
                break;
            }

            case TO_TWELF: {
                if (current_shot->y > 120) {
                    current_shot->shot_counter = SHOT_INTERVALL;
                    return;
                }

                // otherwise process coordinated according to direction and speed 
                current_shot->y += current_shot->speed;
                break;
            }
        
            default: {
                current_shot->shot_counter = SHOT_INTERVALL;
                return;
            }
        }
    }
        
    // write_ram(Vec_Dot_Dwell, DOT_BRIGHTNESS); 
    set_scale(SHOT_SCALE);                       
    dot_d(current_shot->x, current_shot->y); 
}

// Initialize all dots to starting defaults...
 
static void init_new_game(void) {
    uint8_t i;
    
    for (i=0; i<SHOTS; i++) {
        current_shots[i].shot_counter = 10;
    }
}

int main(void) {
    uint8_t i; 
      
    init_new_game();   

    while (TRUE) {
        wait_recal(); 
        intensity_a(MAX_BRIGHTNESS); 
    
        for (i=0; i < SHOTS; i++) {
            do_shot(&current_shots[i]); 
        }
    }

    return 0;
}
