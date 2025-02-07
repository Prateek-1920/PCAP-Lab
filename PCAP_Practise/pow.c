#include <stdio.h>
#include <mpi.h>

int power(int x, int n)
{
    if (n == 0)
    {
        return 1;
    }
    return x * power(x, n - 1);
}

int main(int argc, char *argv[])
{
    int rank, size;
    int x = 4;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int res = power(x, rank);
    printf("%d ^ %d = %d\n", x, rank, res);

    MPI_Finalize();

    return 0;
} 