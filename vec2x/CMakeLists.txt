cmake_minimum_required(VERSION 3.10)
project(vec2x)

include(CMakePrintHelpers)

# ==============================================================================
# Include and library pathes
# ==============================================================================

find_package(SDL2 CONFIG REQUIRED)
find_package(SDL2_image CONFIG REQUIRED >=2.0.0)

include_directories(${SDL2_INCLUDE_DIRS} ${SDL2_IMAGE_INCLUDE_DIRS})

if(APPLE)
	include_directories("/opt/homebrew/Cellar/sdl2/2.0.22/include" "/opt/homebrew/Cellar/sdl2_image/2.6.0_1/include")
endif()

# ==============================================================================
# Headers and sources
# ==============================================================================

include_directories(src/base src/editor src/emulator_vectrex src/sdl)

set(VEC2X_SOURCES
    src/e6809.c
    src/e6809.h
    src/e8910.c
    src/e8910.h
    src/vec2x_platform.c
    src/vec2x_platform.h
    src/vec2x.c
    src/vec2x.h
)

set(SDL_SOURCES
    src/sdl/SDL2_gfxPrimitives.c
    src/sdl/SDL2_rotozoom.c
)

# ==============================================================================
# Resource definition
# ==============================================================================

set(RESOURCE_FILES
)

source_group(
    "Resources" FILES ${RESOURCE_FILES}
)

list(APPEND
    TARGET_SOURCES
    ${RESOURCE_FILES}
) 

# ==============================================================================
# Target properties and definitions
# ==============================================================================

set(CMAKE_CXX_STANDARD 17) 
#set_target_properties(${TARGET} PROPERTIES C_STANDARD 90)
#set_target_properties(${TARGET} PROPERTIES C_EXTENSIONS ON)
#set_target_properties(${TARGET} PROPERTIES INTERPROCEDURAL_OPTIMIZATION ON)

set(TARGET vec2x)

add_executable(${TARGET} ${VEC2X_SOURCES} ${SDL_SOURCES} ${RESOURCE_FILES})

if(APPLE)
    set_target_properties(vec2x PROPERTIES MACOSX_BUNDLE TRUE MACOSX_FRAMEWORK_IDENTIFIER org.cmake.ExecutableTarget RESOURCE "${RESOURCE_FILES}" )
endif()

# ==============================================================================
# Compile options
# ==============================================================================

if(MSVC)
    target_compile_options(${TARGET} PRIVATE /W4 /D_CRT_SECURE_NO_WARNINGS)
    target_compile_options(${TARGET} PRIVATE /fp:fast)
else()
#    target_compile_options(${TARGET} PRIVATE -Wall -Wextra -pedantic)
    target_compile_options(${TARGET} PRIVATE -ffast-math)
	target_compile_features(${TARGET} PUBLIC c_std_99)
endif()

if(UNIX AND NOT APPLE)
    target_compile_options(${TARGET} PRIVATE -D_POSIX_C_SOURCE=200809L)
endif()

add_definitions(-DUNIX_HOST)

# ==============================================================================
# Link libraries
# ==============================================================================

if(WIN32)
    target_link_libraries(${TARGET} ${SDL2_LIBRARIES} ${SDL2_IMAGE_LIBRARY})
elseif(APPLE)
    target_link_libraries(${TARGET} PRIVATE "-framework Cocoa")
    target_link_libraries(${TARGET} PRIVATE SDL2::SDL2 SDL2_image::SDL2_image)
else()
    target_link_libraries(${TARGET} PRIVATE ${SDL2_LIBRARIES} ${SDL2_IMAGE_LIBRARY}} m X11)
endif()

cmake_print_variables(SDL2_LIBRARIES)
cmake_print_variables(SDL2_IMAGE_LIBRARIES)
cmake_print_variables(SDL2_INCLUDE_DIRS)
cmake_print_variables(SDL2_IMAGE_INCLUDE_DIRS)

# ==============================================================================
# IDE support
# ==============================================================================

set_directory_properties(PROPERTIES VS_STARTUP_PROJECT ${TARGET})

source_group("Vec2X" FILES ${VEC2X_SOURCES})
source_group("SDL" FILES ${SDL_SOURCES})

# ==============================================================================
# macOS apps bundle support
# ==============================================================================

set_target_properties(${TARGET} PROPERTIES
	MACOSX_BUNDLE FALSE
  	MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/src/platforms/Info.plist
)
