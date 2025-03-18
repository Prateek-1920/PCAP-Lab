#include <stdio.h>
#include <cuda_runtime.h>

__global__ void modifyMatrix(int *A, int *B, int m, int n) {
    int row = threadIdx.x;
    int col = threadIdx.y;

    if (row < m && col < n) {
        if (A[row * n + col] % 2 == 0) {
            int rowSum = 0;
            for (int j = 0; j < n; j++) {
                rowSum += A[row * n + j];
            }
            B[row * n + col] = rowSum;
        } else {
            int colSum = 0;
            for (int i = 0; i < m; i++) {
                colSum += A[i * n + col];
            }
            B[row * n + col] = colSum;
        }
    }
}

int main() {
    int m, n;

    printf("Enter the number of rows (m): ");
    scanf("%d", &m);
    printf("Enter the number of columns (n): ");
    scanf("%d", &n);

    int A[m][n], B[m][n];

    printf("Enter elements of matrix A (%d x %d):\n", m, n);
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            printf("A[%d][%d]: ", i, j);
            scanf("%d", &A[i][j]);
        }
    }

    int *d_A, *d_B;
    size_t size_A = m * n * sizeof(int);
    size_t size_B = m * n * sizeof(int);

    cudaMalloc(&d_A, size_A);
    cudaMalloc(&d_B, size_B);

    cudaMemcpy(d_A, A, size_A, cudaMemcpyHostToDevice);

    dim3 threadsPerBlock(m, n);
    modifyMatrix<<<1, threadsPerBlock>>>(d_A, d_B, m, n);

    cudaMemcpy(B, d_B, size_B, cudaMemcpyDeviceToHost);

    printf("Resultant Matrix B:\n");
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            printf("%d ", B[i][j]);
        }
        printf("\n");
    }

    cudaFree(d_A);
    cudaFree(d_B);

    return 0;
}
