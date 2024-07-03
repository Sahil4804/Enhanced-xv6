
#include "../kernel/types.h"
#include "../kernel/stat.h"
#include "user.h"

void
execout(char *s)
{
  for(int avail = 0; avail < 15; avail++){
    int pid = fork();
    if(pid < 0){
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    //   printf("");    
      while (1)
      {
          uint64 a = (uint64)sbrk(4096);
          if (a == 0xffffffffffffffffLL)
              break;
          *(char *)(a + 4096 - 1) = 1;
      }

      // free a few pages, in order to let exec() make some
      // progress.
      for(int i = 0; i < avail; i++)
        sbrk(-4096);
      
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    }
  }

  exit(0);
}

int
main(int argc, char *argv[])
{
  execout("execout");
  exit(0);
}