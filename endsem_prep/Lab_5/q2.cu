#include<stdio.h>
#include<cuda_runtime.h>

# define THREADS_PER_BLOCK 256

__global__ void vectoradd(int *a, int *b, int *c){
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if(idx<THREADS_PER_BLOCK){
        c[idx] = a[idx] + b[idx];
    }
}

int main(){
    int n;
    printf("Enter N: ");
    scanf("%d",&n);

    int A[n], B[n], C[n];

    printf("Enter elements of A: ");
    for(int i=0;i<n;i++){
        scanf("%d",&A[i]);
    }

    printf("Enter elements of B: ");
    for(int i=0;i<n;i++){
        scanf("%d",&B[i]);
    }

    int *d_a, *d_b, *d_c;
    cudaMalloc((void**)&d_a,n*sizeof(int));
    cudaMalloc((void**)&d_b,n*sizeof(int));
    cudaMalloc((void**)&d_c,n*sizeof(int));

    cudaMemcpy(d_a,A,n*sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(d_b,B,n*sizeof(int),cudaMemcpyHostToDevice);

    // numBlocks = N / THREADS_PER_BLOCK;
    // But if it's not evenly divisible, you'll need one extra block to cover the remaining threads.


    int numblocks = (n +THREADS_PER_BLOCK - 1)/THREADS_PER_BLOCK;

    vectoradd<<<numblocks,THREADS_PER_BLOCK>>>(d_a,d_b,d_c);

    cudaMemcpy(C,d_c,n*sizeof(int),cudaMemcpyDeviceToHost);

    printf("A array : ");
    for(int i=0;i<n;i++){
        printf("%d  ",A[i]);
    }

    printf("\nB array : ");
        for(int i=0;i<n;i++){
            printf("%d  ",B[i]);
        }

    printf("\nResultant array : ");
    for(int i=0;i<n;i++){
        printf("%d  ",C[i]);
    }

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    return 0;
    
}