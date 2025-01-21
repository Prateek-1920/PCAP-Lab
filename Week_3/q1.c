#include <mpi.h>
#include <stdio.h>

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

    int N, A[10], B[10], c, i;

    if (rank == 0)
    {
        N = size;
        fprintf(stdout, "Enter %d values : \n", N);
        fflush(stdout);
        for (i = 0; i < N; i++)
        {
            scanf("%d", &A[i]);
        }
    }

    MPI_Scatter(A, 1, MPI_INT, &c, 1, MPI_INT, 0, MPI_COMM_WORLD);
    fprintf(stdout, "Recieved %d in process %d \n", c, rank);
    fflush(stdout);

    c = fact(c);

    MPI_Gather(&c, 1, MPI_INT, B, 1, MPI_INT, 0, MPI_COMM_WORLD);

    if (rank == 0)
    {
        fprintf(stdout, "Result in root\n");
        fflush(stdout);
        int ans = 0;
        for (i = 0; i < N; i++)
        {
            ans += B[i];
        }
        printf("Sum = %d \n",ans);
        fflush(stdout);
    }

    MPI_Finalize();

    return 0;
}