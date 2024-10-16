// include any headers
#include <iostream>
#include <math.h>

// define constants
#define BLOCK_SIZE 256
#define SIZE 100

// function to apply scan on arrays
__global__ void scan(int *in, int *out, int n){
    __shared__ int temp[BLOCK_SIZE], source[BLOCK_SIZE], dest[BLOCK_SIZE];
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = 1;

    // Compute
    if (idx < n) {
        temp[threadIdx.x] = in[idx];
        source[threadIdx.x] = in[idx];
        dest[threadIdx.x] = out[idx];
    }
    __syncthreads();

     for (int i = 1; i < blockDim.x; i++) {
        //int tempT;
        if (threadIdx.x >= i) {
            dest[threadIdx.x] = source[i] + source[i-stride];
            temp[i] = dest[threadIdx.x];
            dest[i] = source[i];
            source[i] = temp[i];
            stride = stride *2;
        }
        __syncthreads();
        //if (threadIdx.x >= i) {
        //    temp[threadIdx.x] += tempT;
        //}
        //__syncthreads();
    }
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
    std::cout << "Input array:" << std::endl;
    for (int i = 0; i < SIZE; i++){
    std::cout << input[i] << " ";
    }
    std::cout << std::endl;

    std::cout << "Output array:" << std::endl;
    for (int i = 0; i < SIZE; i++) {
        std::cout << output[i] << " ";
    }
    std::cout << std::endl;

  // free memory
    cudaFree(input);
    cudaFree(output);
  return 0;
}
