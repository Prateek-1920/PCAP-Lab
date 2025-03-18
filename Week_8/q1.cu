#include <stdio.h>
#include <cuda_runtime.h>

__global__ void addRows(int *A, int *B, int *C, int n) {
    int row = blockIdx.x;

    if (row < n) {
        for (int col = 0; col < n; ++col) {
            C[row * n + col] = A[row * n + col] + B[row * n + col];
        }
    }
}

__global__ void addColumns(int *A, int *B, int *C, int n) {
    int col = blockIdx.x;

    if (col < n) {
        for (int row = 0; row < n; ++row) {
            C[row * n + col] = A[row * n + col] + B[row * n + col];
        }
    }
}

__global__ void addElements(int *A, int *B, int *C, int n) {
    int row = threadIdx.x;
    int col = threadIdx.y;

    if (row < n && col < n) {
        C[row * n + col] = A[row * n + col] + B[row * n + col];
    }
}

int main() {
    int n;

    printf("Enter the size of the matrix (n x n): ");
    scanf("%d", &n);

    int A[n][n], B[n][n], C[n][n];
    
    printf("Enter elements of matrix A (%d x %d):\n", n, n);
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            printf("A[%d][%d]: ", i, j);
            scanf("%d", &A[i][j]);
        }
    }

    printf("Enter elements of matrix B (%d x %d):\n", n, n);
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            printf("B[%d][%d]: ", i, j);
            scanf("%d", &B[i][j]);
        }
    }

    int *d_A, *d_B, *d_C;
    size_t size = n * n * sizeof(int);

    cudaMalloc(&d_A, size);
    cudaMalloc(&d_B, size);
    cudaMalloc(&d_C, size);

    cudaMemcpy(d_A, A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, size, cudaMemcpyHostToDevice);

    addRows<<<n, 1>>>(d_A, d_B, d_C, n);

    cudaMemcpy(C, d_C, size, cudaMemcpyDeviceToHost);

    printf("Resultant Matrix C (Row-wise computation):\n");
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            printf("%d ", C[i][j]);
        }
        printf("\n");
    }

    addColumns<<<n, 1>>>(d_A, d_B, d_C, n);

    cudaMemcpy(C, d_C, size, cudaMemcpyDeviceToHost);

    printf("Resultant Matrix C (Column-wise computation):\n");
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            printf("%d ", C[i][j]);
        }
        printf("\n");
    }

    dim3 threadsPerBlock(n, n);
    addElements<<<1, threadsPerBlock>>>(d_A, d_B, d_C, n);

    cudaMemcpy(C, d_C, size, cudaMemcpyDeviceToHost);

    printf("Resultant Matrix C (Element-wise computation):\n");
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            printf("%d ", C[i][j]);
        }
        printf("\n");
    }

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    return 0;
}
