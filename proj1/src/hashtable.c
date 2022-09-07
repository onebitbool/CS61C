#include "hashtable.h"

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * String utility routines.
 */
#include <string.h>

/*
 * This creates a new hash table of the specified size and with
 * the given hash function and comparison function.
 */
HashTable *createHashTable(int size, unsigned int (*hashFunction)(void *),
                           int (*equalFunction)(void *, void *)) {
  int i = 0;
  HashTable *newTable = malloc(sizeof(HashTable));
  if (NULL == newTable) {
    fprintf(stderr, "malloc failed \n");
    exit(1);
  }
  newTable->size = size;
  newTable->buckets = malloc(sizeof(struct HashBucketEntry *) * size);
  if (NULL == newTable->buckets) {
    fprintf(stderr, "malloc failed \n");
    exit(1);
  }
  for (i = 0; i < size; i++) {
    newTable->buckets[i] = NULL;
  }
  newTable->hashFunction = hashFunction;
  newTable->equalFunction = equalFunction;
  return newTable;
}

/* Task 1.2 */
void insertData(HashTable *table, void *key, void *data) {
  int keyNum = table->hashFunction(key) % table->size;
  struct HashBucketEntry *newEntry = malloc(sizeof(struct HashBucketEntry));
  if (NULL == newEntry) {
    fprintf(stderr, "malloc failed \n");
    exit(1);
  }
  newEntry->key = key;
  newEntry->data = data;
  newEntry->next = NULL;
  if (NULL == table->buckets[keyNum]) {
    table->buckets[keyNum] = newEntry;
  } else {
    struct HashBucketEntry *pos = table->buckets[keyNum];
    while (pos->next != NULL) {
      pos = pos->next;
    }
    pos->next = newEntry;
    return;
  }
}

/* Task 1.3 */
void *findData(HashTable *table, void *key) {
  int keyNum = table->hashFunction(key) % table->size;
  struct HashBucketEntry *pos = table->buckets[keyNum];
  int isEquals;
  while (pos != NULL) {
    isEquals = table->equalFunction(pos->key, key);
    if (isEquals) {
      return pos->data;
    }
  }
  return NULL;
}

/* Task 2.1 */
unsigned int stringHash(void *s) {
  unsigned int hashCode = 0;
  char *str = (char *)s;
  for (int i = 0; i < strlen(str); i++) {
    hashCode = hashCode * 31 + (unsigned int)str[i];
  }
  return hashCode;
}

/* Task 2.2 */
int stringEquals(void *s1, void *s2) {
  char *str1 = (char *)s1;
  char *str2 = (char *)s2;
  if (strlen(str1) != strlen(str2)) {
    return 0;
  }
  
  while (*str1 != '\0' && *str2 != '\0') {
    if (*str1 != *str2) {
      return 0;
    }
    str1++;
    str2++;
  }
  return 1;
}