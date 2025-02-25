#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void transposeKernel(int *d_A, int *d_AT, int m, int n) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if (row < m && col < n) {
        d_AT[col * m + row] = d_A[row * n + col];
    }
}

void printMatrix(int *matrix, int rows, int cols) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            printf("%d ", matrix[i * cols + j]);
        }
        printf("\n");
    }
}

int main() {
    int m, n;
    printf("Enter number of rows (m): ");
    scanf("%d", &m);
    printf("Enter number of columns (n): ");
    scanf("%d", &n);

    int *h_A = (int *)malloc(m * n * sizeof(int));
    int *h_AT = (int *)malloc(n * m * sizeof(int));  

    printf("Enter the elements of the matrix A (%dx%d):\n", m, n);
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            printf("Element A[%d][%d]: ", i, j);
            scanf("%d", &h_A[i * n + j]);
        }
    }

    printf("\nOriginal Matrix A:\n");
    printMatrix(h_A, m, n);

    int *d_A, *d_AT;
    cudaMalloc((void **)&d_A, m * n * sizeof(int));
    cudaMalloc((void **)&d_AT, n * m * sizeof(int));

    cudaMemcpy(d_A, h_A, m * n * sizeof(int), cudaMemcpyHostToDevice);

    dim3 blockDim(16, 16); 
    dim3 gridDim((n + blockDim.x - 1) / blockDim.x, (m + blockDim.y - 1) / blockDim.y); 

    transposeKernel<<<gridDim, blockDim>>>(d_A, d_AT, m, n);

    cudaError_t err = cudaGetLastError();
    if (err != cudaSuccess) {
        printf("CUDA error: %s\n", cudaGetErrorString(err));
    }

    cudaMemcpy(h_AT, d_AT, n * m * sizeof(int), cudaMemcpyDeviceToHost);

    printf("\nTransposed Matrix AT:\n");
    printMatrix(h_AT, n, m);

    free(h_A);
    free(h_AT);
    cudaFree(d_A);
    cudaFree(d_AT);

    return 0;
}
