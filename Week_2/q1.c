#include <stdio.h>
#include <string.h>
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
        char string[] = "Hello world";
        MPI_Ssend(string, strlen(string) + 1, MPI_CHAR, 1, 0, MPI_COMM_WORLD);
        MPI_Recv(string, strlen(string) + 1, MPI_CHAR, 1, 0, MPI_COMM_WORLD, &status);
        printf("Process 0 : %s\n", string);
    }
    else if (rank == 1)
    {
        char string[100];
        MPI_Recv(string, 100, MPI_CHAR, 0, 0, MPI_COMM_WORLD, &status);
        for (int i = 0; i < strlen(string); i++)
        {
            string[i] = string[i] ^ 32;
        }
        MPI_Ssend(string, strlen(string) + 1, MPI_CHAR, 0, 0, MPI_COMM_WORLD);
    }

    MPI_Finalize();
    return 0;
}

