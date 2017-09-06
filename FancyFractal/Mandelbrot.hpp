//
//  Mandelbrot.hpp
//  Lecture_30
//
//  Created by Daniel Dytert on 13.08.17.
//  Copyright © 2017 DanLo Interactive. All rights reserved.
//

#ifndef Mandelbrot_hpp
#define Mandelbrot_hpp

#include <stdio.h>

class Mandelbrot {
public:
    static const int MAX_ITERATIONS = 1000;
public:
    static int getIterations(double x, double y);
};

#endif /* Mandelbrot_hpp */
