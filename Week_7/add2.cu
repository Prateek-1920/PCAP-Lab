#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void repeatStringKernel(char *d_Sin, char *d_Sout, int sin_len, int N) {
    int idx = threadIdx.x + blockIdx.x * blockDim.x;

    if (idx < sin_len * N) {
        int src_idx = idx % sin_len;  
        d_Sout[idx] = d_Sin[src_idx];
    }
}

void printString(char *str) {
    printf("%s", str);
}

int main() {
    char Sin[1000]; 
    int N;

    printf("Enter the string Sin: ");
    fgets(Sin, sizeof(Sin), stdin);

    Sin[strcspn(Sin, "\n")] = 0;

    printf("Enter the integer N: ");
    scanf("%d", &N);

    int sin_len = strlen(Sin);

    int sout_len = sin_len * N;
    char *d_Sin, *d_Sout;
    cudaMalloc((void**)&d_Sin, sin_len * sizeof(char));
    cudaMalloc((void**)&d_Sout, sout_len * sizeof(char));

    cudaMemcpy(d_Sin, Sin, sin_len * sizeof(char), cudaMemcpyHostToDevice);

    int blockSize = 256;
    int numBlocks = (sout_len + blockSize - 1) / blockSize;

    repeatStringKernel<<<numBlocks, blockSize>>>(d_Sin, d_Sout, sin_len, N);

    cudaError_t err = cudaGetLastError();
    if (err != cudaSuccess) {
        printf("CUDA error: %s\n", cudaGetErrorString(err));
    }

    char Sout[1000]; 
    cudaMemcpy(Sout, d_Sout, sout_len * sizeof(char), cudaMemcpyDeviceToHost);

    Sout[sout_len] = '\0';

    printf("\nOutput string Sout: ");
    printString(Sout);
    printf("\n");

    cudaFree(d_Sin);
    cudaFree(d_Sout);

    return 0;
}
