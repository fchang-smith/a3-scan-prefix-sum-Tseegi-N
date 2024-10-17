// include any headers
#include <iostream>
#include <math.h>

// define constants
#define BLOCK_SIZE 256
#define SIZE 10000

// function to apply scan on arrays
__global__ void scan(int *in, int *out, int n){
    __shared__ int tempOne[BLOCK_SIZE];
    __shared__ int tempTwo[BLOCK_SIZE];
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    // Load input into shared memory
    if (idx < n) {
        tempOne[threadIdx.x] = in[idx];
    }
    __syncthreads();

    int* source = tempOne;
    int* dest = tempTwo;

     // Koggle-stone calculation
     for (int i = 1; i < blockDim.x; i*=2) {
        if (threadIdx.x >= i) {
            dest[threadIdx.x] = source[threadIdx.x] + source[threadIdx.x-i];
        }
        else{
            dest[threadIdx.x] = source[threadIdx.x];
        }

        // swipe source and dest
        int* temp = source;
        source = dest;
        dest = temp;
    }

    // Put results back to global memory
    if(idx < n){
        out[idx] = dest[threadIdx.x];
    }
}

int main(void) {
  // allocate input and output arrays
    int *input, *output;
    cudaMallocManaged(&input, SIZE*sizeof(int));
    cudaMallocManaged(&output, SIZE*sizeof(int));
  // initialize input array on the host
    for(int i=0; i<SIZE; i++){
        input[i] = 1;
    }

  // run the kernel
    scan<<<(SIZE + BLOCK_SIZE - 1) / BLOCK_SIZE, BLOCK_SIZE>>>(input, output, SIZE);
  // check for errors
    cudaDeviceSynchronize();
    cudaError_t error = cudaGetLastError();
    if (error != cudaSuccess) {
        std::cerr << "CUDA Error: " << cudaGetErrorString(error) << std::endl;
    } else {
        std::cout << "Kernel completed successfully!" << std::endl;
    }

    // print out input and output array
    //std::cout << "Input array:" << std::endl;
    //for (int i = 0; i < SIZE; i++){
    //std::cout << input[i] << " ";
    //}
    //std::cout << std::endl;

    //std::cout << "Output array:" << std::endl;
    //for (int i = 0; i < SIZE; i++) {
    //    std::cout << output[i] << " ";
    //}
    //std::cout << std::endl;

  // free memory
    cudaFree(input);
    cudaFree(output);
  return 0;
}
