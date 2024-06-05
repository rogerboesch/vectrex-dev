// 
// Author: Roger Boesch
// File:   tutorial1-chapter-10.c
// Info:   Tutorial, Programming Games in C for the Vectrex
//         Pong game, Chapter 10: Final version of tutorial 1 (more in tutorial 2)
//
// Created for Classics Coder and CMOC by Roger Boesch
//

#include <vectrex.h>
#include <vectrex/stdlib.h>

#pragma vx_copyright "2020"
#pragma vx_title_pos 0,-80
#pragma vx_title_size -8, 80
#pragma vx_title "g PONG"
#pragma vx_music vx_music_1

// Screen settings
const uint8_t screen_width = 255;
const uint8_t screen_height = 255;
const int8_t screen_max_x = 127;
const int8_t screen_min_x = -128;
const int8_t screen_max_y = 127;
const int8_t screen_min_y = -128;

#define DEFAULT_SCALE 0x7F
#define DEFAULT_INTENSITY 0x7F
#define PLAYER_1 JOYSTICK_1
#define PLAYER_2 JOYSTICK_2

// Game settings
int8_t paddle_speed = 4;
int8_t ball_speed_x = 2;
int8_t ball_speed_y = 1;
int8_t score_player1 = 0;
int8_t score_player2 = 0;

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

// Debug helpers
void debug_str(uint8_t line, char* str) {
    zero_beam();

	print_str_c(-120+(line*20), -120, str);    
}

void game_object_dump(uint8_t line, struct game_object *object) {
    zero_beam();

	char temp[100];
    sprintf(temp, "X:%d,Y:%d", object->x, object->y);
    debug_str(line, temp);

    sprintf(temp, "X1:%d,Y1:%d,X2:%d,Y2:%d", object->x1, object->y1, object->x2, object->y2);
    debug_str(line+1, temp);
}

// Game object helpers
BOOL game_object_is_colliding(struct game_object *object1, struct game_object *object2) {
    return ((object1->x + 128 + object1->x1) < (object2->x + 128 + object2->x2) &&    // Left vs. Right
            (object1->x + 128 + object1->x2) > (object2->x + 128 + object2->x1) &&    // Right vs. Left
            (object1->y + 128 - object1->y2) < (object2->y + 128 + object2->y1) && 	  // Bottom vs. Top
    		(object1->y + 128 + object1->y1) > (object2->y + 128 - object2->y2));     // Top vs. Bottom
}

void game_object_draw(struct game_object *object, const int8_t vertices[]) {
    zero_beam();
    
    set_scale(object->scale);
    moveto_d(object->y, object->x);
    draw_vlc(vertices);
}

// Game specific helpers
BOOL paddle_is_on_top(uint8_t number) {
    int8_t top = paddle[number].y + paddle[number].y1;
    if (top <= (screen_max_x - paddle_speed))
        return FALSE;
    
    return TRUE;
}

BOOL paddle_is_on_bottom(uint8_t number) {
    int8_t bottom = paddle[number].y - paddle[number].y2;

    if (bottom >= (screen_min_y + paddle_speed))
        return FALSE;

	return TRUE;
}

void collission_detection() {
    if (game_object_is_colliding(&ball, &paddle[PLAYER_1])) {
        ball_speed_x = -ball_speed_x;

        while (game_object_is_colliding(&ball, &paddle[PLAYER_1])) {
            ball.x += ball_speed_x;
            ball.y += ball_speed_y;
        }
    }

    if (game_object_is_colliding(&ball, &paddle[PLAYER_2])) {
        ball_speed_x = -ball_speed_x;

        while (game_object_is_colliding(&ball, &paddle[PLAYER_2])) {
            ball.x += ball_speed_x;
            ball.y += ball_speed_y;
        }
    }
}

void check_ball_position() {
    int ballSpeedX = abs(ball_speed_x);
    int ballSpeedY = abs(ball_speed_y);

    // Bounce ball
    if ((ball.y + ball.y1 >= (screen_max_y - ballSpeedY)) ||
        ball.y + ball.y2 <= (screen_min_y + ballSpeedY)) {

        ball_speed_y = -ball_speed_y;
		
		ball.x += ball_speed_x;
		ball.y += ball_speed_y;
    }

    // Ball touches border: Point for player1 if left border, otherwise for player 2
    BOOL ball_is_on_right_side = ball.x + ball.x2 >= (screen_max_x - ballSpeedX);
    if (ball_is_on_right_side || ball.x + ball.x1 <= (screen_min_x + ballSpeedX)) {
        ball_speed_x = -ball_speed_x;

		ball.x += ball_speed_x;
		ball.y += ball_speed_y;

        if (ball_is_on_right_side) {
            ++score_player1;
        }
        else {
            ++score_player2;
        }
     }
}

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
    paddle[PLAYER_1].x = -100; paddle[PLAYER_1].y = 0;
    paddle[PLAYER_1].x1 = 0; paddle[PLAYER_1].y1 = 0;
    paddle[PLAYER_1].x2 = 5; paddle[PLAYER_1].y2 = 20;
    paddle[PLAYER_1].scale = DEFAULT_SCALE;

    paddle[PLAYER_2].x = 100; paddle[PLAYER_2].y = 0;
    paddle[PLAYER_2].x1 = 0; paddle[PLAYER_2].y1 = 0;
    paddle[PLAYER_2].x2 = 5; paddle[PLAYER_2].y2 = 20;
    paddle[PLAYER_2].scale = DEFAULT_SCALE;

    ball.x = 0; ball.y = 50;
    ball.x1 = 0; ball.y1 = 0;
    ball.x2 = 8; ball.y2 = 8;
    ball.scale = DEFAULT_SCALE;

    border.x = -127;
    border.y = -127;
    border.scale = DEFAULT_SCALE;
}

void game_input() {
    controller_check_joysticks();

    controller_enable_1_x();
    controller_enable_1_y();
    controller_enable_2_x();
    controller_enable_2_y();

    if (controller_joystick_1_up() && !paddle_is_on_top(PLAYER_1)) {
        paddle[PLAYER_1].y += paddle_speed;
    } 
    else if (controller_joystick_1_down() && !paddle_is_on_bottom(PLAYER_1)) {
        paddle[PLAYER_1].y -= paddle_speed;
    } 

    if (controller_joystick_2_up() && !paddle_is_on_top(PLAYER_2)) {
        paddle[PLAYER_2].y += paddle_speed;
    } 
    else if (controller_joystick_2_down() && !paddle_is_on_bottom(PLAYER_2)) {
        paddle[PLAYER_2].y -= paddle_speed;
    } 
}

void game_update() {
    ball.x += ball_speed_x;
    ball.y += ball_speed_y;

    check_ball_position();
    collission_detection();
}

void game_draw() {
    game_object_draw(&border, &border_vertices);
    game_object_draw(&paddle[PLAYER_1], &paddle_vertices);
    game_object_draw(&paddle[PLAYER_2], &paddle_vertices);
    game_object_draw(&ball, &ball_vertices);

    char temp[40];

	zero_beam();
	sprintf(temp, "%d ", score_player1);
    print_str_c(120, -125, temp);

	zero_beam();
	sprintf(temp, " %d", score_player2);
    print_str_c(120, 80, temp);
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