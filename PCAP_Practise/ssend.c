#include <stdio.h>
#include <string.h>
#include <mpi.h>

int main(int argc, char *argv[])
{
    int size, rank;
    char str[100];
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    MPI_Status status;

    if (rank == 0)
    {
        printf("Enter word: ");
        fflush(stdout);
        scanf("%s", str);
        printf("Process 0 sent %s \n", str);

        int len = strlen(str);

        MPI_Ssend(str, len, MPI_CHAR, 1, 1, MPI_COMM_WORLD);
        MPI_Recv(str, len, MPI_CHAR, 1, 1, MPI_COMM_WORLD, &status);
        printf("Process 0 recieved %s \n", str);
        fflush(stdout);
    }
    else if (rank == 1)
    {
        char localstr[100];
        MPI_Recv(localstr, 100, MPI_CHAR, 0, 1, MPI_COMM_WORLD, &status);
        printf("Process 1 recieved %s \n", localstr);
        for (int i = 0; i < strlen(localstr); i++)
        {
            localstr[i] = localstr[i] ^ 32;
        }
        MPI_Ssend(localstr, strlen(localstr), MPI_CHAR, 0, 1, MPI_COMM_WORLD);
        printf("Process 1 sent %s \n", localstr);
    }

    MPI_Finalize();
    return 0;
}
