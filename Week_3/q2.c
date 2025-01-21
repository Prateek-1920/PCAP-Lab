#include "mpi.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    int rank, size, N, M;
    float avg = 0.0;
    int *A = NULL, *B = NULL;
    float *D = NULL;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0) {
        N = size;  
        printf("Enter M (number of elements per process):\n");
        scanf("%d", &M);

        A = (int *)malloc(M * N * sizeof(int));

        printf("Enter %d values :\n", M * N);
        for (int i = 0; i < M * N; i++) {
            scanf("%d", &A[i]);
        }
    }

    B = (int *)malloc(M * sizeof(int));
    D = (float *)malloc(size * sizeof(float));  

    MPI_Bcast(&M, 1, MPI_INT, 0, MPI_COMM_WORLD);

    MPI_Scatter(A, M, MPI_INT, B, M, MPI_INT, 0, MPI_COMM_WORLD);

    printf("Process %d received elements: ", rank);
    for (int i = 0; i < M; i++) {
        printf("%d ", B[i]);
    }
    printf("\n");

    float local_sum = 0.0;
    for (int i = 0; i < M; i++) {
        local_sum += B[i];
    }
    avg = local_sum / M;

    printf("Process %d  average: %f\n", rank, avg);

    MPI_Gather(&avg, 1, MPI_FLOAT, D, 1, MPI_FLOAT, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        avg = 0.0;
        for (int i = 0; i < N; i++) {
            avg += D[i];
        }
        avg = avg / N;
        printf("\nFinal average of all processes = %f\n", avg);

        free(A);
        free(D);
    }

    free(B);

    MPI_Finalize();
    return 0;
}