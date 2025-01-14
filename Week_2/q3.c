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

    int arr[] = {1, 2, 3, 4, 5};

    int buffer[100];
    MPI_Buffer_attach(buffer, sizeof(buffer));

    if (rank == 0)
    {
        for (int i = 1; i < 5; i++)
        {
            int num = arr[i-1];
            MPI_Bsend(&num, 1, MPI_INT, i, 0, MPI_COMM_WORLD);
            printf("Process 0 sent data: %d to process %d\n", num, i);
        }
    }
    else
    {
        int x;
        MPI_Recv(&x, 1, MPI_INT, 0, MPI_ANY_TAG, MPI_COMM_WORLD, &status);

        if (rank % 2 == 0)
        {
            printf("Process %d received %d, Ans = %d \n", rank, x, x * x);
        }
        else
        {
            printf("Process %d received %d, Ans = %d \n", rank, x, x * x * x);
        }
    }

    MPI_Buffer_detach(&buffer, &size);

    MPI_Finalize();
    return 0;
}
