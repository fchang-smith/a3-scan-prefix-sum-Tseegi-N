#include <stdio.h>
#include <stdlib.h>

#define SIZE 100000

int main() {
  // allocate memory
  int* input = malloc(sizeof(int) * SIZE);
  int* output = malloc(sizeof(int) * SIZE);

  // initialize inputs
  for (int i = 0; i < SIZE; i++) {
    input[i] = 1;
   }

  //initialize output
  output[0] = input[0];

  // do the scan
  for (int i = 1; i < SIZE; i++) {
   output[i] = output[i-1] + input[i];
  }

  // check results
  //for (int i = 0; i < SIZE; i++) {
  //  printf("%d ", output[i]);
  //}
  //printf("\n");

  // free mem
  free(input);
  free(output);

  return 0;
}
