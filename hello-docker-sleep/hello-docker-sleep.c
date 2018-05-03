#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(void) {

  FILE*   fp;
  char*   line = NULL ;
  size_t  len = 0;
  ssize_t read;
  int     count = 1;

  for (;;) {
    fp = fopen("hello-docker-ascii.txt", "r");
    printf("%d\n", count);
    while ((read = getline(&line, &len, fp)) != -1) {
      printf("%s", line);
    }
    fclose(fp);
    sleep (30);
    count++;
  }
}
