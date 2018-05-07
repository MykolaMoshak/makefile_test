VPATH = /src
CPPFLAGS = -I/include
CC = gcc

test:	main.o print.o
	$(CC) $^ -o $@

print.o: $(VPATH) $(CPPFLAGS)
	$(CC) $^ -c $@

main.o: $(VPATH) $(CPPFLAGS)
	$(CC) $^ -c $@

clean:
	rm -rf *.o
