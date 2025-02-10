#include <stdio.h>
#include <math.h>
#include <ctype.h>
#include <mpi.h>

int main(int argc, char *argv[])
{
    int rank, size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int m;
    int n = size;
    int arr[100];

    if (rank == 0)
    {
        printf("Enter value of m: ");
        fflush(stdout);
        scanf("%d", &m);

        printf("Enter values :");
        fflush(stdout);
        for (int i = 0; i < m * n; i++)
        {
            scanf("%d", &arr[i]);
        }
    }

    MPI_Bcast(&m, 1, MPI_INT, 0, MPI_COMM_WORLD);
    int localarr[m];
    MPI_Scatter(arr, m, MPI_INT, localarr, m, MPI_INT, 0, MPI_COMM_WORLD);
    for (int i = 0; i < m; i++)
    {
        localarr[i] = pow(localarr[i], rank + 2);
    }

    int ans[m * n];
    MPI_Gather(localarr, m, MPI_INT, ans, m, MPI_INT, 0, MPI_COMM_WORLD);

    if (rank == 0)
    {
        printf("Final array : ");
        fflush(stdout);
        for (int i = 0; i < m * n; i++)
        {
            printf("%d  ", ans[i]);
        }
    }

    MPI_Finalize();

    return 0;
}
