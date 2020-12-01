//
//  Scalar
//
//  Not really a game, but a tech demo of programming the Vectrex.
//  It shows how to use scaling, animation, collision detection.
// 
//  If you have any questions regarding the code, contact me
//  via the method specified at  http://www.sebastianmihai.com
//  (operational in 2012), and I will try my best to help.
//
//  Sebastian Mihai, 2012
//  Converted to CMOC (Classics Coder Version) by Roger Boesch
//

#include <vectrex.h>

#pragma vx_copyright "2020"
#pragma vx_title_pos 0,-80
#pragma vx_title_size -8, 80
#pragma vx_title "g SCALAR"
#pragma vx_music vx_music_1

#define MAX_BRIGHTNESS (0x7f)

#define SCALE 120                  	
#define DOT_BRIGHTNESS 5   

#define ENEMY_SIZE 40
#define ANIMATION_FREQUENCY 30
#define ANIMATION_FRAMES 3
#define PLAYER_SPEED 2
#define BULLET_SPEED 10

void line_to(uint8_t x, uint8_t y) {
    intensity_a(0x7f);
	draw_line_d(y, x);
}

void move_to(uint8_t x, uint8_t y) {
	moveto_d(y, x);
}

void zero_beam() {
    intensity_a(0x7f);
	moveto_d(0, 0);
}

void draw_player(int8_t x ) {
	move_to(x, -120);
	move_to(0, -30);
	move_to(-5, 0);
	
	line_to(5, 15);
	line_to(5, -15);
	line_to(-10, 0);
	
	// back to middle and bottom of triangle
	move_to(5, 0);
	
	// and back to origin
	move_to(-x, 120);
	move_to(0, 30);
}

void draw_bullet(int8_t x, int8_t y) {
	move_to(x, y);
	line_to(0, 5);
	
	// back to origin
	move_to(0, -5);
	move_to(-x, -y);
}

void draw_enemy(int8_t x, int8_t y, uint8_t frame) {
	move_to(x, y);
	
	set_scale(frame*2);
	
	if (frame < ANIMATION_FREQUENCY) {
		move_to(-ENEMY_SIZE/2, ENEMY_SIZE/2);
		line_to(ENEMY_SIZE, 0);
		line_to(0, -ENEMY_SIZE);
		line_to(-ENEMY_SIZE, 0);
		line_to(0, ENEMY_SIZE);

		// back to center
		move_to(ENEMY_SIZE/2, -ENEMY_SIZE/2);
	}
	else if ( frame < 2*ANIMATION_FREQUENCY ) {
		line_to(-ENEMY_SIZE/2, ENEMY_SIZE/2);
		line_to(ENEMY_SIZE, 0);
		line_to(-ENEMY_SIZE/2, -ENEMY_SIZE/2);
		line_to(ENEMY_SIZE/2, -ENEMY_SIZE/2);
		line_to(-ENEMY_SIZE, 0);
		line_to(ENEMY_SIZE/2, ENEMY_SIZE/2);
	}
	else {
		move_to(-ENEMY_SIZE/2, ENEMY_SIZE/2);
		line_to(ENEMY_SIZE/2, -ENEMY_SIZE/2);
		line_to(ENEMY_SIZE/2, ENEMY_SIZE/2);
		line_to(0, -ENEMY_SIZE);
		line_to(-ENEMY_SIZE/2, ENEMY_SIZE/2);
		line_to(-ENEMY_SIZE/2, -ENEMY_SIZE/2);
		line_to(0, ENEMY_SIZE);

		// back to center
		move_to(ENEMY_SIZE/2, -ENEMY_SIZE/2);
	}
	
	set_scale(SCALE);
	
	// back to origin
	move_to( -x, -y );
}

int game_loop() {
	uint8_t i;
	int8_t x; // player x
	int8_t enemyX[5];
	int8_t enemyY[5];
	int8_t enemyAlive[5];
	int8_t bulletX, bulletY;
	uint8_t frame = ANIMATION_FREQUENCY;
	int8_t frameDelta = 2;
	uint8_t atLeastOneEnemyAlive;
	
	x = 0;
	bulletY = 127;
	bulletX = x;
	
	// enemy positions
	enemyX[0] =-100; enemyX[1] =-50; enemyX[2] = 0; enemyX[3] = 50; enemyX[4] = 100;
	enemyY[0] = 100; enemyY[1] = 80; enemyY[2] = 90;enemyY[3] = 80; enemyY[4] = 100;
	
	// As terrible as this repetition is, I could not get simple loops to work
	// It seems that during the later iterations in loops, the counter cannot be
	// used to index into arrays... couldn't figure out why.
	enemyAlive[0] = 1;
	enemyAlive[1] = 1;
	enemyAlive[2] = 1;
	enemyAlive[3] = 1;
	enemyAlive[4] = 1;
	
	while (1) {
		frame += frameDelta;
		
		//set_dp_c8();
		wait_recal();
		intensity_a(MAX_BRIGHTNESS);

		zero_beam();
		set_scale(SCALE);
		
		draw_player( x );

		if (bulletY <= 119) {
			draw_bullet(bulletX, bulletY);
			bulletY+=BULLET_SPEED;
		}
		else {
			bulletX = -125;
		}

		// did bullet hit an enemy?
		for (i=0; i<5; i++) {
			if (bulletY + 5 > enemyY[i] &&
				bulletX > enemyX[i] - ENEMY_SIZE/3 &&
				bulletX < enemyX[i] + ENEMY_SIZE/3) {
				enemyAlive[i] = 0;
			}
		}

		if (enemyAlive[0] == 1 ) draw_enemy(enemyX[0], enemyY[0], frame);
		if (enemyAlive[1] == 1 ) draw_enemy(enemyX[1], enemyY[1], frame);
		if (enemyAlive[2] == 1 ) draw_enemy(enemyX[2], enemyY[2], frame);
		if (enemyAlive[3] == 1 ) draw_enemy(enemyX[3], enemyY[3], frame);
		if (enemyAlive[4] == 1 ) draw_enemy(enemyX[4], enemyY[4], frame);
		
		if (controller_joystick_1_x() > 0 && x < 127-PLAYER_SPEED) {
			x += PLAYER_SPEED;
		}
		else if (controller_joystick_1_x()<0 && x > -127 + PLAYER_SPEED) {
			x -= PLAYER_SPEED;
		}
		
		if (( controller_joystick_1_y() > 0 || controller_buttons_pressed()) && bulletY > 119) {
			// fire a new bullet!
			bulletY = -120;
			bulletX = x;
		}
		
		// reset frame to reset animation
		if (frame >= ANIMATION_FRAMES * ANIMATION_FREQUENCY ) {
			frameDelta = -2;
		}
		else if (frame <= ANIMATION_FREQUENCY) {
			frameDelta = 2;
		}
		
		// bring beam to centre again, and print messages
		zero_beam();
		print_str_c(127, -50, "SCALAR");
		
		joy_digital();
		read_btns();

		// As terrible as this repetition is, I could not get simple loops to work
		// It seems that during the later iterations in loops, the counter cannot be
		// used to index into arrays... couldn't figure out why.
		if (enemyAlive[0] == 0 
		 	&& enemyAlive[1] == 0 
		 	&& enemyAlive[2] == 0
		 	&& enemyAlive[3] == 0
		 	&& enemyAlive[4] == 0) {
			return 0;
		 }
	}
}

int show_intro(void) {
	while(1) {
        wait_recal();
    
		controller_enable_1_x();
		controller_enable_1_y();
    		controller_check_joysticks();

		move_to(0, 0);
        intensity_a(0x7f);
		print_str_c(0, -90, "-- PRESS FIRE --");
		
		joy_digital();
		read_btns();
		
		if (controller_buttons_pressed()) {
			while (controller_buttons_pressed()) {
				read_btns();
			}

			return 0;
		}
	}
}

int main(void) {
	while (1) {
		show_intro();
		game_loop();
	}

	return 0;
}
