#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[])
{
    int size, rank;
    int x;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    MPI_Status status;

    if (rank == 0)
    {
        printf("Enter value in root : \n");
        fflush(stdout);
        scanf("%d", &x);
        for (int i = 0; i < size; i++)
        {
            MPI_Send(&x, 1, MPI_INT, i, 1, MPI_COMM_WORLD);
            printf("Sent %d from process 0\n", x);
        }
        fflush(stdout);
    }
    else
    {
        MPI_Recv(&x, 1, MPI_INT, 0, 1, MPI_COMM_WORLD, &status);
        // printf("Recieved %d in process %d\n", x, rank);
        // fflush(stdout);
    }
    printf("Recieved %d in process %d\n", x, rank);
    fflush(stdout);

    MPI_Finalize();

    return 0;
}
