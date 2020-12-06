// 
// Author: Roger Boesch
// File:   tutorial1-chapter-02.c
// Info:   Tutorial, Programming Games in C for the Vectrex
//         Pong game, Chapter 2: Initializing the Vectrex
//
// Created for Classics Coder and CMOC by Roger Boesch
//

#include <vectrex.h>
#include <vectrex/stdlib.h>

// Game screen data
#pragma vx_copyright "2020"
#pragma vx_title_pos 0,-80
#pragma vx_title_size -8, 80
#pragma vx_title "g PONG"
#pragma vx_music vx_music_1

#define DEFAULT_INTENSITY 0x7F
#define DEFAULT_SCALE 0x7F

// Initialize
void vectrex_init() {
    set_beam_intensity(DEFAULT_INTENSITY);
    set_scale(DEFAULT_SCALE);

    stop_music();
    stop_sound();

    controller_enable_1_x();
    controller_enable_1_y();
    controller_enable_2_x();
    controller_enable_2_y();
}

// Game logic
void game_init() {
}

void game_input() {
}

void game_update() {
}

void game_draw() {
}

// Game loop
int main() {
    vectrex_init();

    game_init();

    while (TRUE) {
        wait_recal();

        game_input();
        game_update();
        game_draw();
    }

    return 0;
}
