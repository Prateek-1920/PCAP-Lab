#include "mpi.h"
#include<stdio.h>


int power(int base, int exp){
    int result = 1;
    for(int i=0;i<exp;i++){
        result *= base;
    }
    return result;
}

int main(int argc,char *argv[]){
    int rank,size;
    int x =4 ;

    int res;

    MPI_Init(&argc,&argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD,&size);

    res = power(x,rank);
    printf("Process %d of %d : %d ^ %d = %d\n",rank,size,x,rank,res);

    MPI_Finalize();

    return 0;
    
}