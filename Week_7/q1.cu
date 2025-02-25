#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__device__ int compareStrings(const char* str1, const char* str2, int len) {
    for (int i = 0; i < len; i++) {
        if (str1[i] != str2[i]) {
            return 0; 
        }
    }
    return 1; 
}

__global__ void countWordOccurrences(char **d_words, int numWords, char *d_target, int targetLen, int *d_count) {
    int idx = threadIdx.x + blockIdx.x * blockDim.x;

    if (idx < numWords) {
        if (compareStrings(d_words[idx], d_target, targetLen)) {
            atomicAdd(d_count, 1); 
        }
    }
}

int main() {
    char sequence[1024];
    printf("Enter a sequence of words (separated by spaces): ");
    fgets(sequence, sizeof(sequence), stdin);

    char targetWord[100];
    printf("Enter the word to count: ");
    fgets(targetWord, sizeof(targetWord), stdin);

    sequence[strcspn(sequence, "\n")] = '\0';
    targetWord[strcspn(targetWord, "\n")] = '\0';

    char *words[100];
    int numWords = 0;

    char *word = strtok(sequence, " ");
    while (word != NULL) {
        words[numWords++] = word;
        word = strtok(NULL, " ");
    }

    char **d_words;
    char *d_target;
    int *d_count;
    int targetLen = strlen(targetWord);

    cudaMalloc((void**)&d_words, numWords * sizeof(char*));
    cudaMalloc((void**)&d_target, targetLen * sizeof(char));
    cudaMalloc((void**)&d_count, sizeof(int));

    cudaMemcpy(d_target, targetWord, targetLen * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemset(d_count, 0, sizeof(int));

    char **d_words_data;
    cudaMalloc((void**)&d_words_data, numWords * sizeof(char*));

    for (int i = 0; i < numWords; i++) {
        char *d_word;
        cudaMalloc((void**)&d_word, strlen(words[i]) + 1);
        cudaMemcpy(d_word, words[i], strlen(words[i]) + 1, cudaMemcpyHostToDevice);
        cudaMemcpy(&d_words_data[i], &d_word, sizeof(char*), cudaMemcpyHostToDevice);
    }
    
    cudaMemcpy(d_words, d_words_data, numWords * sizeof(char*), cudaMemcpyHostToDevice);

    int blockSize = 256;
    int numBlocks = (numWords + blockSize - 1) / blockSize;

    countWordOccurrences<<<numBlocks, blockSize>>>(d_words, numWords, d_target, targetLen, d_count);

    int h_count = 0;
    cudaMemcpy(&h_count, d_count, sizeof(int), cudaMemcpyDeviceToHost);

    printf("The word '%s' appears %d times in the sequence.\n", targetWord, h_count);

    cudaFree(d_words);
    cudaFree(d_target);
    cudaFree(d_count);
    cudaFree(d_words_data);

    return 0;
}
