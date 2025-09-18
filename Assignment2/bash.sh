# Makefile
NASM = nasm
NASMFLAGS = -f elf64 -g

CC = gcc
CFLAGS = -std=c11 -g -Wall

OBJS = driver.o display_array.o isfloat.o append.o magnitude.o mean.o input_array.o manager.o

all: arrays

driver.o: driver.c
	$(CC) $(CFLAGS) -c driver.c -o driver.o

display_array.o: display_array.c
	$(CC) $(CFLAGS) -c display_array.c -o display_array.o

isfloat.o: isfloat.asm
	$(NASM) $(NASMFLAGS) isfloat.asm -o isfloat.o

append.o: append.asm
	$(NASM) $(NASMFLAGS) append.asm -o append.o

magnitude.o: magnitude.asm
	$(NASM) $(NASMFLAGS) magnitude.asm -o magnitude.o

mean.o: mean.asm
	$(NASM) $(NASMFLAGS) mean.asm -o mean.o

input_array.o: input_array.asm
	$(NASM) $(NASMFLAGS) input_array.asm -o input_array.o

manager.o: manager.asm
	$(NASM) $(NASMFLAGS) manager.asm -o manager.o

arrays: $(OBJS)
	$(CC) -no-pie $(OBJS) -o arrays

clean:
	rm -f *.o arrays
