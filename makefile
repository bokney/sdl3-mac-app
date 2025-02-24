
#------------------------------------------------------------------------------

DEPS_DIR         := deps
BUILD_DIR        := builds

SDL3_REPO        := https://github.com/libsdl-org/SDL.git
SDL3_IMAGE_REPO  := https://github.com/libsdl-org/SDL_image.git
SDL3_MIXER_REPO  := https://github.com/libsdl-org/SDL_mixer.git
UNITY_REPO       := https://github.com/ThrowTheSwitch/Unity.git

SDL3_DIR         := $(DEPS_DIR)/sdl3
SDL3_IMAGE_DIR   := $(DEPS_DIR)/sdl3_image
SDL3_MIXER_DIR   := $(DEPS_DIR)/sdl3_mixer
UNITY_DIR        := $(DEPS_DIR)/unity

SDL3_BUILD_DIR       := $(SDL3_DIR)/build
SDL3_IMAGE_BUILD_DIR := $(SDL3_IMAGE_DIR)/build
SDL3_MIXER_BUILD_DIR := $(SDL3_MIXER_DIR)/build

APP                := sdl3-mac-app
SRC                := src/main.c

#------------------------------------------------------------------------------

all: deps build

deps: $(SDL3_DIR) $(SDL3_IMAGE_DIR) $(SDL3_MIXER_DIR) $(UNITY_DIR)

$(SDL3_DIR):
	@mkdir -p $(DEPS_DIR)
	@git clone $(SDL3_REPO) $(SDL3_DIR)

$(SDL3_IMAGE_DIR):
	@mkdir -p $(DEPS_DIR)
	@git clone $(SDL3_IMAGE_REPO) $(SDL3_IMAGE_DIR)

$(SDL3_MIXER_DIR):
	@mkdir -p $(DEPS_DIR)
	@git clone $(SDL3_MIXER_REPO) $(SDL3_MIXER_DIR)

$(UNITY_DIR):
	@mkdir -p $(DEPS_DIR)
	@git clone $(UNITY_REPO) $(UNITY_DIR)

build: build-sdl3 build-sdl3_image build-sdl3_mixer build-unity

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
	  cmake .. -DCMAKE_BUILD_TYPE=Release \
               -DCMAKE_INSTALL_PREFIX=$(CURDIR)/$(SDL3_IMAGE_DIR)/install \
               -DCMAKE_PREFIX_PATH=$(CURDIR)/$(SDL3_DIR)/install && \
	  $(MAKE) && $(MAKE) install

build-sdl3_mixer:
	@echo "Building SDL3_mixer..."
	@mkdir -p $(SDL3_MIXER_BUILD_DIR)
	@cd $(SDL3_MIXER_BUILD_DIR) && \
	  cmake .. -DCMAKE_BUILD_TYPE=Release \
               -DCMAKE_INSTALL_PREFIX=$(CURDIR)/$(SDL3_MIXER_DIR)/install \
               -DCMAKE_PREFIX_PATH=$(CURDIR)/$(SDL3_DIR)/install \
               -DSDL3_DIR=$(CURDIR)/$(SDL3_DIR)/install/lib/cmake/SDL3 \
               -DCMAKE_FIND_FRAMEWORK=NEVER && \
	  $(MAKE) && $(MAKE) install

build-unity:
	@echo "Setting up Unity..."
	@echo "Unity is header-only and ready to use."

build-app:
	@echo "Building the application..."
	@mkdir -p $(BUILD_DIR)
	$(CC) $(SRC) -o $(BUILD_DIR)/$(APP) \
	  -Ideps/sdl3/install/include \
	  -Ideps/sdl3_image/install/include \
	  -Ideps/sdl3_mixer/install/include \
	  -Ldeps/sdl3/install/lib -lSDL3 \
	  -Ldeps/sdl3_image/install/lib -lSDL3_image \
	  -Ldeps/sdl3_mixer/install/lib -lSDL3_mixer \
	  -Wl,-rpath,$(CURDIR)/deps/sdl3/install/lib \
	  -Wl,-rpath,$(CURDIR)/deps/sdl3_image/install/lib \
	  -Wl,-rpath,$(CURDIR)/deps/sdl3_mixer/install/lib

run: build-app
	@echo "Running $(APP)..."
	./$(BUILD_DIR)/$(APP)

clean:
	@echo "Cleaning build directories and executable..."
	@rm -rf $(SDL3_BUILD_DIR) $(SDL3_IMAGE_BUILD_DIR) $(SDL3_MIXER_BUILD_DIR)
