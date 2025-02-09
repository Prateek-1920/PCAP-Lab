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

    int size, rank;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Status status;

    int arr[10];
    if (rank == 0)
    {
        printf("Enter values: ");
        fflush(stdout);
        for (int i = 0; i < size; i++)
        {
            scanf("%d", &arr[i]);
        }
    }

    int c;
    int newarr[10];

    MPI_Scatter(arr, 1, MPI_INT, &c, 1, MPI_INT, 0, MPI_COMM_WORLD);
    c = fact(c);

    printf("Process %d sent %d\n", rank, c);
    fflush(stdout);

    MPI_Gather(&c, 1, MPI_INT, newarr, 1, MPI_INT, 0, MPI_COMM_WORLD);

    int sum = 0;

    if (rank == 0)
    {
        printf("Result in root : ");
        fflush(stdout);

        for (int i = 0; i < size; i++)
        {
            printf("%d  ", newarr[i]);
            sum += newarr[i];
        }

        printf("\nTtoal in root : %d\n", sum);
        fflush(stdout);
    }

    MPI_Finalize();

    return 0;
}
