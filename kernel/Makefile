CFILES := $(wildcard *.c)
COBJS := $(CFILES:.c=.o)

override CFLAGS := 	   \
    -ffreestanding         \
    -fno-stack-protector   \
    -fno-pic               \
    -m64                   \
    -I ./include
    
#-I ./include           
    
all: $(COBJS)

%.o : %.c
	gcc -c $< -o ../bin/64_bin/$@ $(CFLAGS)