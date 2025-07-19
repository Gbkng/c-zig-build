#include "foo.h"
#include <stdio.h>
#include <mpi.h>
#include <ncurses.h>

int main(void) {
  printf("using foo...\n");
  foo();

  printf("using ncurses...\n");
  initscr();
  printw("Press a key...\n");
  refresh();
  getch();
  endwin();

  return 0;
}
