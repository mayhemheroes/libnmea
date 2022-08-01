cmake_minimum_required(VERSION 3.5)

add_executable(libnmea-fuzz libnmea-fuzz.c)

if (NOT CMAKE_C_COMPILER_ID STREQUAL "Clang")
    message(FATAL_ERROR "Clang is required for libFuzzer!")
endif()


# Link to whichever version of nmea that was built
if (NMEA_FUZZ_LINK_STATIC)
    message(STATUS "Linking fuzzer with static nmea...")
    target_link_libraries(libnmea-fuzz nmea)
else()
    message(STATUS "Linking fuzzer with shared nmea...")
    target_link_libraries(libnmea-fuzz nmea_shared)
endif()

target_compile_options(libnmea-fuzz PUBLIC -fsanitize=fuzzer,address)
target_link_options(libnmea-fuzz PUBLIC -fsanitize=fuzzer,address)
