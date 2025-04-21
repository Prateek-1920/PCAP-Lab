#include <stdio.h>
#include <cuda_runtime.h>  // ✅ CUDA runtime header

// CUDA kernel to add two numbers
__global__ void add(int *a, int *b, int *c) {
    *c = *a + *b;
}

int main() {
    int a = 10, b = 20, c;

    int *d_a, *d_b, *d_c;

    // Allocate memory on the GPU
    cudaMalloc((void**)&d_a, sizeof(int));
    cudaMalloc((void**)&d_b, sizeof(int));
    cudaMalloc((void**)&d_c, sizeof(int));

    // Copy input values to the GPU
    cudaMemcpy(d_a, &a, sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, &b, sizeof(int), cudaMemcpyHostToDevice);

    // Launch kernel (1 block, 1 thread)
    add<<<1,1>>>(d_a, d_b, d_c);

    // Copy result back to host
    cudaMemcpy(&c, d_c, sizeof(int), cudaMemcpyDeviceToHost);

    printf("Sum = %d\n", c);

    // Free GPU memory
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    return 0;
}
