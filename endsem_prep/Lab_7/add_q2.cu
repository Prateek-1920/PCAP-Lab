#include<stdio.h>
#include<cuda_runtime.h>
#include<string.h>

__global__ void multiply(char *str, char *res, int len, int k){
    int idx = blockDim.x * blockIdx.x + threadIdx.x;
    if(idx < len){
        for(int i=0;i<k;i++){
            res[idx+(i*len)]=str[idx];
        }
    }
}

int main(){
    char s[100];
    int n;
    printf("Enter string: ");
    scanf("%s",s);

    printf("Enter n: ");
    scanf("%d",&n);

    int len = strlen(s);
    s[len] = '\0';

    char *d_s, *res;
    cudaMalloc((void**)&d_s,len*sizeof(char));
    cudaMalloc((void**)&res,len*n*sizeof(char));

    cudaMemcpy(d_s,s,len*sizeof(char),cudaMemcpyHostToDevice);

    int THREADS = 256;
    int numblocks = (len + THREADS -1 )/ THREADS;

    multiply<<<numblocks,THREADS>>>(d_s,res,len,n);

    char ans[100];
    cudaMemcpy(ans,res,len*n*sizeof(char),cudaMemcpyDeviceToHost);
    ans[len*n] = '\0';

    printf("Original string : %s \nResult string : %s \n",s,ans);

    cudaFree(d_s);
    cudaFree(res);

    return 0;

}


