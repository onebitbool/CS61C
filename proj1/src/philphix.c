/*
 * Include the provided hash table library.
 */
#include "hashtable.h"

/*
 * Include the header file.
 */
#include "philphix.h"

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Character utility routines.
 */
#include <ctype.h>

/*
 * String utility routines.
 */
#include <string.h>

/*
 * This hash table stores the dictionary.
 */
HashTable *dictionary;

/*
 * The MAIN routine.  You can safely print debugging information
 * to standard error (stderr) as shown and it will be ignored in 
 * the grading process.
 */
#ifndef _PHILPHIX_UNITTEST
int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "Specify a dictionary\n");
    return 1;
  }
  /*
   * Allocate a hash table to store the dictionary.
   */
  fprintf(stderr, "Creating hashtable\n");
  dictionary = createHashTable(0x61C, &stringHash, &stringEquals);

  fprintf(stderr, "Loading dictionary %s\n", argv[1]);
  readDictionary(argv[1]);
  fprintf(stderr, "Dictionary loaded\n");

  fprintf(stderr, "Processing stdin\n");
  processInput();

  /*
   * The MAIN function in C should always return 0 as a way of telling
   * whatever program invoked this that everything went OK.
   */
  return 0;
}
#endif /* _PHILPHIX_UNITTEST */

/* Task 3 */
void readDictionary(char *dictName) {
  FILE *fp;
  int size = 60;
  char *word = (char *)malloc(size * sizeof(char));
  char *data[2];
  int tmp;
  int startRead = 0;
  int readNum = 0; // nth data from current line, it only is 0/1 normally.
  int pos = 0;
  fp = fopen(dictName, "r");
  if (fp == NULL) {
    fprintf(stderr, "cannot open the file");
    exit(61);
  }
  while(1) {
    tmp = getc(fp);
    if (tmp == ' ' || tmp == '\t' || tmp == '\n' || tmp == EOF) {
      if (startRead == 1) {
        word[pos] = '\0';
        if (readNum < 2) {
          data[readNum] = (char *)malloc((pos + 1) * sizeof(char));
          memcpy(data[readNum], word, pos + 1);
          if (readNum == 1) {
            insertData(dictionary, data[0], data[1]);
          }
        } else {
          fprintf(stderr, "more than 2 words in some line");
        }
        startRead = 0;
        pos = 0;
        readNum++;
      }
      if (tmp == '\n') {
        readNum = 0;
      }
      if (tmp == EOF) {
        break;
      }
    } else {
      if (size <= pos + 2) {
        word = (char *)realloc(word, size * 2);
        size *= 2;
      }
      startRead = 1;
      word[pos++] = tmp;
    }
  }
  free(word);
  fclose(fp);
  return;
}

/**
 * convert string to lowcase
**/
char *str2lower(char *str) {
  char *p = str;
  while(*p != '\0') {
    *p = tolower(*p);
    p++;
  }
  return str;
}

/* Task 4 */
void processInput() {
  int size = 60;
  char *word = (char *)malloc(size * sizeof(char));
  char *dupWord;
  char *replaceStr;
  int reading = 0;
  int tmp;
  int pos = 0;
  while(1) {
    tmp = getchar();
    if (isalnum(tmp)) {
      if (size <= pos + 2) {
        word = (char *)realloc(word, size * 2);
        size *= 2;
      }
      reading = 1;
      word[pos++] = tmp;
    } else {
      if (reading == 1) {
        word[pos] = '\0';
        dupWord = malloc((pos + 1) * sizeof(char));
        if (dupWord == NULL) {
          fprintf(stderr, "malloc error\n");
        }
        strcpy(dupWord, word);
        replaceStr = findData(dictionary, word);
        if (replaceStr == NULL)
          replaceStr = findData(dictionary, str2lower(word + 1) - 1);
        if (replaceStr == NULL)
          replaceStr = findData(dictionary, str2lower(word));
        if (replaceStr == NULL)
          replaceStr = dupWord;
        printf("%s", replaceStr);
        free(dupWord);
      }
      if (tmp == EOF) {
        break;
      }
      putchar(tmp);
      reading = 0;
      pos = 0;
    }
  }
  free(word);
  return;
}
