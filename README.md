# Introduction

This project is an example of using the Zig build system to build a C project
composed of a C library and a C executable. 

This file is also a makedown file.
More info at https://github.com/tzador/makedown

# Relevant resource (warning: API in ref is out-of-date with Zig >= 0.14):
- [1] https://zig.news/kristoff/make-zig-your-c-c-build-system-28g5
- [2] https://zig.news/xq/zig-build-explained-part-1-59lf (cited by [1])

# Obsolescence warning 

This project is only a small proof-of-concept, initiated with Zig 0.14. It will
be kept in sync with latest Zig version (i.e. fixing breaking changes) on a
best-effort basis. The content mights be out-of-date against latest Zig
version.

# [build]() build a shared amd64 linux executable using system libc

```
zig build --summary all
```

# [build-static]() build a static amd64 linux executable using musl libc

```
zig build -Dtarget=x86_64-linux-musl --summary all
```

# [compile-commands]() generate a compilation database 

```
./generate_compcmd_json.sh
```
