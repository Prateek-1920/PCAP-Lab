#include <stdio.h>
#include <string.h>
#include <cuda_runtime.h>

__global__ void copyStringKernel(const char* S, char* RS, int lenS) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    if (idx < lenS) {
        int numCharsToCopy = lenS - idx;

        int startPos = (lenS * (lenS + 1)) / 2 - (numCharsToCopy * (numCharsToCopy + 1)) / 2;

        for (int i = 0; i < numCharsToCopy; i++) {
            RS[startPos + i] = S[i];
        }
    }
}

int main() {
    const char* S = "PCAP";
    int lenS = strlen(S);
    int lenRS = (lenS * (lenS + 1)) / 2; 

    char* h_RS = (char*)malloc((lenRS + 1) * sizeof(char)); 
    h_RS[lenRS] = '\0';

    char *d_S, *d_RS;
    cudaMalloc((void**)&d_S, lenS * sizeof(char));
    cudaMalloc((void**)&d_RS, (lenRS + 1) * sizeof(char)); 

    cudaMemcpy(d_S, S, lenS * sizeof(char), cudaMemcpyHostToDevice);
    
    int threadsPerBlock = 256;
    int blocksPerGrid = (lenS + threadsPerBlock - 1) / threadsPerBlock;
    copyStringKernel<<<blocksPerGrid, threadsPerBlock>>>(d_S, d_RS, lenS);

    cudaMemcpy(h_RS, d_RS, (lenRS + 1) * sizeof(char), cudaMemcpyDeviceToHost);

    printf("Input S: %s\n", S);
    printf("Output RS: %s\n", h_RS);

    cudaFree(d_S);
    cudaFree(d_RS);
    
    free(h_RS);

    return 0;
}