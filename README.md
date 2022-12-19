# fwalk
fortran bindings for libcwalk

[Documentation](https://github.com/likle/cwalk)

When passing strings from fortran to c, ensure these are null-terminated i.e fstring//c_null_char. For most of the functions I use helper functions to ensure strings passed are null-terminated but for the segment-related functions, no helper functions are provided as the path is passed as a pointer to c and a helper function would change the pointer of the original path passed. You can see this coded in the tests.

## build

Use the recursive command to pull the cwalk source files into the repository: 

```
git clone --recursive git@github.com:freevryheid/fwalk.git
```

this repository has symbolic links to relevant cwalk files. fpm builds and links these:

if you're on cygwin run the following to address an fpm bug:

```
unset OS
```

build and test fwalk:

```
fpm build
fpm test
```

given the need to clone recursively, still investigating how to add this as a dependency within fpm.toml. 
