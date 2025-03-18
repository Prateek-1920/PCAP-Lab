#include <stdio.h>
#include <cuda_runtime.h>

__global__ void mulRows(int *A, int *B, int *C, int m, int n, int p) {
    int row = blockIdx.x;

    if (row < m) {
        for (int col = 0; col < p; ++col) {
            C[row * p + col] = 0;
            for (int k = 0; k < n; ++k) {
                C[row * p + col] += A[row * n + k] * B[k * p + col];
            }
        }
    }
}

__global__ void mulColumns(int *A, int *B, int *C, int m, int n, int p) {
    int col = blockIdx.x;

    if (col < p) {
        for (int row = 0; row < m; ++row) {
            C[row * p + col] = 0;
            for (int k = 0; k < n; ++k) {
                C[row * p + col] += A[row * n + k] * B[k * p + col];
            }
        }
    }
}

__global__ void mulElements(int *A, int *B, int *C, int m, int n, int p) {
    int row = threadIdx.x;
    int col = threadIdx.y;

    if (row < m && col < p) {
        C[row * p + col] = 0;
        for (int k = 0; k < n; ++k) {
            C[row * p + col] += A[row * n + k] * B[k * p + col];
        }
    }
}

int main() {
    int m, n, p;

    printf("Enter the number of rows for Matrix A (m): ");
    scanf("%d", &m);
    printf("Enter the number of columns for Matrix A (n): ");
    scanf("%d", &n);
    printf("Enter the number of columns for Matrix B (p): ");
    scanf("%d", &p);

    int A[m][n], B[n][p], C[m][p];

    printf("Enter elements of matrix A (%d x %d):\n", m, n);
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            printf("A[%d][%d]: ", i, j);
            scanf("%d", &A[i][j]);
        }
    }

    printf("Enter elements of matrix B (%d x %d):\n", n, p);
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < p; j++) {
            printf("B[%d][%d]: ", i, j);
            scanf("%d", &B[i][j]);
        }
    }

    int *d_A, *d_B, *d_C;
    size_t size_A = m * n * sizeof(int);
    size_t size_B = n * p * sizeof(int);
    size_t size_C = m * p * sizeof(int);

    cudaMalloc(&d_A, size_A);
    cudaMalloc(&d_B, size_B);
    cudaMalloc(&d_C, size_C);

    cudaMemcpy(d_A, A, size_A, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, size_B, cudaMemcpyHostToDevice);

    mulRows<<<m, 1>>>(d_A, d_B, d_C, m, n, p);

    cudaMemcpy(C, d_C, size_C, cudaMemcpyDeviceToHost);

    printf("Resultant Matrix C (Row-wise computation):\n");
    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < p; ++j) {
            printf("%d ", C[i][j]);
        }
        printf("\n");
    }

    mulColumns<<<p, 1>>>(d_A, d_B, d_C, m, n, p);

    cudaMemcpy(C, d_C, size_C, cudaMemcpyDeviceToHost);

    printf("Resultant Matrix C (Column-wise computation):\n");
    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < p; ++j) {
            printf("%d ", C[i][j]);
        }
        printf("\n");
    }

    dim3 threadsPerBlock(m, p);
    mulElements<<<1, threadsPerBlock>>>(d_A, d_B, d_C, m, n, p);

    cudaMemcpy(C, d_C, size_C, cudaMemcpyDeviceToHost);

    printf("Resultant Matrix C (Element-wise computation):\n");
    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < p; ++j) {
            printf("%d ", C[i][j]);
        }
        printf("\n");
    }

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    return 0;
}
