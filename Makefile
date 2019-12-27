all: insert

insert: insert.o
	gcc -o insert insert.o

insert.o: insert-sort.s
	as -o insert.o insert-sort.s

clean:
	rm *.o insert
