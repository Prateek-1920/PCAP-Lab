#include <stdio.h>
#include <string.h>
#include <mpi.h>

int main(int argc, char *argv[])
{
    int rank, size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    char str[50];
    int len;

    if (rank == 0)
    {
        printf("Enter string: ");
        fflush(stdout);
        scanf("%s", str);

        len = strlen(str);
        if (size != len)
        {
            printf("String length shoudl be equal to processes");
            MPI_Abort(MPI_COMM_WORLD, 1);
        }
    }

    char c;

    MPI_Bcast(&len, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(str, len, MPI_CHAR, 0, MPI_COMM_WORLD);

    char localstr[100];

    for (int i = 0; i < rank + 1; i++)
    {
        localstr[i] = str[rank];
    }
    localstr[rank + 1] = '\0';

    char ans[100];

    MPI_Gather(localstr, rank + 1, MPI_CHAR, ans, rank + 1, MPI_CHAR, 0, MPI_COMM_WORLD);

    if (rank == 0)
    {
        ans[len * (len + 1) / 2] = '\0';
        printf("Output : %s", ans);
        fflush(stdout);
    }

    MPI_Finalize();
    return 0;
}