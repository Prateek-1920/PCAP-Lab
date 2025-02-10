#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[])
{
    int rank, size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int arr[100];

    if (rank == 0)
    {
        printf("Enter values: ");
        fflush(stdout);
        for (int i = 0; i < size; i++)
        {
            scanf("%d  ", &arr[i]);
        }

        printf("Input array: ");
        fflush(stdout);
        for (int i = 0; i < size; i++)
        {
            printf("%d", arr[i]);
        }
        printf("\n");
        fflush(stdout);
    }
    int a;
    MPI_Scatter(arr, 1, MPI_INT, &a, 1, MPI_INT, 0, MPI_COMM_WORLD);
    int res[100];

    int b;
    if (a % 2 == 0)
    {
        b = 1;
    }
    else
    {
        b = 0;
    }
    MPI_Gather(&b, 1, MPI_INT, res, 1, MPI_INT, 0, MPI_COMM_WORLD);

    if (rank == 0)
    {
        int odd = 0;
        int even = 0;
        printf("Resultant array : ");
        fflush(stdout);
        for (int i = 0; i < size; i++)
        {
            if (arr[i] % 2 == 0)
            {
                even++;
            }
            else
            {
                odd++;
            }
            printf("%d  ", res[i]);
        }

        printf("\nEven count : %d\n", even);
        fflush(stdout);
        printf("Odd count : %d\n", odd);
        fflush(stdout);
    }

    MPI_Finalize();

    return 0;
}
