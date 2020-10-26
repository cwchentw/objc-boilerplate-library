# Detect system OS.
ifeq ($(OS),Windows_NT)
    detected_OS := Windows
else
    detected_OS := $(shell sh -c 'uname -s 2>/dev/null || echo not')
endif

# Set the default include path of GNUstep.
ifeq (,$(GNUSTEP_INCLUDE))
	GNUSTEP_INCLUDE=/usr/GNUstep/System/Library/Headers
endif

# Set the default library path of GNUstep.
ifeq (,$(GNUSTEP_LIB))
	GNUSTEP_LIB=/usr/GNUstep/System/Library/Libraries
endif

# Set the library path of GCC.
GCC_LIB=$(shell sh -c 'dirname `gcc -print-prog-name=cc1 /dev/null`')

C_SRCS=$(shell find src -name *.c)
OBJC_SRCS=$(shell find src -name *.m)

OBJS=$(C_SRCS:.c=.o)
OBJS+=$(OBJC_SRCS:.m=.o)

# Modify the executable name by yourself.
ifeq (,$(LIBRARY))
	LIBRARY=libalgebra
endif

ifeq ($(detected_OS),Windows)
	DYNAMIC_LIB=$(LIBRARY).dll
else
ifeq ($(detected_OS),Darwin)
	DYNAMIC_LIB=$(LIBRARY).dylib
else
	DYNAMIC_LIB=$(LIBRARY).so
endif  # Darwin
endif  # Windows
STATIC_LIB=$(LIBRARY).a

# Set the C standard.
ifeq (,$(C_STD))
	C_STD=c11
endif


# Set the include path of libobjc on non-Apple platforms.
OBJC_INCLUDE := -I $(GCC_LIB)/include

.PHONY: all dynamic static clean

all: dynamic

dynamic: dist/$(DYNAMIC_LIB)

dist/$(DYNAMIC_LIB): $(OBJS)
	$(CC) -shared -o dist/$(DYNAMIC_LIB) $(OBJS)

static: dist/$(STATIC_LIB)

dist/$(STATIC_LIB): $(OBJS)
ifeq ($(detected_OS),Darwin)
	libtool -o dist/$(STATIC_LIB) $(OBJS)
else
	$(AR) rcs -o dist/$(STATIC_LIB) $(OBJS)
endif

%.o:%.c
ifeq (dynamic,$(MAKECMDGOALS))
	$(CC) -fPIC -std=$(C_STD) -c $< -o $@ $(CFLAGS) -I include
else
	$(CC) -std=$(C_STD) -c $< -o $@ $(CFLAGS) -I include
endif

%.o:%.m
ifeq ($(detected_OS),Darwin)
ifeq (dynamic,$(MAKECMDGOALS))
	$(CC) -fPIC -std=$(C_STD) -c $< -o $@ $(CFLAGS) -I include \
		-fconstant-string-class=NSConstantString
else
	$(CC) -std=$(C_STD) -c $< -o $@ $(CFLAGS) -I include \
		-fconstant-string-class=NSConstantString
endif
else
ifeq (dynamic,$(MAKECMDGOALS))
	$(CC) -fPIC -std=$(C_STD) -c $< -o $@ $(CFLAGS) -I include \
		$(OBJC_INCLUDE) -I $(GNUSTEP_INCLUDE) \
		-fconstant-string-class=NSConstantString
else
	$(CC) -std=$(C_STD) -c $< -o $@ $(CFLAGS) -I include \
		$(OBJC_INCLUDE) -I $(GNUSTEP_INCLUDE) \
		-fconstant-string-class=NSConstantString
endif
endif

clean:
	$(RM) dist/$(DYNAMIC_LIB) dist/$(STATIC_LIB) $(OBJS)