#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[])
{
    int rank, size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int x;
    if (rank == 0)
    {
        printf("Enter value: \n");
        fflush(stdout);
        scanf("%d", &x);
        printf("Process 0 broadcasted %d\n", x);
        fflush(stdout);
    }
    MPI_Bcast(&x, 1, MPI_INT, 0, MPI_COMM_WORLD);

    printf("Process %d recieved %d\n", rank, x);
    fflush(stdout);

    MPI_Finalize();

    return 0;
}
