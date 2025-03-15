#
# DANTE :: System Automatycznych Testów Jednostkowych oraz Akceptacyjnych
# Tomasz Jaworski, 2018-2020
#
# Plik wygenerowany automatycznie
# Znacznik czasowy: 2024-10-09 22:22:19.179700
#

cmake_minimum_required(VERSION 3.17)
project(project1 C)

# Przyjmij standard C11
set(CMAKE_C_STANDARD 11)

# Ustaw opcje kompilatora (z raportu Dante)
add_compile_options(
      "-D_ANSI_OUTPUT"
      "-fdiagnostics-color"
      "-xc"
      "-DINSIDE_DANTE"
      "-ggdb3"
      "-fmax-errors=5"
      "-Werror"
      "-D_GNU_SOURCE"
      "-Wno-error=parentheses"
      "-Wno-error=unused-parameter"
      "-Wno-error=implicit-fallthrough"
      "-Wno-parentheses"
      "-Wextra"
      "-std=c11"
      "-Werror=vla"
      "-Wall"
      "-pedantic"

)

# Ustaw opcje konsolidatora (z raportu Dante)
add_link_options(
        "-ggdb3"
        "-Wl,-wrap,main"
        "-Wl,-Map=main.map"
        "-Wl,-cref"
)

# Utwórz target 'project1' i dodaj do niego pliki źródlowe:
add_executable(project1
        "main.c"
        "file_reader.c"
        "unit_helper_v2.c"
        "unit_test_v2.c"
        "rdebug.c"
)

# Dołącz niezbędne biblioteki
target_link_libraries(project1
        "m"
)