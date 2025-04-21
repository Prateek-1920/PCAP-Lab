#include<stdio.h>
#include<cuda_runtime.h>

__global__ void onescomp(int *a, int* b, int n){
    int idx = blockDim.x * blockIdx.x + threadIdx.x;
    if(idx < n){
        b[idx] = ~a[idx] & 0b11111; // Mask to keep only the lower 5 bits
    }
}

int main(){
    int bin[5] = {0b11011,0b10101,0b11100,0b00101,0b00100}; //binary literals
    int n = sizeof(bin) / sizeof(bin[0]);

    int *d_a, *d_b;
    cudaMalloc((void**)&d_a,n*sizeof(int));
    cudaMalloc((void**)&d_b,n*sizeof(int));

    cudaMemcpy(d_a,bin,n*sizeof(int),cudaMemcpyHostToDevice);

    int THREADS_PER_BLOCK = 256;
    int numblocks = n+THREADS_PER_BLOCK-1/THREADS_PER_BLOCK;

    onescomp<<<numblocks,THREADS_PER_BLOCK>>>(d_a,d_b,n);

    int res[5];
    cudaMemcpy(res,d_b,n*sizeof(int),cudaMemcpyDeviceToHost);

    printf("Original  |  Ones complement : \n");
    for(int i=0;i<n;i++){
        printf("%5d  %5d\n",bin[i],res[i]);
    }

    cudaFree(d_a);
    cudaFree(d_b);

    return 0;

}