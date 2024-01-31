function __lsx.fish::compile_largest_semver
	set -l program '
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
  while (version[i] != \'\0\') {
    if (version[i] == \'.\') {
      found_dot = true;
      break;
    }
    i++;
  }
  memcpy(temp, version, i);
  temp[i] = \'\0\'; // Needed for atoi()
  sv.major = atoi(temp);
  if (!found_dot) goto stop;

  found_dot = false;
  i++; // Advance beyond the \'.\'
  int j = i;
  while (version[j] != \'\0\') {
    if (version[j] == \'.\') {
      found_dot = true;
      break;
    }
    j++;
  }

  memcpy(temp, version + i, j - i);
  temp[j - i] = \'\0\';
  sv.minor = atoi(temp);
  if (!found_dot) goto stop;
  if (j == len) goto stop;
  j++; // Advance beyond the \'.\'

  memcpy(temp, version + j, len - j);
  temp[len -j] = \'\0\';
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

int main(int argc, char **argv) {
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
'
	set -l program_path $__fish_user_data_dir/lsx/largest-semver.c
	set -l exe $__fish_user_data_dir/lsx/largest-semver
	command mkdir -p (path dirname $program_path)
	test -f $exe; and return 0

	if not test -f $program_path
		echo "$program" > $program_path
	end
	set -l reset (set_color normal)
	set -l green (set_color green)
	if not test -f $exe
		printf "%scompiling %s%s\n" $green (path basename $program_path) $reset
		gcc -O3 -o $exe $program_path
	end
end

function _lsx_install --on-event lsx_install
    # Set universal variables, create bindings, and other initialization logic.
	__lsx.fish::compile_largest_semver
end

function _lsx_update --on-event lsx_update
	# Migrate resources, print warnings, and other update logic.
	__lsx.fish::compile_largest_semver
end

function _lsx_uninstall --on-event lsx_uninstall
	# Erase "private" functions, variables, bindings, and other uninstall logic.
end
