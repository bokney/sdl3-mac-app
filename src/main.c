
#include <SDL3/SDL.h>
#include <SDL3/SDL_image.h>
#include <stdio.h>
#include <stdbool.h>

#define WINDOW_WIDTH  800
#define WINDOW_HEIGHT 600

int main(int argc, char *argv[]) {
    // Initialize SDL video subsystem
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        printf("SDL_Init Error: %s\n", SDL_GetError());
        return 1;
    }

    // Initialize SDL_image for JPEG support
    int imgFlags = IMG_INIT_JPG;
    if (!(IMG_Init(imgFlags) & imgFlags)) {
        printf("IMG_Init Error: %s\n", IMG_GetError());
        SDL_Quit();
        return 1;
    }

    // Create an 800x600 window centered on the screen
    SDL_Window *window = SDL_CreateWindow("SDL3 Mac App", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, WINDOW_WIDTH, WINDOW_HEIGHT, 0);
    if (!window) {
        printf("SDL_CreateWindow Error: %s\n", SDL_GetError());
        IMG_Quit();
        SDL_Quit();
        return 1;
    }

    // Create a renderer with hardware acceleration
    SDL_Renderer *renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
    if (!renderer) {
        printf("SDL_CreateRenderer Error: %s\n", SDL_GetError());
        SDL_DestroyWindow(window);
        IMG_Quit();
        SDL_Quit();
        return 1;
    }

    // Load the JPEG image from the resources folder
    SDL_Surface *imageSurface = IMG_Load("resources/image.jpeg");
    if (!imageSurface) {
        printf("IMG_Load Error: %s\n", IMG_GetError());
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
        IMG_Quit();
        SDL_Quit();
        return 1;
    }

    // Create a texture from the loaded image
    SDL_Texture *texture = SDL_CreateTextureFromSurface(renderer, imageSurface);
    SDL_FreeSurface(imageSurface);
    if (!texture) {
        printf("SDL_CreateTextureFromSurface Error: %s\n", SDL_GetError());
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
        IMG_Quit();
        SDL_Quit();
        return 1;
    }

    // Main loop: Render the image and listen for the escape key or window close event
    bool quit = false;
    SDL_Event event;
    while (!quit) {
        while (SDL_PollEvent(&event)) {
            if (event.type == SDL_QUIT) {
                quit = true;
            }
            if (event.type == SDL_KEYDOWN) {
                if (event.key.keysym.sym == SDLK_ESCAPE) {
                    quit = true;
                }
            }
        }

        // Clear the renderer
        SDL_RenderClear(renderer);

        // Query texture dimensions to center the image
        int texW = 0, texH = 0;
        SDL_QueryTexture(texture, NULL, NULL, &texW, &texH);
        SDL_Rect dstRect;
        dstRect.x = (WINDOW_WIDTH - texW) / 2;
        dstRect.y = (WINDOW_HEIGHT - texH) / 2;
        dstRect.w = texW;
        dstRect.h = texH;

        // Copy the texture to the renderer and present
        SDL_RenderCopy(renderer, texture, NULL, &dstRect);
        SDL_RenderPresent(renderer);

        // Delay to cap the frame rate (~60 FPS)
        SDL_Delay(16);
    }

    // Clean up resources
    SDL_DestroyTexture(texture);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    IMG_Quit();
    SDL_Quit();

    return 0;
}
