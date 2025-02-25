#include <stdio.h>
#include <cuda_runtime.h>

__global__ void countOccurrences(char *str, int *count, int len) {
    int idx = threadIdx.x + blockIdx.x * blockDim.x;

    if (idx < len) {
        if (str[idx] == 'a' ) {
            atomicAdd(count, 1);  
        }
    }
}

int main() {
    char str[100];
    printf("Enter string : ");
    fflush(stdout);
    scanf("%s",str);

    int len = strlen(str);

    char *d_str;
    int *d_count;
    int h_count = 0;

    cudaMalloc((void**)&d_str, len * sizeof(char));
    cudaMalloc((void**)&d_count, sizeof(int));

    cudaMemcpy(d_str, str, len * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_count, &h_count, sizeof(int), cudaMemcpyHostToDevice);

    int blockSize = 256;  
    int numBlocks = (len + blockSize - 1) / blockSize;  

    countOccurrences<<<numBlocks, blockSize>>>(d_str, d_count, len);

    cudaMemcpy(&h_count, d_count, sizeof(int), cudaMemcpyDeviceToHost);

    printf("Number of occurrences of 'a': %d\n", h_count);

    cudaFree(d_str);
    cudaFree(d_count);

    return 0;
}
