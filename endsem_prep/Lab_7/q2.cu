#include<stdio.h>
#include<string.h>
#include<cuda_runtime.h>


__global__ void stringcat(char *s, char *res, int len){
    int idx = blockDim.x * blockIdx.x + threadIdx.x;
    if(idx<len){
        int copylen = len-idx;
        int startpos = (len * (len + 1)) / 2 - (copylen * (copylen+ 1)) / 2;

        for(int i=0;i<copylen;i++){
            res[i+startpos] = s[i];
        }
    }
}


int main(){
    char s[100];
    printf("Enter string: ");
    scanf("%s",s);
    
    int len = strlen(s);
    s[len]='\0';
    int reslen = (len * (len+1))/2;

    char *d_s, *res;
    cudaMalloc((void**)&d_s,len*sizeof(char));
    cudaMalloc((void**)&res,reslen*sizeof(char));

    cudaMemcpy(d_s,s,len*sizeof(char),cudaMemcpyHostToDevice);

    int THREADS_PER_BLOCK = 256;
    int numblocks = (len + THREADS_PER_BLOCK -1) /THREADS_PER_BLOCK;

    stringcat<<<numblocks,THREADS_PER_BLOCK>>>(d_s,res,len);

    char ans[100];
    cudaMemcpy(ans,res,reslen*sizeof(char),cudaMemcpyDeviceToHost);
    ans[reslen] = '\0';

    printf("Resultant string : %s\n",ans);

    cudaFree(d_s);
    cudaFree(res);

    return 0;

}