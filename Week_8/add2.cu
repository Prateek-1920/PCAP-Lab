#include <stdio.h>
#include <cuda_runtime.h>

__device__ int factorial(int n) {
    int result = 1;
    for (int i = 1; i <= n; i++) {
        result *= i;
    }
    return result;
}

__device__ int sum_of_digits(int num) {
    int sum = 0;
    while (num > 0) {
        sum += num % 10;
        num /= 10;
    }
    return sum;
}

__global__ void processMatrix(int *A, int *B, int n) {
    int row = threadIdx.x;
    int col = threadIdx.y;

    if (row < n && col < n) {
        if (row == col) {
            B[row * n + col] = 0;
        } else if (row < col) {
            B[row * n + col] = factorial(A[row * n + col]);
        } else {
            B[row * n + col] = sum_of_digits(A[row * n + col]);
        }
    }
}

int main() {
    int n;

    printf("Enter the size of the matrix (n x n): ");
    scanf("%d", &n);

    int A[n][n], B[n][n];

    printf("Enter elements of matrix A (%d x %d):\n", n, n);
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            printf("A[%d][%d]: ", i, j);
            scanf("%d", &A[i][j]);
        }
    }

    int *d_A, *d_B;
    size_t size_A = n * n * sizeof(int);
    size_t size_B = n * n * sizeof(int);

    cudaMalloc(&d_A, size_A);
    cudaMalloc(&d_B, size_B);

    cudaMemcpy(d_A, A, size_A, cudaMemcpyHostToDevice);

    dim3 threadsPerBlock(n, n);
    processMatrix<<<1, threadsPerBlock>>>(d_A, d_B, n);

    cudaMemcpy(B, d_B, size_B, cudaMemcpyDeviceToHost);

    printf("Resultant Matrix B:\n");
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            printf("%d ", B[i][j]);
        }
        printf("\n");
    }

    cudaFree(d_A);
    cudaFree(d_B);

    return 0;
}
