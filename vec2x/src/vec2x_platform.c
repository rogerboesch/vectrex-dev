
#include <SDL.h>
#include <SDL_image.h>
#include "SDL2_gfxPrimitives.h"

#include "e8910.h"

#include "vec2x_platform.h"
#include "vec2x.h"

#define EMU_TIMER       20          // the emulators heart beats at 20 milliseconds
#define SCREEN_WIDTH    330*3/2
#define SCREEN_HEIGHT   410*3/2

static SDL_Window* g_window = NULL;
static SDL_Surface* g_screenSurface = NULL;
static SDL_Renderer* g_renderer = NULL;
static SDL_Surface* g_overlay = NULL;
static SDL_Texture* g_texture = NULL;

static int g_quit = 0;

static char *romfilename = "/Users/roger/vectrec/roms/romfast.bin";
static char *cartfilename = NULL;
static char *overlayname = "/Users/roger/vectrec/roms/empty.png";

static long scl_factor = 1;
static long offx = 0;
static long offy = 0;

void vec2x_platform_render(void) {
    SDL_SetRenderDrawColor(g_renderer, 0, 0, 0, 255);
    SDL_RenderClear(g_renderer);

    if (g_texture) {
        SDL_Rect dest_rect = {0, 0, SCREEN_WIDTH, SCREEN_HEIGHT};
        //SDL_BlitSurface(g_overlay, NULL, g_screenSurface, &dest_rect);
        SDL_RenderCopy(g_renderer, g_texture, NULL, &dest_rect);
    }

	int v;
	for (v = 0; v < vector_draw_cnt; v++) {
		Uint8 c = vectors_draw[v].color * 256 / VECTREX_COLORS;
        
		aalineRGBA(g_renderer, offx + vectors_draw[v].x0 / scl_factor, offy + vectors_draw[v].y0 / scl_factor, offx + vectors_draw[v].x1 / scl_factor, offy + vectors_draw[v].y1 / scl_factor, c, c, c, 0xff);
	}

    SDL_RenderPresent(g_renderer);
}

static int _vec2x_platform_setup(void) {
    if (SDL_Init(SDL_INIT_EVERYTHING) != 0) {
        printf("ERROR - SDL initialization failed: %s\n", SDL_GetError());
        return -1;
    }

    g_window = SDL_CreateWindow("Vec2X", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,SCREEN_WIDTH, SCREEN_HEIGHT, 0);
    
    Uint32 render_flags = SDL_RENDERER_ACCELERATED;
    g_renderer = SDL_CreateRenderer(g_window, -1, render_flags);

    g_screenSurface = SDL_GetWindowSurface(g_window);

    long sclx, scly;

    long screenx = SCREEN_WIDTH;
    long screeny = SCREEN_HEIGHT;

    sclx = ALG_MAX_X / SCREEN_WIDTH;
    scly = ALG_MAX_Y / SCREEN_HEIGHT;

    scl_factor = sclx > scly ? sclx : scly;
    scl_factor /= 2.0;
    
    offx = (screenx - ALG_MAX_X / scl_factor) / 2;
    offy = (screeny - ALG_MAX_Y / scl_factor) / 2;
    
    printf("Started.\n");
    
    return 1;
}

int _vec2x_platform_get_desktop_size(int* width, int* height) {
    SDL_DisplayMode mode;
    
    if (SDL_GetCurrentDisplayMode(0, &mode) != 0) {
        SDL_Log("SDL_GetCurrentDisplayMode failed: %s", SDL_GetError());
        *width = 0;
        *height = 0;
        
        return -1;
    }

    *width = mode.w;
    *height = mode.h;

    return 1;
}

static int _vec2x_platform_orientation(char* str) {
    if (strcmp(str, "right") == 0) {
        // Right align window
        int w,h;
        
        if (_vec2x_platform_get_desktop_size(&w, &h)) {
            SDL_SetWindowPosition(g_window, w-SCREEN_WIDTH, 0);
            printf("Right aligned at %d,%d.\n", w-SCREEN_WIDTH, 0);
        }
    }
    else {
        printf("Left aligned at %d,%d.\n", 0, 0);
    }

    SDL_SetWindowPosition(g_window, 0, 0);
    
    return 1;
}

static int _vec2x_platform_cleanup(void) {
    printf("Cleanup SDL");

    SDL_DestroyRenderer(g_renderer);
    SDL_DestroyWindow(g_window);
    SDL_Quit();
 
    return 1;
}

static void _vec2x_platform_load() {
	FILE *f;
    
	if (!(f = fopen(romfilename, "rb"))) {

		perror(romfilename);
		exit(EXIT_FAILURE);
	}
    
    if (fread(rom, 1, sizeof (rom), f) != sizeof (rom)){
		printf("Invalid rom length\n");
		exit(EXIT_FAILURE);
	}
	
    fclose(f);

    printf("ROM file loaded: %s\n", romfilename);

	memset(cart, 0, sizeof (cart));
	if (cartfilename) {
		FILE *f;
        
		if(!(f = fopen(cartfilename, "rb"))){
			perror(cartfilename);
			exit(EXIT_FAILURE);
		}

        fread(cart, 1, sizeof (cart), f);
		fclose(f);
        
        printf("Cartfile loaded: %s\n", cartfilename);
	}
}

static void _vec2x_platform_read_events() {
	SDL_Event e;
	while(SDL_PollEvent(&e)){
		switch(e.type){
			case SDL_QUIT:
				g_quit = 1;
				break;
			case SDL_KEYDOWN:
				switch(e.key.keysym.sym){
					case SDLK_ESCAPE:
						exit(EXIT_SUCCESS);
					case SDLK_a:
						snd_regs[14] &= ~0x01;
						break;
					case SDLK_s:
						snd_regs[14] &= ~0x02;
						break;
					case SDLK_d:
						snd_regs[14] &= ~0x04;
						break;
					case SDLK_f:
						snd_regs[14] &= ~0x08;
						break;
					case SDLK_LEFT:
						alg_jch0 = 0x00;
						break;
					case SDLK_RIGHT:
						alg_jch0 = 0xff;
						break;
					case SDLK_UP:
						alg_jch1 = 0xff;
						break;
					case SDLK_DOWN:
						alg_jch1 = 0x00;
						break;
					default:
						break;
				}
				break;
			case SDL_KEYUP:
				switch(e.key.keysym.sym){
					case SDLK_a:
						snd_regs[14] |= 0x01;
						break;
					case SDLK_s:
						snd_regs[14] |= 0x02;
						break;
					case SDLK_d:
						snd_regs[14] |= 0x04;
						break;
					case SDLK_f:
						snd_regs[14] |= 0x08;
						break;
					case SDLK_LEFT:
						alg_jch0 = 0x80;
						break;
					case SDLK_RIGHT:
						alg_jch0 = 0x80;
						break;
					case SDLK_UP:
						alg_jch1 = 0x80;
						break;
					case SDLK_DOWN:
						alg_jch1 = 0x80;
						break;
					default:
						break;
				}
				break;
			default:
				break;
		}
	}
}

void _vec2x_platform_emuloop() {
	Uint32 next_time = SDL_GetTicks() + EMU_TIMER;
	vec2x_reset();
    
	for (;;) {
		vec2x_emu((VECTREX_MHZ / 1000) * EMU_TIMER);

        _vec2x_platform_read_events();

        if (g_quit) {
            return;
        }
        
		{
			Uint32 now = SDL_GetTicks();
			if(now < next_time)
				SDL_Delay(next_time - now);
			else
				next_time = now;
			next_time += EMU_TIMER;
		}
	}
}

#define USE_IMG
void _vec2x_platform_load_overlay(const char *filename) {
#ifdef USE_IMG
	SDL_Surface* image;
	image = IMG_Load(filename);
    
	if (image) {
		g_overlay = image;
        g_texture = SDL_CreateTextureFromSurface(g_renderer, image);
        printf("Overlay loaded: %s\n", filename);
	}
    else{
		printf("IMG_Load: %s\n", IMG_GetError());
	}
#endif
}

int main(int argc, char *argv[]) {
    printf("\nStarting vec2x\n");
    printf("Usage: vec2x {orientation} {romfile} {cartfile} {overlay}\n\n");

    _vec2x_platform_setup();

    if (argc > 1)
        _vec2x_platform_orientation(argv[1]);
    if (argc > 2)
        romfilename = argv[2];
	if (argc > 3)
		cartfilename = argv[3];
	if (argc > 4)
        _vec2x_platform_load_overlay(argv[4]);

	_vec2x_platform_load();

	e8910_init_sound();
	_vec2x_platform_emuloop();
	e8910_done_sound();

    _vec2x_platform_cleanup();
    
	return 0;
}

