#include <stdio.h>
#include <math.h>
#include <stdbool.h>
#include <mpi.h>

bool prime(int n)
{
    if (n == 2)
    {
        return true;
    }
    if (n % 2 == 0)
    {
        return false;
    }
    for (int i = 3; i <= sqrt(n); i = i + 2)
    {
        if (n % i == 0)
        {
            return false;
        }
    }
    return true;
}

int main(int argc, char *argv[])
{
    int rank, size;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0)
    {
        printf("Process %d : ", rank);
        for (int i = 2; i < 50; i++)
        {
            if (prime(i))
            {
                printf("%d ", i);
                fflush(stdout);
            }
        }
        printf("\n");
    }
    else if (rank == 1)
    {
        printf("Process %d : ", rank);
        for (int i = 50; i <= 100; i++)
        {
            if (prime(i))
            {
                printf("%d ", i);
                fflush(stdout);
            }
        }
        printf("\n");
    }

    MPI_Finalize();
    return 0;
}
