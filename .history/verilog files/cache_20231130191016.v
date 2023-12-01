parameter CACHE_SIZE = 256;    // Number of cache lines
parameter LINE_SIZE = 16;      // Size of each cache line in bytes
parameter TAG_SIZE = 16;       // Size of the tag

reg [7:0] cache_data[CACHE_SIZE-1:0][LINE_SIZE-1:0];  // Cache data array
reg [TAG_SIZE-1:0] cache_tags[CACHE_SIZE-1:0];         // Tag array
reg [CACHE_SIZE-1:0] valid_bits;                       // Valid bits

