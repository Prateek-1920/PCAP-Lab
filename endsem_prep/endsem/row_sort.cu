#include<stdio.h>
#include<cuda_runtime.h>

__global__ void sort(int *A, int rows, int cols){
    int row = blockDim.y * blockIdx.y + threadIdx.y;
    if(row<rows){
        for(int i=0;i<cols;i++){
            for(int j=0;j<cols-1-i;j++){
            int idx = row * cols + j;
            if(A[idx] > A[idx+1]){
                int temp = A[idx];
                A[idx] = A[idx+1];
                A[idx+1] = temp;
            }
            }
        }
    }
}

int main(){

    cudaEvent_t start,stop;
    float ms = 0;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    int m,n;
    printf("Enter m and n: ");
    scanf("%d%d",&m,&n);

    int A[m][n] , B[m][n];
    printf("Enter elements: ");
    for(int i=0;i<m;i++){
        for(int j=0;j<n;j++){
            scanf("%d",&A[i][j]);
        }
    }

    int *d_a;
    cudaMalloc((void**)&d_a,m*n*sizeof(int));
    cudaMemcpy(d_a,A,n*m*sizeof(int),cudaMemcpyHostToDevice);

    dim3 blockspergrid(3,3);
    dim3 threadsperblock(16,16);

    cudaEventRecord(start);
    sort<<<blockspergrid,threadsperblock>>>(d_a,m,n);
    cudaDeviceSynchronize();
    cudaEventRecord(stop);


    cudaMemcpy(B,d_a,m*n*sizeof(int),cudaMemcpyDeviceToHost);

    printf("\nMatrix before row sorting\n");
    for(int i=0;i<m;i++){
        for(int j=0;j<n;j++){
            printf("%d  ",A[i][j]);
        }
        printf("\n");
    }

    printf("\nMatrix after row sorting\n");
    for(int i=0;i<m;i++){
        for(int j=0;j<n;j++){
            printf("%d  ",B[i][j]);
        }
        printf("\n");
    }

    cudaEventElapsedTime(&ms,start,stop);
    printf("Time taken = %f",ms);

    cudaFree(d_a);
    return 0;
}