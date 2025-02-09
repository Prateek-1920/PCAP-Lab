#include <stdio.h>
#include <stdbool.h>
#include <math.h>
#include <mpi.h>

bool isprime(int n)
{

    for (int i = 2; i <= sqrt(n); i++)
    {
        if (n % i == 0)
        {
            return false;
        }
    }
    return true;
}

int main(int argc, char *argv[])
{
    int rank, size;
    int arr[100];
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    MPI_Status status;
    int buffer[100];
    MPI_Buffer_attach(buffer, sizeof(buffer));

    if (rank == 0)
    {
        printf("Enter array elements: ");
        fflush(stdout);
        for (int i = 0; i < size; i++)
        {
            scanf("%d", &arr[i]);
        }
        for (int i = 0; i < size; i++)
        {
            MPI_Bsend(&arr[i], 1, MPI_INT, i, 1, MPI_COMM_WORLD);
            printf("Process 0 sent %d \n", arr[i]);
            fflush(stdout);
        }
    }
    else
    {
        int x;
        MPI_Recv(&x, 1, MPI_INT, 0, 1, MPI_COMM_WORLD, &status);
        if (x == 1)
        {
            printf("Process %d recieved %d : NONE\n", rank, x);
        }
        else if (isprime(x))
        {
            printf("Process %d recieved %d : PRIME\n", rank, x);
        }
        else
        {
            printf("Process %d recieved %d :NOT PRIME\n", rank, x);
        }
    }

    MPI_Buffer_detach(&buffer, &size);
    MPI_Finalize();
    return 0;
}
