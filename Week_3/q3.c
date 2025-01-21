#include "mpi.h"
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

int main(int argc, char *argv[]) {
    int rank, size, n, i;
    char *A = NULL, *B = NULL;
    int *D = NULL;
    int count = 0;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0) {
        printf("Enter a string divisible by %d: ", size);
        fflush(stdout);

        A = (char *)malloc(1000 * sizeof(char));  
        scanf("%s", A);

        int len = strlen(A);
        if (len % size != 0) {
            printf("The string length is not divisible by the number of processes.\n");
            MPI_Abort(MPI_COMM_WORLD, 1);
        }

        n = len / size;
    }

    MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);

    B = (char *)malloc(n * sizeof(char));

    MPI_Scatter(A, n, MPI_CHAR, B, n, MPI_CHAR, 0, MPI_COMM_WORLD);

    for (i = 0; i < n; i++) {
        char ch = tolower(B[i]);
        if (ch != 'a' && ch != 'e' && ch != 'i' && ch != 'o' && ch != 'u') {
            count++;
        }
    }

    D = (int *)malloc(size * sizeof(int));
    MPI_Gather(&count, 1, MPI_INT, D, 1, MPI_INT, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        int total_count = 0;
        printf("\nNumber of non-vowels found by each process:\n");
        for (i = 0; i < size; i++) {
            printf("Process %d: %d non-vowels\n", i, D[i]);
            total_count += D[i];
        }
        printf("\nFinal total count of Non-Vowels: %d\n", total_count);

        free(A);
        free(D);
    }

    free(B);

    MPI_Finalize();
    return 0;
}