#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[])
{
    int rank, size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int m;
    int c;

    if (rank == 0)
    {
        printf("Enter m : ");
        fflush(stdout);
        scanf("%d", &m);
    }

    MPI_Bcast(&m, 1, MPI_INT, 0, MPI_COMM_WORLD);

    int n = size;
    int arr[n * m];
    int processarr[m];

    if (rank == 0)
    {
        printf("Enter %d elements: ", n * m);
        fflush(stdout);
        for (int i = 0; i < n * m; i++)
        {
            scanf("%d", &arr[i]);
        }
    }

    MPI_Scatter(arr, m, MPI_INT, processarr, m, MPI_INT, 0, MPI_COMM_WORLD);

    double avg = 0;
    for (int i = 0; i < m; i++)
    {
        avg += processarr[i];
    }
    avg = avg / m;

    printf("Process %d calculated avg %f\n", rank, avg);

    double avgarr[n];
    MPI_Gather(&avg, 1, MPI_DOUBLE, avgarr, 1, MPI_DOUBLE, 0, MPI_COMM_WORLD);


    double totalavg = 0;

    if (rank == 0)
    {
        for (int i = 0; i < n; i++)
        {
            totalavg += avgarr[i];
        }
        totalavg = totalavg / n;
        printf("Total average in root is %f\n", totalavg);
    }

    MPI_Finalize();
    return 0;
}