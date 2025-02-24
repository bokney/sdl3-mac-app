
DEPS_DIR         := deps
SDL3_REPO        := https://github.com/libsdl-org/SDL.git
SDL3_IMAGE_REPO  := https://github.com/libsdl-org/SDL_image.git

SDL3_DIR         := $(DEPS_DIR)/sdl3
SDL3_IMAGE_DIR   := $(DEPS_DIR)/sdl3_image

SDL3_BUILD_DIR       := $(SDL3_DIR)/build
SDL3_IMAGE_BUILD_DIR := $(SDL3_IMAGE_DIR)/build

all: deps build

deps: $(SDL3_DIR) $(SDL3_IMAGE_DIR)

$(SDL3_DIR):
	@mkdir -p $(DEPS_DIR)
	@git clone $(SDL3_REPO) $(SDL3_DIR)

$(SDL3_IMAGE_DIR):
	@mkdir -p $(DEPS_DIR)
	@git clone $(SDL3_IMAGE_REPO) $(SDL3_IMAGE_DIR)

build: build-sdl3 build-sdl3_image

build-sdl3:
	@echo "Building SDL3..."
	@mkdir -p $(SDL3_BUILD_DIR)
	@cd $(SDL3_BUILD_DIR) && \
	  cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$(CURDIR)/$(SDL3_DIR)/install && \
	  $(MAKE) && $(MAKE) install

build-sdl3_image:
	@echo "Building SDL3_image..."
	@mkdir -p $(SDL3_IMAGE_BUILD_DIR)
	@cd $(SDL3_IMAGE_BUILD_DIR) && \
	  cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$(CURDIR)/$(SDL3_DIR)/install && \
	  $(MAKE)

clean:
	@echo "Cleaning build directories..."
	@rm -rf $(SDL3_BUILD_DIR) $(SDL3_IMAGE_BUILD_DIR)
