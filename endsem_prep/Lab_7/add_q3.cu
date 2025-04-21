#include<stdio.h>
#include<string.h>
#include<cuda_runtime.h>

__global__ void mult(char *s, char *res, int len){
    int idx = blockDim.x * blockIdx.x + threadIdx.x;
    if(idx < len){
        int repeatcount = idx+1;
        int start_pos = 0;
        for (int i = 0; i < idx; i++) {
            start_pos += (i + 1); 
        }

        for (int j = 0; j < repeatcount; j++) {
            res[start_pos + j] = s[idx];
        }
    }
}

int main(){
    char s[100];
    printf("Enter string: ");
    scanf("%s",s);
    
    int len = strlen(s);
    s[len] = '\0';

    int reslen = (len * (len+1))/2;
    char *d_s, *res;
    cudaMalloc((void**)&d_s,len*sizeof(char));
    cudaMalloc((void**)&res,reslen*sizeof(char));

    cudaMemcpy(d_s,s,len*sizeof(char),cudaMemcpyHostToDevice);

    int THREADS = 256;
    int numblocks = (len + THREADS -1 )/ THREADS;

    mult<<<numblocks,THREADS>>>(d_s,res,len);

    char ans[100];
    cudaMemcpy(ans,res,reslen*sizeof(char),cudaMemcpyDeviceToHost);
    ans[reslen] = '\0';

    printf("Original string : %s \nResult string : %s \n",s,ans);

    cudaFree(d_s);
    cudaFree(res);
}
