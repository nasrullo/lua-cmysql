V= 2.4.0
CONFIG= ./config

include $(CONFIG)
OBJS= src/luasql.o
SRCS= src/luasql.h src/luasql.c

# list of all driver names
DRIVER_LIST= $(subst src/ls_,,$(basename $(wildcard src/ls_*.c)))

# used for help formatting
EMPTY=
SPACE= $(EMPTY) $(EMPTY)

all :
	@echo "usage: make { $(subst $(SPACE),$(SPACE)|$(SPACE),$(DRIVER_LIST)) }"

# explicity matches against the list of avilable driver names
$(DRIVER_LIST) : % : src/%.so

# builds the specified driver
src/%.so : src/ls_%.c $(OBJS)
	$(CC) $(CFLAGS) src/ls_$*.c -o $@ $(LIB_OPTION) $(OBJS) $(DRIVER_INCS_$*) $(DRIVER_LIBS_$*)

build: $(SRCS)
	$(CC) $(CFLAGS) -c src/luasql.c -o src/luasql.so -shared

install:
	mkdir -p $(LUA_LIBDIR)/luasql
	cp src/*.so $(LUA_LIBDIR)/luasql

clean:
	rm -f src/*.so src/*.o
LUA_INC_DIR = /usr/include/lua5.1
swop:
	gcc src/swop.c -o swop -Wall -I/usr/include/lua5.1 -llua5.

# for luajit:	gcc src/swop.c -o swop -I/usr/local/openresty/luajit/include/luajit-2.1 -L/usr/local/openresty/luajit/lib -lluajit-5.1
# It compiles but when riuunnig show an error
# therefor this to be added to LD_LIBRATY_PATH which luajits uses to look for shared libs
# export LD_LIBRARY_PATH=/usr/local/openresty/luajit/lib:$LD_LIBRARY_PATH
# https://www.cprogramming.com/tutorial/shared-libraries-linux-gcc.html