#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[])
{
    int rank, size;
    int x;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    MPI_Status status;

    if (rank == 0)
    {
        printf("Enter integer : ");
        fflush(stdout);
        scanf("%d", &x);
        MPI_Ssend(&x, 1, MPI_INT, 1, 1, MPI_COMM_WORLD);
        printf("Process 0 sent %d to process 1\n", x);
        fflush(stdout);
    }

    else
    {
        int y;
        MPI_Recv(&y, 1, MPI_INT, rank - 1, 1, MPI_COMM_WORLD, &status);
        y++;
        printf("Process %d recieved %d from process %d\n", rank, y, rank - 1);
        fflush(stdout);

        if (rank < size - 1)
        {
            MPI_Ssend(&y, 1, MPI_INT, rank + 1, 1, MPI_COMM_WORLD);
            printf("Process %d sent %d to process %d\n", rank, y, rank + 1);
        }
    }

    MPI_Finalize();
    return 0;
}
