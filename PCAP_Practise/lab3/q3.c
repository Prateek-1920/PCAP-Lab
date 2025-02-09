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
    MPI_Status status;

    char str[100];
    int n;

    if (rank == 0)
    {
        printf("Enter string: ");
        fflush(stdout);
        scanf("%s", str);
        int len = strlen(str);
        if (len % size != 0)
        {
            printf("Enter size divisible by processess");
            fflush(stdout);
            MPI_Abort(MPI_COMM_WORLD, 1); // Abort execution if input is invalid
        }
        n = len / size;
    }

    MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);
    char word[n];
    MPI_Scatter(str, n, MPI_CHAR, word, n, MPI_CHAR, 0, MPI_COMM_WORLD);

    int cons = 0;

    for (int i = 0; i < n; i++)
    {
        char ch = tolower(word[i]);
        if (ch != 'a' && ch != 'e' && ch != 'i' && ch != 'o' && ch != 'u')
        {
            cons++;
        }
    }

    int consarr[10];
    MPI_Gather(&cons, 1, MPI_INT, consarr, 1, MPI_INT, 0, MPI_COMM_WORLD);

    if (rank == 0)
    {
        int tot = 0;
        printf("Number of consonants by each process : \n");
        fflush(stdout);
        for (int i = 0; i < size; i++)
        {
            printf("Process %d consonants %d\n", i, consarr[i]);
            tot += consarr[i];
        }

        printf("Final consonants count : %d\n", tot);
    }

    MPI_Finalize();
    return 0;
}