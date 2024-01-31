#include <assert.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

enum semver_comparison {
  larger,
  equal,
  smaller,
};

typedef struct {
  int major;
  int minor;
  int patch;
} semver;


// typedef struct {
//   char *ptr;
//   size_t len;
// } slice;

void semver_print(const semver sv) {
  printf("(semver) = { .major = %d, .minor = %d, .patch = %d }\n", sv.major, sv.minor, sv.patch);
}

semver semver_from_string(const char* version) {
  assert(version != NULL);
  semver sv = { .major = 0, .minor = 0, .patch = 0 };
  const size_t len = strlen(version);
  // TODO: could also use a sensibly large stack allocated buffer here e.g. temp[64]
  // and just accept that for some inputs the program wount work.
  char* temp = (char*) malloc(sizeof(char) * len);

  // Look for first dot, to figure out the part of the string that is the
  // major part
  int i = 0;
  bool found_dot = false;
  while (version[i] != '\0') {
    if (version[i] == '.') {
      found_dot = true;
      break;
    }
    i++;
  }
  memcpy(temp, version, i);
  temp[i] = '\0'; // Needed for atoi()
  sv.major = atoi(temp);
  if (!found_dot) goto stop;

  found_dot = false;
  i++; // Advance beyond the '.'
  int j = i;
  while (version[j] != '\0') {
    if (version[j] == '.') {
      found_dot = true;
      break;
    }
    j++;
  }

  memcpy(temp, version + i, j - i);
  temp[j - i] = '\0';
  sv.minor = atoi(temp);
  if (!found_dot) goto stop;
  if (j == len) goto stop;
  j++; // Advance beyond the '.'

  memcpy(temp, version + j, len - j);
  temp[len -j] = '\0';
  sv.patch = atoi(temp);

  stop:
  free(temp);
  return sv;
}

enum semver_comparison compare_semver(const semver sv1, const semver sv2) {
  if (sv1.major < sv2.major) return smaller;
  if (sv1.major > sv2.major) return larger;

  if (sv1.minor < sv2.minor) return smaller;
  if (sv1.minor > sv2.minor) return larger;

  if (sv1.patch < sv2.patch) return smaller;
  if (sv1.patch > sv2.patch) return larger;

  return equal;
}

// void test() {
//   {
//     const semver sv = semver_from_string("");
//     assert(sv.major == 0);
//     assert(sv.minor == 0);
//     assert(sv.patch == 0);
//   }
//   {
//     const semver sv = semver_from_string("     ");
//     assert(sv.major == 0);
//     assert(sv.minor == 0);
//     assert(sv.patch == 0);
//   }
//   {
//     const semver sv = semver_from_string("1");
//     assert(sv.major == 1);
//     assert(sv.minor == 0);
//     assert(sv.patch == 0);
//   }
//   {
//     const semver sv = semver_from_string("0.1");
//     assert(sv.major == 0);
//     assert(sv.minor == 1);
//     assert(sv.patch == 0);
//   }
//   {
//     const semver sv = semver_from_string("0.0.1");
//     assert(sv.major == 0);
//     assert(sv.minor == 0);
//     assert(sv.patch == 1);
//   }
//   {
//     const semver sv = semver_from_string("10.11.12");
//     assert(sv.major == 10);
//     assert(sv.minor == 11);
//     assert(sv.patch == 12);
//   }
//   {
//     const semver sv = semver_from_string("13.1.9");
//     assert(sv.major == 13);
//     assert(sv.minor == 1);
//     assert(sv.patch == 9);
//   }
// }

int main(int argc, char **argv) {

  // test();
  if (isatty(fileno(stdin))) {
    fprintf(stderr, "ERROR: stdin is a tty. Input must be piped into the program.\n");
    return 2;
  }

  semver largest_sv = (semver) { .major = 0, .minor = 0, .patch = 0 };

  // Iterate over each line from stdin
  char *line = NULL;
  size_t len = 0;
  ssize_t read;
  while ((read = getline(&line, &len, stdin)) != -1) {
    const semver sv = semver_from_string(line);
    const enum semver_comparison cmp = compare_semver(sv, largest_sv);
    if (cmp == larger) {
      largest_sv = sv;
    }
  }

  // Print result
  fprintf(stdout, "%d.%d.%d\n", largest_sv.major, largest_sv.minor, largest_sv.patch);
  return 0;
}
