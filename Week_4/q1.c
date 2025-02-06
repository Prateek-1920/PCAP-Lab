#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

unsigned long long factorial(int n) {
    if (n == 0 || n == 1) return 1;
    unsigned long long result = 1;
    for (int i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}

int main(int argc, char** argv) {
    int rank, size, N;
    unsigned long long local_factorial, global_sum;

    MPI_Init(&argc, &argv);
    
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0) {
        printf("Enter the value of N: ");
        scanf("%d", &N);
        if (N < 1) {
            fprintf(stderr, "N must be greater than 0.\n");
            MPI_Abort(MPI_COMM_WORLD, EXIT_FAILURE);
        }
    }

    MPI_Bcast(&N, 1, MPI_INT, 0, MPI_COMM_WORLD);

    int local_n = rank + 1; 
    if (local_n > N) {
        local_factorial = 0; 
    } else {
        local_factorial = factorial(local_n);
    }

    MPI_Scan(&local_factorial, &global_sum, 1, MPI_UNSIGNED_LONG_LONG, MPI_SUM, MPI_COMM_WORLD);

    if (rank == size - 1) {
        printf("The sum of factorials from 1! to %d! is: %llu\n", N, global_sum);
    }

    MPI_Finalize();
    return 0;
}