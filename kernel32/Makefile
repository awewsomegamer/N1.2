CFILES := $(wildcard *.c)
COBJS := $(CFILES:.c=.o)

override CFLAGS := 	   \
    -ffreestanding         \
    -fno-stack-protector   \
    -fno-pic               \
    -m32                   

all: $(COBJS)

%.o : %.c
	gcc -c $< -o ../bin/$@ $(CFLAGS)