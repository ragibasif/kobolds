#pragma once

#include "kobolds.hpp"
#include <cassert>
#include <cctype>
#include <iostream>

// https://stackoverflow.com/questions/4989451/mutex-example-tutorial

// TODO: error handling

static std::mutex kobolds_mutex;

namespace kobolds {

template <typename T> class Vector {

  private:
    T *array;
    size_t size;
    size_t capacity;

  public:
    explicit Vector(size_t size) : size(size) {
        kobolds_mutex.lock();
        if (size == 0) {
            size = 1;
        }
        capacity = size * 2;
        array = new T[size];
        kobolds_mutex.unlock();
    }

    ~Vector(void) {
        kobolds_mutex.lock();
        delete[] array;
        array = nullptr;
        kobolds_mutex.unlock();
    }

    T get(size_t index) {
        assert(index < size);
        return array[index];
    }

    void set(size_t index, T value) {
        assert(index < size);
        kobolds_mutex.lock();
        array[index] = value;
        kobolds_mutex.unlock();
    }

    void dump(void) {
        for (int i = 0; i < size; i++) {
            std::cout << array[i] << " ";
        }
        std::cout << "\n";
    }

    T find(T value) {}
};

} // namespace kobolds
