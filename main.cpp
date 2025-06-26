#include "third_party/dbg.h"
#include <iostream>

int main(int argc, char **argv) {
    dbg(argc);
    dbg(argv);

    std::cout << "Hello, World!" << std::endl;
    dbg(__FILE__);

    return 0;
}
