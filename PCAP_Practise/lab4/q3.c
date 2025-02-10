#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[])
{
    int size, rank;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int mat[4][4];
    if (rank == 0)
    {
        printf("Enter matrix : \n");
        fflush(stdout);
        for (int i = 0; i < 4; i++)
        {
            for (int j = 0; j < 4; j++)
            {
                scanf("%d", &mat[i][j]);
            }
        }

        printf("Input matrix : \n");
        fflush(stdout);
        for (int i = 0; i < 4; i++)
        {
            for (int j = 0; j < 4; j++)
            {
                printf("%d  ", mat[i][j]);
            }
            printf("\n");
            fflush(stdout);
        }
    }

    int row[4];
    int rowsum[4];
    int final[4][4];

    MPI_Scatter(mat, 4, MPI_INT, row, 4, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Scan(row, rowsum, 4, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
    MPI_Gather(rowsum, 4, MPI_INT, final, 4, MPI_INT, 0, MPI_COMM_WORLD);

    if (rank == 0)
    {
        printf("Output matrix : \n");
        fflush(stdout);
        for (int i = 0; i < 4; i++)
        {
            for (int j = 0; j < 4; j++)
            {
                printf("%d  ", final[i][j]);
            }
            printf("\n");
            fflush(stdout);
        }
    }

    MPI_Finalize();

    return 0;
}
