#include <stdio.h>

#define MAX_BUFFER 1024

typedef struct {
    int id;
    char* name;
} User;

/**
 * Multi-line comment to test documentation highlighting
 */
void process_user(User *u) {
    if (u->id > 0) {
        printf("User: %s (ID: %d)\n", u->name, u->id);
    } else {
        // Test error or edge case highlighting
        fprintf(stderr, "Invalid ID\n");
    }
}

int main(int argc, char **argv) {
    User me = { .id = 1, .name = "Developer" };
    process_user(&me);
    return 0;
}
