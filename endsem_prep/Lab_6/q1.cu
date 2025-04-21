#include <stdio.h>
#include <cuda_runtime.h>

__global__ void conv(float *org, float *mask, float *res, int width, int mask_width) {
    int idx = blockDim.x * blockIdx.x + threadIdx.x;

    int output_width = width - mask_width + 1;

    if (idx < output_width) {
        float ans = 0.0;
        for (int i = 0; i < mask_width; i++) {
            ans += org[idx + i] * mask[i];
        }
        res[idx] = ans;
    }
}

int main() {
    float org[5] = {1, 2, 3, 4, 5};
    float mask[3] = {3, 3, 3};

    int width = sizeof(org) / sizeof(org[0]);
    int mask_width = sizeof(mask) / sizeof(mask[0]);
    int output_width = width - mask_width + 1;

    float *d_a, *d_b, *d_c;

    cudaMalloc((void**)&d_a, width * sizeof(float));
    cudaMalloc((void**)&d_b, mask_width * sizeof(float));
    cudaMalloc((void**)&d_c, output_width * sizeof(float));

    cudaMemcpy(d_a, org, width * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, mask, mask_width * sizeof(float), cudaMemcpyHostToDevice);

    int threadsPerBlock = 256;
    int blocksPerGrid = (output_width + threadsPerBlock - 1) / threadsPerBlock;
    conv<<<blocksPerGrid, threadsPerBlock>>>(d_a, d_b, d_c, width, mask_width);

    float res[output_width];
    cudaMemcpy(res, d_c, output_width * sizeof(float), cudaMemcpyDeviceToHost);

    printf("Original Array: ");
    for (int i = 0; i < width; i++) {
        printf("%f  ", org[i]);
    }

    printf("\nMask: ");
    for (int i = 0; i < mask_width; i++) {
        printf("%f  ", mask[i]);
    }

    printf("\nResultant Array: ");
    for (int i = 0; i < output_width; i++) {
        printf("%f  ", res[i]);
    }
    printf("\n");

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    return 0;
}
