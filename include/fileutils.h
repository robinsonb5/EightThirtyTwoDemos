#ifndef FILEUTILS_H
#define FILEUTILS_H

char *LoadFile(const char *filename);


struct wildcard_pattern
{
	int casesensitive;
	const char *pattern;
};

int MatchWildcard(const char *filename,int maxlen,void *userdata);
char *FileSelector(struct wildcard_pattern *pattern);



#endif

