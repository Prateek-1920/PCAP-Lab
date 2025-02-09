#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[])
{
    int rank, size;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int a = 5, b = 4;
    if (rank == 0)
    {
        printf("Enter a and b : ");
        fflush(stdout);
        scanf("%d%d", &a, &b);
    }

    MPI_Bcast(&a, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(&b, 1, MPI_INT, 0, MPI_COMM_WORLD);

    {
        if (rank == 1)
        {
            printf("%d + %d = %d\n", a, b, a + b);
        }
        else if (rank == 2)
        {
            printf("%d - %d = %d\n", a, b, a - b);
        }
        else if (rank == 3)
        {
            printf("%d / %d = %d\n", a, b, a / b);
        }
        else if (rank == 4)
        {
            printf("%d * %d = %d\n", a, b, a * b);
        }
    }
    MPI_Finalize();

    return 0;
}
