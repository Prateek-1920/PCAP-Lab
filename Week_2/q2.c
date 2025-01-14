#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "mpi.h"

int main(int argc, char *argv[])
{
    int rank, size, x;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    MPI_Status status;

    if (rank == 0)
    {
        for (int i = 1; i < size; i++)
        {
            int data = rand();
            MPI_Send(&data, 1, MPI_INT, i, 0, MPI_COMM_WORLD);
            printf("Process 0 sent data: %d to process %d\n", data, i);
        }
    }
    else
    {
        int num;
        MPI_Recv(&num, 1, MPI_INT, 0, MPI_ANY_TAG, MPI_COMM_WORLD, &status);

        printf("Process %d received %d. \n", rank, num);
    }

    MPI_Finalize();
    return 0;
}
