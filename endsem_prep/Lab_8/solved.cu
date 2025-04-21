#include <stdio.h>
#include <cuda_runtime.h>

// #define N 4  // Rows
// #define M 3  // Columns

__global__ void transpose(int *input, int *output, int rows, int cols) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;  // Row index
    int col = blockIdx.x * blockDim.x + threadIdx.x;  // Column index

    if (row < rows && col < cols) {
        int inputIdx = row * cols + col;              // Index in input matrix
        int outputIdx = col * rows + row;             // Index in transposed matrix
        output[outputIdx] = input[inputIdx];
    }
}

int main() {
    // int h_input[N][M] = {
    //     {1, 2, 3},
    //     {4, 5, 6},
    //     {7, 8, 9},
    //     {10,11,12}
    // };

    printf("Enter rows and cols: ");
    scanf("%d%d",&m,&n);
    int h_input[m][n];
    printf("Enter matrix elements: ");
    for(int i=0;i<m;i++){
        for(int j=0;j<n;j++){
            scanf("%d",&h_input[m][n]);
        }
    }

    int h_output[m][n];  // Transposed output

    int *d_input, *d_output;
    cudaMalloc((void**)&d_input, m*n*sizeof(int));
    cudaMalloc((void**)&d_output, m*n*sizeof(int));

    cudaMemcpy(d_input, h_input, m*n*sizeof(int), cudaMemcpyHostToDevice);

    dim3 threadsPerBlock(16, 16);
    dim3 numBlocks((m + threadsPerBlock.x - 1)/threadsPerBlock.x,
                   (n + threadsPerBlock.y - 1)/threadsPerBlock.y);

    transpose<<<numBlocks, threadsPerBlock>>>(d_input, d_output, n, m);

    cudaMemcpy(h_output, d_output, n*m*sizeof(int), cudaMemcpyDeviceToHost);

    printf("Original Matrix:\n");
    for(int i = 0; i < m; i++) {
        for(int j = 0; j < n; j++)
            printf("%d ", h_input[i][j]);
        printf("\n");
    }

    printf("\nTransposed Matrix:\n");
    for(int i = 0; i < m; i++) {
        for(int j = 0; j < n; j++)
            printf("%d ", h_output[i][j]);
        printf("\n");
    }

    cudaFree(d_input);
    cudaFree(d_output);

    return 0;
}
