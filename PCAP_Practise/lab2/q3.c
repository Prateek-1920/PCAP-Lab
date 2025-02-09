#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[])
{
    int rank, size;
    int n;
    int arr[100];
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int buffer[100];
    MPI_Buffer_attach(buffer, sizeof(buffer));

    MPI_Status status;

    if (rank == 0)
    {
        fprintf(stdout, "Enter elements of array: ");
        fflush(stdout);
        for (int i = 0; i < size; i++)
        {
            scanf("%d", &arr[i]);
        }
        for (int i = 0; i < size; i++)
        {
            MPI_Bsend(&arr[i], 1, MPI_INT, i, 1, MPI_COMM_WORLD);
            fprintf(stdout, "Process 0 sent %d \n", arr[i]);
            fflush(stdout);
        }
    }

    else
    {
        int x;
        MPI_Recv(&x, 1, MPI_INT, 0, 1, MPI_COMM_WORLD, &status);
        if (rank % 2 == 0)
        {
            fprintf(stdout, "Process %d recieved %d and calculated square = %d\n", rank, x, x * x);
            fflush(stdout);
        }
        else
        {
            fprintf(stdout, "Process %d recieved %d and calculated cube = %d\n", rank, x, x * x * x);
            fflush(stdout);
        }
    }

    MPI_Buffer_detach(&buffer, &size);

    MPI_Finalize();
    return 0;
}
