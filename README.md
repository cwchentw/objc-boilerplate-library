# Objective-C Boilerplate for Library

An Objective-C boilerplate project to build an Objective-C based library.

## System Requirements

* Objective-C compiler (Clang or GCC)
* Cocoa or GNUstep
* GNU Make (for compilation only)

## Usage

Clone the project:

```
$ git clone https://github.com/cwchentw/objc-boilerplate-library.git mylib
```

Move your working directory to the root of *mylib*:

```
$ cd mylib
```

Modify the header and the source as needed. You may add and remove Objective-C source files (*.m*) or C source files (*.c*) as well.

Compile the project to a dynamic library:

```
$ make
```

Alternatively, compile the project to a static library:

```
$ make static
```

Set your own remote repository:

```
$ git remote set-url origin https://example.com/user/project.git
```

Push your modification to your own repo:

```
$ git push
```

## Project Configuration

Here are the parameters in *Makefile*:

* **LIBRARY**: the name of the compiled library, including *lib* the prefix
* **C_STD**: the C standard as a GCC C dialect
* **GNUSTEP_INCLUDE**: the include path of GNUstep
* **GNUSTEP_LIB**: the library path of GNUstep

## Copyright

Copyright (c) 2020 Michael Chen. Licensed under MIT.