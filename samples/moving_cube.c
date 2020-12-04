// 
// File:   moving_cube.c
// Author: Roger Boesch
// Info:   Shows basic uasge of joystick
//
// Created for Classics Coder and CMOC by Roger Boesch
//

#include <vectrex.h>

#pragma vx_copyright "2020"
#pragma vx_title_pos 0,-80
#pragma vx_title_size -8, 80
#pragma vx_title "g CLASSICS CODER"
#pragma vx_music vx_music_1

#define MAX_BRIGHTNESS (0x7f)

int8_t rectangle[8] = {
	40, 0,
	0, 40,
	-40, 0,
	0, -40
};

int main() {
	int8_t x = -20;
	int8_t y = -20;

    while(1) {
        wait_recal();
    
		controller_enable_1_x();
		controller_enable_1_y();
    		controller_check_joysticks();

		if (controller_joystick_1_x() < 0) y -= 1;
		if (controller_joystick_1_x() > 0) y += 1;
		if (controller_joystick_1_y() < 0) x -= 1;
		if (controller_joystick_1_y() > 0) x += 1;

        intensity_a(MAX_BRIGHTNESS);
        moveto_d(x, y);
        draw_vl_a(4, rectangle);
    }

    return 0;
}
