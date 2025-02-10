#include <stdio.h>
#include <mpi.h>

int fact(int n)
{
    if (n <= 1)
    {
        return 1;
    }
    else
    {
        return n * fact(n - 1);
    }
}

int main(int argc, char *argv[])
{
    int rank, size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int n;
    int localfact = 1;
    int finalsum = 0;

    localfact = fact(rank + 1);
    MPI_Scan(&localfact, &finalsum, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
    printf("Process %d calculated %d\n", rank, finalsum);
    if (rank == size - 1)
    {
        printf("Sum of all factorials : %d\n", finalsum);
    }
    MPI_Finalize();
    return 0;
}