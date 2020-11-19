#include <vectrex/bios.h>

int main() {
  while(1) {
    wait_retrace();
    intensity(0x7f);
    print_str_c( 0x10, -0x50, "HELLO WORLD!" );
  }
  
  return 0;
}
