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
    // if (rank == 0)
    // {
    //     printf("Enter n: ");
    //     fflush(stdout);
    //     scanf("%d", &n);
    // }

    // MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);

    localfact = fact(rank + 1);
    MPI_Reduce(&localfact, &finalsum, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
    printf("Process %d calculated %d\n", rank, finalsum);

    if (rank == 0)
    {
        printf("Sum of all factorials : %d", finalsum);
    }
    MPI_Finalize();
    return 0;
}