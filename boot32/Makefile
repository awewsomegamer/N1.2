CFILES := $(wildcard *.c)
COBJS := $(CFILES:.c=.o)

override CFLAGS := 	   \
    -ffreestanding         \
    -fno-stack-protector   \
    -fno-pic               \
    -m32                   \
    -I ./include           
    
all: $(COBJS)

%.o : %.c
	gcc -c $< -o ../bin/32_bin/$@ $(CFLAGS)