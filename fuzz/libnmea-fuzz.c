#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <nmea.h>

int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
    char sentence[Size]; // Convert random data to a non-const char array
    nmea_s *nmea_data; // Pointer to struct containing the parsed data

    if (Size == 0 || Data == NULL)
        return 0;

    memcpy(sentence, Data, Size);
    nmea_data = nmea_parse(sentence, Size, 0);

    if (nmea_data != NULL)
        nmea_free(nmea_data);
    return 0;
}
