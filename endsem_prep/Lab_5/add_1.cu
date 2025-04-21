#include<stdio.h>
#include<cuda_runtime.h>

#define THREADS_PER_BLOCK 256

__global__ void sort(int *matrix, int rows, int cols){
    int row = blockIdx.x;
    int idx = threadIdx.x;

    if(row<rows){
        for(int i=0;i<cols-1;i++){
            if(idx==i){
                int minidx = i;
                for(int j=i+1;j<cols;j++){
                    if(matrix[row*cols+j] < matrix[row*cols+minidx]){
                        minidx = j;
                    }
                }

                if(minidx!=i){
                    int temp = matrix[row*cols+i];
                    matrix[row*cols+i] = matrix[row*cols+minidx];
                    matrix[row*cols+minidx] = temp;
                }
            }
        }
    }
}

int main(){
    int m,n;
    printf("Enter m and n: ");
    scanf("%d%d",&m,&n);

    int A[m][n];

    printf("Enter matrix: \n");
    for(int i=0;i<m;i++){
        for(int j=0;j<n;j++){
            scanf("%d",&A[i][j]);
        }
    }

    printf("Matrix before sorting\n");
    for(int i=0;i<m;i++){
        for(int j=0;j<n;j++){
            printf("%d  ",A[i][j]);
        }
        printf("\n");
    }


    int *d_a;
    size_t size = m*n*sizeof(int);
    cudaMalloc((void**)&d_a,size);

    cudaMemcpy(d_a,A,size,cudaMemcpyHostToDevice);
    
    sort<<<m,n>>>(d_a,m,n);

    cudaMemcpy(A,d_a,size,cudaMemcpyDeviceToHost);

    printf("Matrix after sorting\n");
    for(int i=0;i<m;i++){
        for(int j=0;j<n;j++){
            printf("%d  ",A[i][j]);
        }
        printf("\n");
    }

    cudaFree(d_a);
    return 0;


}