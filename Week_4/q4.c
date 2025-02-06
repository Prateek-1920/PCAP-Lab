#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>

int main(int argc, char** argv) {
    int rank, size;
    char input_word[100]; 
    int N; 
    char output_word[400]; 
    char local_output[100]; 

    MPI_Init(&argc, &argv);
    
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0) {
        printf("Enter a word: ");
        scanf("%s", input_word);
        N = strlen(input_word);
    }

    MPI_Bcast(&N, 1, MPI_INT, 0, MPI_COMM_WORLD);
    
    MPI_Bcast(input_word, 100, MPI_CHAR, 0, MPI_COMM_WORLD);

    if (rank < N) {
        int count = rank + 1; 
        for (int i = 0; i < count; i++) {
            local_output[i] = input_word[rank];
        }
        local_output[count] = '\0'; 
    } else {
        local_output[0] = '\0'; 
    }

    MPI_Gather(local_output, 100, MPI_CHAR, output_word, 100, MPI_CHAR, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("Output: ");
        for (int i = 0; i < N; i++) {
            printf("%s", output_word + i * 100); 
        }
        printf("\n");
    }

    MPI_Finalize();
    return 0;
}