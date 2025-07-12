# Introduction

This project is an example of using the zig build system to build a C project
composed of a C library and a C executable. 

This file is also a makedown file.
More info at https://github.com/tzador/makedown

# [build]() build a shared amd64 linux executable using system libc

The `.cache` directory is needed for generation of cdb files. 
Those files are required for generation of the `compile_commands.json`.

```
mkdir -p .cache
zig build --summary all
```

# [build-static]() build a static amd64 linux executable using musl libc

The `.cache` directory is needed for generation of cdb files. 
Those files are required for generation of the `compile_commands.json`.

```
mkdir -p .cache
zig build -Dtarget=x86_64-linux-musl --summary all
```

# [compile-commands]() generate a compilation database 

```
./generate_compcmd_json.sh
```
