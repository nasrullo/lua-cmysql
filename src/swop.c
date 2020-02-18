
#include <stdio.h>
#include <stdlib.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

void bail(lua_State *L, char * msg){

    fprintf(stderr, "\nFATAL ERROR:\n %s: %s\n\n", msg, lua_tostring(L, -1));
}



int main()
{

    lua_State *L;
    L = luaL_newstate();
    luaL_openlibs(L);
    int ok =  luaL_loadfile(L, "helloscript.lua");
    if (ok)    /* Load but don't run the Lua script */
	    bail(L, "luaL_loadfile() failed");      /* Error out if file can't be read */

    printf("In C, calling Lua\n");
    ok = lua_pcall(L, 0, 0, 0);
    if (ok)                  /* Run the loaded Lua script */
	    bail(L, "lua_pcall() failed");          /* Error out if Lua file has an error */

    printf("Back in C again\n");

    lua_close(L);      


}