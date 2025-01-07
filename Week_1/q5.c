#include "mpi.h"
#include<stdio.h>


int factorial(int n){
    if(n==1){
        return 1;
    }
    else{
        return n * factorial(n-1);
    }
}

int fib( int n){
    if(n<=1){
        return 1;
    }
    else{
        return fib(n-1) + fib(n-2);
    }
}


int main(int argc, char * argv[]){
    int rank ,size;

    MPI_Init(&argc,&argv);

    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD,&size);

   int n=5;

   if(rank%2==0){
    printf("Rank = %d, factorial = %d\n",rank,factorial(n));
   }
   else{
    printf("Rank = %d , fibionacci = %d\n",rank,fib(n));
   }

    MPI_Finalize();
    return 0;
}