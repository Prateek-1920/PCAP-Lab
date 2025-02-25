#include <stdio.h>
#include <string.h>
#include <cuda_runtime.h>

__global__ void generateOutputStringKernel(const char* d_input, char* d_output, int input_length) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    if (idx < input_length) {
        int repeat_count = idx + 1;

        int start_pos = 0;
        for (int i = 0; i < idx; i++) {
            start_pos += (i + 1); 
        }

        for (int j = 0; j < repeat_count; j++) {
            d_output[start_pos + j] = d_input[idx];
        }
    }
}

int main() {
    char input[100];

    printf("Enter a string: ");
    fgets(input, sizeof(input), stdin);
    
    size_t len = strlen(input);
    if (len > 0 && input[len - 1] == '\n') {
        input[len - 1] = '\0';
    }

    int input_length = strlen(input);
    int output_length = (input_length * (input_length + 1)) / 2;

    char *d_input, *d_output;
    cudaMalloc((void**)&d_input, input_length * sizeof(char));
    cudaMalloc((void**)&d_output, (output_length + 1) * sizeof(char));

    cudaMemcpy(d_input, input, input_length * sizeof(char), cudaMemcpyHostToDevice);

    int threadsPerBlock = 256;
    int blocksPerGrid = (input_length + threadsPerBlock - 1) / threadsPerBlock;
    generateOutputStringKernel<<<blocksPerGrid, threadsPerBlock>>>(d_input, d_output, input_length);

    char* output = (char*)malloc((output_length + 1) * sizeof(char));  

    cudaMemcpy(output, d_output, output_length * sizeof(char), cudaMemcpyDeviceToHost);
    output[output_length] = '\0'; 

    printf("Output: %s\n", output);

    cudaFree(d_input);
    cudaFree(d_output);
    
    free(output);

    return 0;
}