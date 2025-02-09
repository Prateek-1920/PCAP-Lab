#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[])
{
    int rank, size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

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

    int newarr[10];
    int c;

    MPI_Scatter(arr, 1, MPI_INT, &c, 1, MPI_INT, 0, MPI_COMM_WORLD);

    c = c * c;
    MPI_Gather(&c, 1, MPI_INT, newarr, 1, MPI_INT, 0, MPI_COMM_WORLD);
    printf("Process %d gathered %d\n", rank, c);
    fflush(stdout);

    if (rank == 0)
    {
        printf("Result gathered in root:\n");
        fflush(stdout);
        for (int i = 0; i < size; i++)
        {
            printf("%d  ", newarr[i]);
            fflush(stdout);
        }
    }

    MPI_Finalize();

    return 0;
}
