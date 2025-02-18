#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void odd_phase(int* arr, int n) {
    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    if (idx % 2 == 1 && idx < n - 1) {
        if (arr[idx] > arr[idx + 1]) {
            int temp = arr[idx];
            arr[idx] = arr[idx + 1];
            arr[idx + 1] = temp;
        }
    }
}

__global__ void even_phase(int* arr, int n) {
    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    if (idx % 2 == 0 && idx < n - 1) {
        if (arr[idx] > arr[idx + 1]) {
            int temp = arr[idx];
            arr[idx] = arr[idx + 1];
            arr[idx + 1] = temp;
        }
    }
}

void odd_even_transposition_sort(int* arr, int n) {
    int *d_arr;
    cudaMalloc((void**)&d_arr, n * sizeof(int));

    cudaMemcpy(d_arr, arr, n * sizeof(int), cudaMemcpyHostToDevice);

    int blockSize = 256; 
    int numBlocks = (n + blockSize - 1) / blockSize; 

    for (int phase = 0; phase < n; ++phase) {
        if (phase % 2 == 0) {
            even_phase<<<numBlocks, blockSize>>>(d_arr, n);
        } else {
            odd_phase<<<numBlocks, blockSize>>>(d_arr, n);
        }

        cudaDeviceSynchronize();
    }

    cudaMemcpy(arr, d_arr, n * sizeof(int), cudaMemcpyDeviceToHost);

    cudaFree(d_arr);
}

int main() {
    int n;

    printf("Enter the size of the array: ");
    scanf("%d", &n);

    int* arr = (int*)malloc(n * sizeof(int));

    printf("Enter %d elements for the array: ", n);
    for (int i = 0; i < n; i++) {
        scanf("%d", &arr[i]);
    }

    printf("Original Array:\n");
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");

    odd_even_transposition_sort(arr, n);

    printf("Sorted Array:\n");
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");

    free(arr);
    return 0;
}
