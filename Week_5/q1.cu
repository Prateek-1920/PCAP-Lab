#include <stdio.h>
#include <cuda.h>

#define N 5 // Length of the vectors

__global__ void vectorAddKernel(float *A, float *B, float *C)
{
    int i = threadIdx.x; // Each thread handles one element
    if (i < N)
    {
        C[i] = A[i] + B[i];
        printf("Thread %d: A[%d] = %f, B[%d] = %f, C[%d] = %f\n", i, i, A[i], i, B[i], i, C[i]);
    }
}

void vectorAdd(float *A, float *B, float *C)
{
    float *d_A, *d_B, *d_C;

    // Allocate device memory
    cudaMalloc((void **)&d_A, N * sizeof(float));
    cudaMalloc((void **)&d_B, N * sizeof(float));
    cudaMalloc((void **)&d_C, N * sizeof(float));

    // Copy vectors from host to device
    cudaMemcpy(d_A, A, N * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, N * sizeof(float), cudaMemcpyHostToDevice);

    // Launch kernel with 1 block of N threads
    vectorAddKernel<<<1, N>>>(d_A, d_B, d_C);

    // Copy result from device to host
    cudaMemcpy(C, d_C, N * sizeof(float), cudaMemcpyDeviceToHost);

    // Free device memory
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
}

int main()
{
    float A[N], B[N], C[N];

    // Initialize vectors A and B
    for (int i = 0; i < N; i++)
    {
        A[i] = i;
        B[i] = i * 2;
    }

    // Add vectors
    vectorAdd(A, B, C);

    // Print result
    printf("\nFinal result:\n");
    for (int i = 0; i < N; i++) {
        printf("%f + %f = %f\n", A[i], B[i], C[i]);
    }

    return 0;
}