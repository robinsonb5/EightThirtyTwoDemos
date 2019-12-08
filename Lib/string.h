#ifndef _STRING_H
#define _STRING_H

 void *memccpy(void *, const void *, int, size_t);
 void *memchr(const void *, int, size_t);
 void *memrchr(const void *, int, size_t);
 int memcmp(const void *, const void *, size_t);
 void *memcpy(void *, const void *, size_t);
 void *memmove(void *, const void *, size_t);
 void *memset(void *, int, size_t);
 void *memmem(const void *, size_t, const void *, size_t);
 void memswap(void *, void *, size_t);
 void bzero(void *, size_t);
 int strcasecmp(const char *, const char *);
 int strncasecmp(const char *, const char *, size_t);
 char *strcat(char *, const char *);
 char *strchr(const char *, int);
 char *index(const char *, int);
 char *strrchr(const char *, int);
 char *rindex(const char *, int);
 int strcmp(__reg("r2") const char *, __reg("r1") const char *);
 char *strcpy(char *, const char *);
 size_t strcspn(const char *, const char *);
 char *strdup(const char *);
 char *strndup(const char *, size_t);
 char *strerror(int);
 char *strsignal(int);
 size_t strlen(const char *);
 size_t strnlen(const char *, size_t);
 char *strncat(char *, const char *, size_t);
 size_t strlcat(char *, const char *, size_t);
 int strncmp(const char *, const char *, size_t);
 char *strncpy(char *, const char *, size_t);
 size_t strlcpy(char *, const char *, size_t);
 char *strpbrk(const char *, const char *);
 char *strsep(char **, const char *);
 size_t strspn(const char *, const char *);
 char *strstr(const char *, const char *);
 char *strtok(char *, const char *);
 char *strtok_r(char *, const char *, char **);

#endif				/* _STRING_H */
