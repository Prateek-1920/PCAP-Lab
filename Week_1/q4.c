#include "mpi.h"
#include<stdio.h>
#include<string.h>

int main(int argc, char * argv[]){
    int rank ,size;
    char s[10];

    MPI_Init(&argc,&argv);

    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD,&size);

    strcpy(s,"HELLO");

    s[rank] += 32;
    printf("Case change at %d : %s\n",rank,s);

    MPI_Finalize();
    return 0;
}