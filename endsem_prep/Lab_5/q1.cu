#include<stdio.h>
#include<cuda_runtime.h>


__global__ void vectoradd(int *a, int *b, int *c,int n){
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if(idx<n){
        c[idx] = a[idx] + b[idx];
    }
}

int main(){
    int n;

    printf("Enter N: ");
    scanf("%d",&n);

    int A[n],B[n],C[n];

    printf("Enter elements of A: ");
    for(int i=0;i<n;i++){
        scanf("%d",&A[i]);
    }

    printf("Enter elements of B: ");
    for(int i=0;i<n;i++){
        scanf("%d",&B[i]);
    }

    int *d_a,*d_b,*d_c;
    cudaMalloc((void**)&d_a,n*sizeof(int));
    cudaMalloc((void**)&d_b,n*sizeof(int));
    cudaMalloc((void**)&d_c,n*sizeof(int));

    cudaMemcpy(d_a,A,n*sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(d_b,B,n*sizeof(int),cudaMemcpyHostToDevice);

    vectoradd<<<1,n>>>(d_a,d_b,d_c,n);

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