#include <vectrex/bios.h>

#pragma vx_copyright "2020"
#pragma vx_title_pos 0,-80
#pragma vx_title_size -8, 80
#pragma vx_title "g CLASSICS CODER"
#pragma vx_music vx_music_1

int main() {
  while(1) {
    wait_retrace();
    intensity(0x7f);
    print_str_c( 0x10, -0x50, "HELLO WORLD!" );
  }
  
  return 0;
}
