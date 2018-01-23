#include <unistd.h>
#include <sys/syscall.h>

#ifndef DOCKER_IMAGE
    #define DOCKER_IMAGE "hello-world"
#endif

#ifndef DOCKER_GREETING
    #define DOCKER_GREETING "Hello from Scratch"
#endif

const char message[] =
    "\n"
    DOCKER_GREETING "\n"
    "\n"
    "(ref: https://docs.docker.com/engine/userguide/eng-image/baseimages/#create-a-simple-parent-image-using-scratch)\n";

void _start() {
    //write(1, message, sizeof(message) - 1);
    syscall(SYS_write, 1, message, sizeof(message) - 1);

    //_exit(0);
    syscall(SYS_exit, 0);
}
