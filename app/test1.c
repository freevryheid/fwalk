#include <cwalk.h>
#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
  const char *basename;
  size_t length;
  char buffer[FILENAME_MAX];


	cwk_path_set_style(CWK_STYLE_UNIX);
  cwk_path_get_basename("/////////////////////////////", &basename, &length);
  printf("The basename is: '%.*s'", length, basename);

  cwk_path_get_basename("/", &basename, &length);
  printf("The basename is: '%.*s'", length, basename);

  cwk_path_get_basename("..", &basename, &length);
  printf("The basename is: '%.*s'", length, basename);

  cwk_path_get_basename("filename", &basename, &length);
  printf("The basename is: '%.*s'", length, basename);

  cwk_path_get_basename(".", &basename, &length);
  printf("The basename is: '%.*s'", length, basename);
  printf("length: %d", length);

  cwk_path_change_basename("/test.txt", "another.txt", buffer, sizeof(buffer));
  printf("The new path: '%s'", buffer);

  return EXIT_SUCCESS;
}
