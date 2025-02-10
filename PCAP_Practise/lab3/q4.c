#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <mpi.h>

int main(int argc, char *argv[])
{
    int rank, size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    char s1[10];
    char s2[10];
    int n;

    if (rank == 0)
    {
        printf("Enter string 1 : ");
        fflush(stdout);
        scanf("%s", s1);

        printf("Enter string 2 : ");
        fflush(stdout);
        scanf("%s", s2);

        if (strlen(s1) != strlen(s2))
        {
            printf("String lengths should be same\n");
            fflush(stdout);
            MPI_Abort(MPI_COMM_WORLD, 1);
        }
        if (strlen(s1) % size != 0)
        {
            printf("String lengths should be divisible by num of processes\n");
            fflush(stdout);
            MPI_Abort(MPI_COMM_WORLD, 1);
        }

        n = strlen(s1) / size;
    }

    MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);

    char locals1[n], locals2[n];

    MPI_Scatter(s1, n, MPI_CHAR, locals1, n, MPI_CHAR, 0, MPI_COMM_WORLD);

    MPI_Scatter(s2, n, MPI_CHAR, locals2, n, MPI_CHAR, 0, MPI_COMM_WORLD);

    char localres[2 * n + 1];
    for (int i = 0; i < n; i++)
    {
        localres[2 * i] = locals1[i];
        localres[2 * i + 1] = locals2[i];
    }
    localres[2 * n] = '\0';

    char final[20];

    MPI_Gather(localres, 2 * n, MPI_CHAR, final, 2 * n, MPI_CHAR, 0, MPI_COMM_WORLD);

    if (rank == 0)
    {
        printf("Result string is : %s\n", final);
        fflush(stdout);
    }
    MPI_Finalize();
    return 0;
}