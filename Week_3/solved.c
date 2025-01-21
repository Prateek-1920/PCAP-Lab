#include <stdio.h>
#include "mpi.h"

int main(int argc, char *argv[])
{
    int rank, size;
    int N, A[10], B[10], c, i;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

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

        c = c * c;

        MPI_Gather(&c, 1, MPI_INT, B, 1, MPI_INT, 0, MPI_COMM_WORLD);
        if (rank == 0)
        {
            fprintf(stdout, "Result in root\n");
            fflush(stdout);
            for (i = 0; i < N; i++)
            {
                printf("%d \t", B[i]);
            }
            fflush(stdout);
        }
    

    MPI_Finalize();

    return 0;
}
