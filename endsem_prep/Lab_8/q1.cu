#include<stdio.h>
#include<cuda_runtime.h>

__global__ void addmatrix(int *A, int *B, int *C, int rows, int cols){
    int row = blockDim.y * blockIdx.y + threadIdx.y;
    int col = blockDim.x * blockIdx.x + threadIdx.x;
    if(row < rows && col < cols){
        int idx = row*cols + col;
        C[idx] = A[idx] + B[idx];
    }
}

int main(){
    int m,n;
    printf("Enter rows and cols: ");
    scanf("%d%d",&m,&n);

    int A[m][n],B[m][n],C[m][n];
    printf("Enter elemenets 1: ");
    for(int i=0;i<m;i++){
        for(int j=0;j<n;j++){
            scanf("%d",&A[i][j]);
        }
    }
    printf("Enter elemenets 2: ");
    for(int i=0;i<m;i++){
        for(int j=0;j<n;j++){
            scanf("%d",&B[i][j]);
        }
    }

    int *d_a, *d_b, *d_c;
    cudaMalloc((void**)&d_a,m*n*sizeof(int));
    cudaMalloc((void**)&d_b,m*n*sizeof(int));
    cudaMalloc((void**)&d_c,m*n*sizeof(int));
    cudaMemcpy(d_a,A,m*n*sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(d_b,B,m*n*sizeof(int),cudaMemcpyHostToDevice);

    dim3 blockspergrid(4,4);
    dim3 threadsperblock(16,16);
    addmatrix<<<blockspergrid,threadsperblock>>>(d_a,d_b,d_c,m,n);

    cudaMemcpy(C,d_c,m*n*sizeof(int),cudaMemcpyDeviceToHost);
    printf("Matrix A : \n");
    for(int i=0;i<m;i++){
        for(int j=0;j<n;j++){
            printf("%d  ",A[i][j]);
        }
        printf("\n");
    }

    printf("\nMatrix B : \n");
    for(int i=0;i<m;i++){
        for(int j=0;j<n;j++){
            printf("%d  ",B[i][j]);
        }
        printf("\n");
    }

    printf("\nMatrix C : \n");
    for(int i=0;i<m;i++){
        for(int j=0;j<n;j++){
            printf("%d  ",C[i][j]);
        }
        printf("\n");
    }

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    return 0;

}