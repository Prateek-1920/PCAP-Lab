#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "mpi.h"

int main(int argc, char *argv[])
{
    int rank, size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    MPI_Status status;

    if (rank == 0)
    {
        int x;
        printf("Enter a number : \n");
        scanf("%d", &x);

        MPI_Send(&x, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
        MPI_Recv(&x, 1, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
        printf("Root process received : %d\n", x);
    }
    else
    {
        int x;
        MPI_Recv(&x, 1, MPI_INT, rank - 1, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
        printf("Process %d received %d. \n", rank, x);

        x++;
        int next = (rank + 1) % size;
        MPI_Send(&x, 1, MPI_INT, next, 0, MPI_COMM_WORLD);
    }

    MPI_Finalize();
    return 0;
}
