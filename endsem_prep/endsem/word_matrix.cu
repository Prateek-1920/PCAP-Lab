#include <stdio.h>
#include <string.h>
#include <cuda_runtime.h>

#define MAX_WORD_LENGTH 20

__device__ int d_found = -1;

__global__ void findword(char *A, char *B, int rows, int cols, int wordLength) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if (row < rows && col < cols) {
        int idx = row * cols + col;
        bool match = true; 
        
        // Compare each character of A[idx] with B
        for (int i = 0; i < wordLength; i++) {
            if (A[idx * MAX_WORD_LENGTH + i] != B[i]) {
                match = false;
                break;
            }
        }

        // Check if both words end at same length
        if (match && A[idx * MAX_WORD_LENGTH + wordLength] == '\0') {
            atomicExch(&d_found, idx);
        }
    }
}

int main() {
    int m, n;
    printf("Enter m and n: ");
    scanf("%d%d", &m, &n);

    char A[m][n][MAX_WORD_LENGTH];
    printf("Enter words:\n");
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            scanf("%s", A[i][j]);
        }
    }

    char B[MAX_WORD_LENGTH];
    printf("Enter target word: ");
    scanf("%s", B);  
    int len = strlen(B);

    // Flatten A
    char flatA[m * n * MAX_WORD_LENGTH];
    for (int i = 0; i < m * n; ++i) {
        strncpy(&flatA[i * MAX_WORD_LENGTH], A[i / n][i % n], MAX_WORD_LENGTH);
    }

    // Allocate device memory
    char *d_a, *d_b;
    cudaMalloc((void**)&d_a, m * n * MAX_WORD_LENGTH * sizeof(char));
    cudaMalloc((void**)&d_b, MAX_WORD_LENGTH * sizeof(char));

    cudaMemcpy(d_a, flatA, m * n * MAX_WORD_LENGTH * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, B, MAX_WORD_LENGTH * sizeof(char), cudaMemcpyHostToDevice);

    // Launch kernel
    dim3 threadsPerBlock(16, 16);
    dim3 blocksPerGrid(4,4);
    findword<<<blocksPerGrid, threadsPerBlock>>>(d_a, d_b, m, n, len);

    // Copy back result
    int h_found = -1;
    cudaMemcpyFromSymbol(&h_found, d_found, sizeof(int), 0, cudaMemcpyDeviceToHost);

    if (h_found != -1) {
        printf("Word '%s' found at index %d (row = %d, col = %d)\n", B, h_found, h_found / n, h_found % n);
    } else {
        printf("Word '%s' not found\n", B);
    }

    cudaFree(d_a);
    cudaFree(d_b);

    return 0;
}
