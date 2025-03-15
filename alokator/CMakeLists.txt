#
# DANTE :: System Automatycznych Testów Jednostkowych oraz Akceptacyjnych
# Tomasz Jaworski, 2018-2020
#
# Plik wygenerowany automatycznie
# Znacznik czasowy: 2024-10-09 22:21:21.334458
#

cmake_minimum_required(VERSION 3.17)
project(project1 C)

# Przyjmij standard C11
set(CMAKE_C_STANDARD 11)

# Ustaw opcje kompilatora (z raportu Dante)
add_compile_options(
      "-fmax-errors=5"
      "-Wno-error=implicit-fallthrough"
      "-D_GNU_SOURCE"
      "-ggdb3"
      "-fdiagnostics-color"
      "-xc"
      "-pedantic"
      "-Wno-error=unused-parameter"
      "-Werror"
      "-DINSIDE_DANTE"
      "-Wextra"
      "-Werror=vla"
      "-Wall"
      "-Wno-error=parentheses"
      "-D_ANSI_OUTPUT"
      "-Wno-parentheses"
      "-std=c11"

)

# Ustaw opcje konsolidatora (z raportu Dante)
add_link_options(
        "-ggdb3"
        "-Wl,-wrap,main"
        "-Wl,-cref"
        "-Wl,-Map=main.map"
)

# Utwórz target 'project1' i dodaj do niego pliki źródlowe:
add_executable(project1
        "heap.c"
        "unit_helper_v2.c"
        "unit_test_v2.c"
        "rdebug.c"
        "memmanager.c"
)

# Dołącz niezbędne biblioteki
target_link_libraries(project1
        "pthread"
        "m"
)