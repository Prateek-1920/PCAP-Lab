#include <stdio.h>
#include <cuda.h>
#include <math.h> // For sinf() function

// Kernel to compute sine of each angle in the input array
__global__ void computeSine(float *angles, float *sineValues, int N)
{
    int idx = blockIdx.x * blockDim.x + threadIdx.x; // Global thread index

    // Process only valid indices within the array
    if (idx < N)
    {
        sineValues[idx] = sinf(angles[idx]); // Calculate sine for each angle
        printf("Thread %d: Sine of angle %.3f radians = %.3f\n", threadIdx.x, angles[idx], sineValues[idx]);
    }
}

void processAngles(float *angles, float *sineValues, int N)
{
    float *d_angles, *d_sineValues;

    // Allocate device memory for input and output arrays
    cudaMalloc((void **)&d_angles, N * sizeof(float));
    cudaMalloc((void **)&d_sineValues, N * sizeof(float));

    // Copy input array from host to device
    cudaMemcpy(d_angles, angles, N * sizeof(float), cudaMemcpyHostToDevice);

    // Calculate number of blocks and threads
    int threadsPerBlock = 256;
    int numBlocks = (N + threadsPerBlock - 1) / threadsPerBlock;

    // Launch kernel to compute sine values
    computeSine<<<numBlocks, threadsPerBlock>>>(d_angles, d_sineValues, N);

    // Copy result from device to host
    cudaMemcpy(sineValues, d_sineValues, N * sizeof(float), cudaMemcpyDeviceToHost);

    // Free device memory
    cudaFree(d_angles);
    cudaFree(d_sineValues);
}

int main()
{
    int N = 5; // Length of the array (you can change this to any value)

    float *angles = (float *)malloc(N * sizeof(float));
    float *sineValues = (float *)malloc(N * sizeof(float));

    // Initialize angles array (example: 0, PI/6, PI/4, PI/2, ...)
    for (int i = 0; i < N; i++)
    {
        angles[i] = i * 3.14159265358979f / 6.0f; // Example angles in radians (multiples of pi/6)
    }

    // Process angles and compute sine values
    processAngles(angles, sineValues, N);

    // Print results
    printf("Angle (radians)     Sine of Angle\n");
    for (int i = 0; i < N; i++)
    {
        printf("%.3f               %.3f\n", angles[i], sineValues[i]);
    }

    // Free host memory
    free(angles);
    free(sineValues);

    return 0;
}
