#include "foo.h"
#include <stdio.h>
#include <ncurses.h>

int main(void) {
  printf("using foo...");
  foo();

  printf("using ncurses...");
  initscr();
  printw("Press a key...");
  refresh();
  getch();
  endwin();

  return 0;
}
