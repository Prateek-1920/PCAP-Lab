#include <stdio.h>
#include <cuda.h>

#define THREADS_PER_BLOCK 256 // Number of threads per block

__global__ void vectorAddKernel(float *A, float *B, float *C, int N)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x; // Global thread index
    if (i < N)
    {                       // Ensure the thread is within bounds of the vector length
        C[i] = A[i] + B[i]; // Perform vector addition
        printf("Thread %d: A[%d] = %f, B[%d] = %f, C[%d] = %f\n", threadIdx.x, i, A[i], i, B[i], i, C[i]);
    }
}

void vectorAdd(float *A, float *B, float *C, int N)
{
    float *d_A, *d_B, *d_C;

    // Allocate device memory
    cudaMalloc((void **)&d_A, N * sizeof(float));
    cudaMalloc((void **)&d_B, N * sizeof(float));
    cudaMalloc((void **)&d_C, N * sizeof(float));

    // Copy vectors from host to device
    cudaMemcpy(d_A, A, N * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, N * sizeof(float), cudaMemcpyHostToDevice);

    // Calculate the number of blocks needed (round up if necessary)
    int numBlocks = (N + THREADS_PER_BLOCK - 1) / THREADS_PER_BLOCK;

    // Launch kernel with numBlocks and THREADS_PER_BLOCK threads per block
    vectorAddKernel<<<numBlocks, THREADS_PER_BLOCK>>>(d_A, d_B, d_C, N);

    // Copy result from device to host
    cudaMemcpy(C, d_C, N * sizeof(float), cudaMemcpyDeviceToHost);

    // Free device memory
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
}

int main()
{
    int N = 5; // Length of the vectors (you can change this value)

    float *A = (float *)malloc(N * sizeof(float));
    float *B = (float *)malloc(N * sizeof(float));
    float *C = (float *)malloc(N * sizeof(float));

    // Initialize vectors A and B
    for (int i = 0; i < N; i++)
    {
        A[i] = i * 1.0f; // Fill A with values 0, 1, 2, 3, ...
        B[i] = i * 2.0f; // Fill B with values 0, 2, 4, 6, ...
    }

    // Add vectors
    vectorAdd(A, B, C, N);

    // Print the result of the addition
    printf("\nFinal result:\n");
    for (int i = 0; i < N; i++)
    {
        printf("%f + %f = %f\n", A[i], B[i], C[i]);
    }

    // Free host memory
    free(A);
    free(B);
    free(C);

    return 0;
}
