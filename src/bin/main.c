#include "foo.h"
#include <stdio.h>
#include <mpi.h>
#include <ncurses.h>

int main(int argc, char **argv) {

  {
    printf("initializing MPI...\n");
    MPI_Init(&argc, &argv);

    int rank;
    int size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    printf("#%d/%d finalizaing MPI...\n", rank, size-1);

    MPI_Finalize();
  }

  // foo is a local project library
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
