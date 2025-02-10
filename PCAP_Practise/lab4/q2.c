#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[])
{
    int rank, size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int ele;
    int count = 0;

    int mat[3][3];
    if (rank == 0)
    {
        printf("Enter elements: ");
        fflush(stdout);
        for (int i = 0; i < 3; i++)
        {
            for (int j = 0; j < 3; j++)
            {
                scanf("%d", &mat[i][j]);
            }
        }
        printf("Enter element to be searched : ");
        fflush(stdout);
        scanf("%d", &ele);
    }

    MPI_Bcast(&ele, 1, MPI_INT, 0, MPI_COMM_WORLD);
    int row[3];
    MPI_Scatter(mat, 3, MPI_INT, row, 3, MPI_INT, 0, MPI_COMM_WORLD);
    for (int i = 0; i < 3; i++)
    {
        if (row[i] == ele)
        {
            count++;
        }
    }

    int globalcount;

    MPI_Reduce(&count, &globalcount, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
    if (rank == 0)
    {
        if (globalcount == 0)
        {
            printf("Element not found\n");
            fflush(stdout);
        }
        else
        {
            printf("Element %d found\nOccurences : %d\n", ele, globalcount);
            fflush(stdout);
        }
    }

    MPI_Finalize();

    return 0;
}
