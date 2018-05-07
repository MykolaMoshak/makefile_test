VPATH = src
CPPFLAGS = -I include
CC = gcc

test:	main.o print.o
	$(CC) $^ -o $@

print.o: 
	$(CC) $(CPPFLAGS) -c $(VPATH)/print.c -o $@ 

main.o: 
	$(CC) $(CPPFLAGS) -c $(VPATH)/main.c -o $@ 

clean:
	rm -rf *.o test
