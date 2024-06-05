#ifndef __vectrex_bios_h__
#define __vectrex_bios_h__

#include <vectrex/types.h>

// ---------------------------------------------------------------------------
// New gcc style wrappers

void wait_recal();
void intensity_a(uint8_t i);
void reset0ref();
void print_str_d(int8_t y, int8_t x, char *string);
void dot_d(int8_t y, int8_t x);
void dot_list(uint8_t nr_dots, int8_t *list);
void moveto_d(uint8_t y, uint8_t x);
void draw_line_d(int8_t y, int8_t x);
void draw_vl_a(uint8_t nr_lines, int8_t *list);
void draw_vlc(int8_t *list);
void draw_pat_vl_a(uint8_t pattern, uint8_t nr_lines, int8_t *list);
void rot_vl_ab(int8_t angle, uint8_t nr_points, int8_t *points, int8_t *out_points);
void init_music_chk(int8_t *music);
void do_sound();
void cold_start();
void warm_start();
void init_via();
void init_os_ram();
void init_os();
void set_refresh(uint16_t value);
int8_t random();
uint8_t read_btns();
void joy_digital();
void joy_analog();
void zero_beam();
void clear_sound();
void dp_to_d0();
void dp_to_c8();
void explosion_sound();
void sound_byte(uint8_t reg, uint8_t value);

// ---------------------------------------------------------------------------
// Helper functions to simplyify access to some static ram vars (keeped from previous implementation)

void set_text_size(int8_t height, int8_t width);
void set_scale(int8_t scale);
void music_set_flag(uint8_t flag); // REMOVE LATER, direct access to vars
uint8_t music_get_flag();
void random_seed(uint8_t seed1, uint8_t seed2, uint8_t seed3);
void zero_beam();
uint8_t abs(int8_t value);
#define set_beam_intensity intensity_a

// ---------------------------------------------------------------------------
// C-style print function

void print_str_c(int8_t y, int8_t x, char *string);

// ---------------------------------------------------------------------------
// Controller/Joystick helpers

#define JOYSTICK_1 0
#define JOYSTICK_2 1

void controller_enable_1_x();
void controller_enable_1_y();
void controller_enable_2_x();
void controller_enable_2_y();
void controller_disable_1_x();
void controller_disable_1_y();
void controller_disable_2_x();
void controller_disable_2_y();

void controller_check_buttons();
uint8_t controller_buttons_pressed();
uint8_t controller_buttons_held();

uint8_t controller_button_1_1_pressed();
uint8_t controller_button_1_2_pressed();
uint8_t controller_button_1_3_pressed();
uint8_t controller_button_1_4_pressed();
uint8_t controller_button_2_1_pressed();
uint8_t controller_button_2_2_pressed();
uint8_t controller_button_2_3_pressed();
uint8_t controller_button_2_4_pressed();

uint8_t controller_button_1_1_held();
uint8_t controller_button_1_2_held();
uint8_t controller_button_1_3_held();
uint8_t controller_button_1_4_held();
uint8_t controller_button_2_1_held();
uint8_t controller_button_2_2_held();
uint8_t controller_button_2_3_held();
uint8_t controller_button_2_4_held();

void controller_check_joysticks();
int8_t controller_joystick_1_x();
int8_t controller_joystick_1_y();
int8_t controller_joystick_2_x();
int8_t controller_joystick_2_y();
uint8_t controller_joystick_1_leftChange();
uint8_t controller_joystick_1_rightChange();
uint8_t controller_joystick_1_downChange();
uint8_t controller_joystick_1_upChange();
uint8_t controller_joystick_1_left();
uint8_t controller_joystick_1_right();
uint8_t controller_joystick_1_down();
uint8_t controller_joystick_1_up();
uint8_t controller_joystick_2_left();
uint8_t controller_joystick_2_right();
uint8_t controller_joystick_2_down();
uint8_t controller_joystick_2_up();

// ---------------------------------------------------------------------------
// Music support (not completely implemented yet)

void play_music(void* music);
void stop_music();
int8_t is_music_playing();
void play_sound(const void *sound_block);
void stop_sound();
void update_audio();
void wait_for_beam();

#define vx_music_1 (char *)0xFD0D
#define vx_music_2 (char *)0xFD1D
#define vx_music_3 (char *)0xFD81
#define vx_music_4 (char *)0xFDD3
#define vx_music_5 (char *)0xFE38
#define vx_music_6 (char *)0xFE76
#define vx_music_7 (char *)0xFEC6
#define vx_music_8 (char *)0xFEF8
#define vx_music_9 (char *)0xFF26
#define vx_music_10 (char *)0xFF44
#define vx_music_11 (char *)0xFF62
#define vx_music_12 (char *)0xFF7A
#define vx_music_13 (char *)0xFF8F

// Notes
#define tone_a_low              0
#define tone_a_high             1
#define tone_b_low              2
#define tone_b_high             3
#define tone_c_low              4
#define tone_c_high             5
#define noise                   6
#define mixer_control           7
#define amplitude_a             8
#define amplitude_b             9
#define amplitude_c            10
#define envelope_periode_low   11
#define envelope_periode_high  12
#define envelope_shape         13
#define io_port_a_datastore    14
#define io_port_b_dataStore     1

// ---------------------------------------------------------------------------
// Next section keeped for compatibility reasons (not used anymore)

#define JOY1_BTN1 0
#define JOY1_BTN2 1
#define JOY1_BTN3 2
#define JOY1_BTN4 3

#define JOY2_BTN1 4
#define JOY2_BTN2 5
#define JOY2_BTN3 6
#define JOY2_BTN4 7

#define JOY1_BTN1_MASK (1 << JOY1_BTN1)
#define JOY1_BTN2_MASK (1 << JOY1_BTN2)
#define JOY1_BTN3_MASK (1 << JOY1_BTN3)
#define JOY1_BTN4_MASK (1 << JOY1_BTN4)

#define JOY2_BTN1_MASK (1 << JOY2_BTN1)
#define JOY2_BTN2_MASK (1 << JOY2_BTN2)
#define JOY2_BTN3_MASK (1 << JOY2_BTN3)
#define JOY2_BTN4_MASK (1 << JOY2_BTN4)

#define JOY_UP 0
#define JOY_DOWN 1
#define JOY_LEFT 2
#define JOY_RIGHT 3

#define JOY_UP_MASK (1 << JOY_UP)
#define JOY_DOWN_MASK (1 << JOY_DOWN)
#define JOY_LEFT_MASK (1 << JOY_RIGHT)
#define JOY_RIGHT_MASK (1 << JOY_LEFT)

#define JOY_UP_MASK_ASM 1
#define JOY_DOWN_MASK_ASM 2
#define JOY_LEFT_MASK_ASM 4
#define JOY_RIGHT_MASK_ASM 8

#endif // __vectrex_bios_h__
