# fwalk
fortran bindings for libcwalk

[Documentation](https://github.com/likle/cwalk)

This repository has symbolic links to relevant cwalk files. fpm builds and links these.

fpm build

fpm test

When passing strings from fortran to c, ensure these are null-terminated i.e fstring//c_null_char. For most of the functions I use helper functions to ensure strings passed are null-terminated but for the segment-related functions, no helper functions are provided as the path is passed as a pointer to c and a helper function would change the pointer of the original path passed. You can see this coded in the tests.
