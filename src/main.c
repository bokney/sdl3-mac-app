
#include <SDL3/SDL.h>
#include <SDL3/SDL_main.h>
#include <SDL3_image/SDL_image.h>
#include <SDL3_mixer/SDL_mixer.h>

int main(int argc, char* argv[]) {
    SDL_Window *window =  NULL;
    SDL_Renderer *renderer = NULL;
    SDL_Texture *texture = NULL;

    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS | SDL_INIT_AUDIO) < 0) {
        SDL_Log("SDL_Init error: %s\n", SDL_GetError());
        return -1;
    }

    SDL_AudioSpec desired;
    desired.freq = 44100;
    desired.format = MIX_DEFAULT_FORMAT;
    desired.channels = 2;
    
    if (!Mix_OpenAudio(0, &desired)) {
        SDL_Log("SDL_mixer could not initialize! SDL_mixer Error: %s\n", SDL_GetError());
        return -5;
    }

    window = SDL_CreateWindow("Minature Mouseketeer", 800, 600, 0);
    if (window == NULL) {
        SDL_Log("SDL_CreateWindow error: %s\n", SDL_GetError());
        return -2;
    }
    
    renderer = SDL_CreateRenderer(window, NULL);
    if (renderer == NULL) {
        SDL_Log("SDL_CreateRenderer error: %s\n", SDL_GetError());
        return -3;
    }

    SDL_Log("SDL3 initialised.");

    texture = IMG_LoadTexture(renderer, "resources/miniature_mousketeer.jpeg");
    if (!texture) {
        SDL_Log("IMG_LoadTexture error: %s\n", SDL_GetError());
        return -4;
    }

    Mix_Music *music = Mix_LoadMUS("resources/boss_fast_version.wav");
    if (!music) {
        SDL_Log("SDL_mixer Error: %s\n", SDL_GetError());
        return -6;
    }
    Mix_PlayMusic(music, -1);

    int w = 0, h = 0;
    SDL_FRect dst;
    const float scale = 4.0f;

    SDL_GetRenderOutputSize(renderer, &w, &h);
    SDL_SetRenderScale(renderer, scale, scale);
    SDL_GetTextureSize(texture, &dst.w, &dst.h);
    dst.x = ((w / scale) - dst.w) / 2;
    dst.y = ((h / scale) - dst.h) / 2;

    SDL_Event event;
    int quit = 0;
    while (!quit) {
        while (SDL_PollEvent(&event)) {
            switch (event.type) {
            case SDL_EVENT_QUIT:
                SDL_Log("SDL3 event quit.");
                quit = 1;
                break;
            default:
                break;
            }
        }
        SDL_SetRenderDrawColor(renderer, 0, 0, 0xff, 0xff);
        SDL_RenderClear(renderer);
        SDL_RenderTexture(renderer, texture, NULL, &dst);
        SDL_RenderPresent(renderer);
        SDL_Delay(1);
    }

    SDL_Log("SDL3 shutdown.");
    Mix_FreeMusic(music);
    Mix_CloseAudio();
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();

    return 0;
}
