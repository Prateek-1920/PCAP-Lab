#include<stdio.h>
#include<cuda_runtime.h>

#define THREADS_PER_BLOCK 8

__global__ void oddeven(int *a, int n, int phase){
    int idx = blockDim.x * blockIdx.x + threadIdx.x;
    int i = phase%2==0? 2*idx : 2*idx+1;

    if(i+1<n){
        if(a[i+1]<a[i]){
            int temp = a[i+1];
            a[i+1] = a[i];
            a[i] = temp;
        }
    }
}

int main(){
    int n;
    printf("Enter n: ");
    scanf("%d",&n);

    int A[n];
    printf("Enter elements: ");
    for(int i=0;i<n;i++){
        scanf("%d",&A[i]);
    }

    int *d_a;
    cudaMalloc((void**)&d_a,n*sizeof(int));

    cudaMemcpy(d_a,A,n*sizeof(int),cudaMemcpyHostToDevice);

    int numblocks = n + THREADS_PER_BLOCK -1 /THREADS_PER_BLOCK;

    printf("Array before sorting : ");
    for(int i=0;i<n;i++){
        printf("%d  ",A[i]);
    }

    for(int phase=0;phase<n;phase++){
        oddeven<<<numblocks,THREADS_PER_BLOCK>>>(d_a,n,phase);
    }
    cudaMemcpy(A,d_a,n*sizeof(int),cudaMemcpyDeviceToHost);

    printf("\nArray after sorting : ");
    for(int i=0;i<n;i++){
        printf("%d  ",A[i]);
    }

    cudaFree(d_a);
    return 0;


}