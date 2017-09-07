//
//  Mandelbrot.cpp
//  Lecture_30
//
//  Created by Daniel Dytert on 13.08.17.
//  Copyright © 2015 John Purcell. All rights reserved.
//

#include "Mandelbrot.hpp"
#include <complex>

using namespace std;

int Mandelbrot::getIterations(double x, double y) {
    
    complex<double> z = 0;
    complex<double> c(x, y);
    
    int iterations = 0;
    
    while (iterations < MAX_ITERATIONS) {
        z = z * z + c;
        if (abs(z) > 2) {
            break;
        }
        iterations++;
    }
    
    return iterations;
}

