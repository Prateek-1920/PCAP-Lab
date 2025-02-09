#include <stdio.h>
#include <mpi.h>

int rev(int n)
{
    int num = 0;
    while (n > 0)
    {
        int div = n % 10;
        num = num * 10 + div;
        n = n / 10;
    }
    return num;
}

int main(int argc, char *argv[])
{
    int rank, size;
    int n;
    int arr[100];

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0)
    {
        printf("Enter n: ");
        fflush(stdout);
        scanf("%d", &n);

        printf("Enter elements: ");
        fflush(stdout);
        for (int i = 0; i < n; i++)
        {
            scanf("%d", &arr[i]);
        }
    }

    MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);

    int localnum;
    MPI_Scatter(arr, 1, MPI_INT, &localnum, 1, MPI_INT, 0, MPI_COMM_WORLD);

    int localrev = rev(localnum);

    int ans[100];
    MPI_Gather(&localrev, 1, MPI_INT, ans, 1, MPI_INT, 0, MPI_COMM_WORLD);

    if (rank == 0)
    {
        for (int i = 0; i < n; i++)
        {
            printf("%d   ", ans[i]);
        }
    }

    MPI_Finalize();
    return 0;
}
