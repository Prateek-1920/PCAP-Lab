#include<stdio.h>
#include<cuda_runtime.h>
#include<math.h>

__global__ void sine(float *a,float *b, int n){
    int idx = blockDim.x * blockIdx.x + threadIdx.x;
    if(idx<n){
        b[idx] = sinf(a[idx]);
    }
}

int main(){
    int n;
    printf("Enter n: ");
    scanf("%d",&n);
    float A[n];
    float B[n];

    printf("Enter values: ");
    for(int i=0;i<n;i++){
        scanf("%f",&A[i]);
    }

    float *d_a, *d_b;
    cudaMalloc((void**)&d_a,n*sizeof(float));
    cudaMalloc((void**)&d_b,n*sizeof(float));

    cudaMemcpy(d_a,A,n*sizeof(float),cudaMemcpyHostToDevice);

    sine<<<1,n>>>(d_a,d_b,n);

    cudaMemcpy(B,d_b,n*sizeof(float),cudaMemcpyDeviceToHost);

    printf("Sine values: ");
    for(int i=0;i<n;i++){
        printf("%f",B[i]);
    }

    cudaFree(d_a);
    cudaFree(d_b);

    return 0;
}