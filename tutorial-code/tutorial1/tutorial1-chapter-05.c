// 
// Author: Roger Boesch
// File:   tutorial1-chapter-05.c
// Info:   Tutorial, Programming Games in C for the Vectrex
//         Pong game, Chapter 5: Moving Game Objects
//
// Created for Classics Coder and CMOC by Roger Boesch
//

#include <vectrex.h>

#pragma vx_copyright "2020"
#pragma vx_title_pos 0,-80
#pragma vx_title_size -8, 80
#pragma vx_title "g PONG"
#pragma vx_music vx_music_1

#define DEFAULT_SCALE 0x7F
#define DEFAULT_INTENSITY 0x7F
#define PLAYER_1 JOYSTICK_1
#define PLAYER_2 JOYSTICK_2

// Game settings
int8_t ball_speed_x = 2;
int8_t ball_speed_y = 1;

// Game structure used to hold data for each game object
struct game_object {
    int8_t x;         
    int8_t y;         
    uint8_t speed;
    int8_t scale;         

    int8_t x1, y1; // top-left
    int8_t x2, y2; // bottom-right
};

// Game variables
static struct game_object paddle[2];
static struct game_object ball;
static struct game_object border;

// Vertices used for later drawing
static const int8_t paddle_vertices[] = {
    3,       // Size
    0,   5,  // Top left is local (0,0)
    -20, 0,  
    0,   -5, 
    20,  0   
};

static const int8_t ball_vertices[] = {
    4,                   
    4 / 2,  4 / 2,
    -4,     -4,   
    4 / 2,  4 / 2,
    -4 / 2, 4 / 2,
    4,      -4,  
};

static const int8_t border_vertices[] = {
    7,          
    127,  0,    
    127,  0,    
    0,    127,  
    0,    127,  
    -128, 0,    
    -128, 0,    
    0,    -128, 
    0,    -128, 
};

// Game object helpers
BOOL game_object_is_colliding(struct game_object *object1, struct game_object *object2) {
    return FALSE;
}

void game_object_draw(struct game_object *object, const int8_t vertices[]) {
    zero_beam();
    
    set_scale(object->scale);
    moveto_d(object->y, object->x);
    draw_vlc(vertices);
}

// Initialise
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
    paddle[PLAYER_1].x = -100; paddle[PLAYER_1].y = 0;
    paddle[PLAYER_1].x1 = 0; paddle[PLAYER_1].y1 = 0;
    paddle[PLAYER_1].x2 = 5; paddle[PLAYER_1].y2 = 20;
    paddle[PLAYER_1].scale = DEFAULT_SCALE;

    paddle[PLAYER_2].x = 100; paddle[PLAYER_2].y = 0;
    paddle[PLAYER_2].x1 = 0; paddle[PLAYER_2].y1 = 0;
    paddle[PLAYER_2].x2 = 5; paddle[PLAYER_2].y2 = 20;
    paddle[PLAYER_2].scale = DEFAULT_SCALE;

    ball.x = 0;
    ball.y = 50;
    ball.scale = DEFAULT_SCALE;

    border.x = -127;
    border.y = -127;
    border.scale = DEFAULT_SCALE;
}

void game_input() {
}

void game_update() {
    ball.x += ball_speed_x;
    ball.y += ball_speed_y;
}

void game_draw() {
    game_object_draw(&border, &border_vertices);
    game_object_draw(&paddle[PLAYER_1], &paddle_vertices);
    game_object_draw(&paddle[PLAYER_2], &paddle_vertices);
    game_object_draw(&ball, &ball_vertices);
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
