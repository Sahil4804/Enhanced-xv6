#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int main(int argc, char *argv[])
{

    // printf("called the function \n");
    // printf("%s\n", argv[0]);
    // printf("%s\n", argv[1]);
    // printf("%s\n", argv[2]);
    if (strcmp(argv[0], "setpriority") != 0)
    {
        exit(0);
    }
    int pid = atoi(argv[1]);
    if(argv[1][0]=='-'){
        printf("Invalid pid entered\n");
        exit(0);
    }
    int sp = atoi(argv[2]);
    printf("function called with pid %d and static priority %d\n", pid, sp);
    set_priority(pid, sp);
    exit(0);
}