#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>

int main(void) {

  FILE*   fp;
  char*   line = NULL ;
  size_t  len = 0;
  ssize_t read;

  fp = fopen("hello-docker-ascii.txt", "r");

  while ((read = getline(&line, &len, fp)) != -1) {
    printf("%s", line);
  }
  fclose(fp);
}
