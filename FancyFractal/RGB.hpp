//
//  RGB.hpp
//  Lecture_30
//
//  Created by Daniel Dytert on 19.08.17.
//  Copyright © 2017 DanLo Interactive. All rights reserved.
//

#ifndef RGB_hpp
#define RGB_hpp

#include <stdio.h>

namespace danlointeractive {
    
    struct RGB {

        double red{0};
        double green{0};
        double blue{0};
        
        RGB(double red, double green, double blue): red(red), green(green), blue(blue) {};
        RGB(): red(0), green(0), blue(0) {}
        
    };
    
    RGB operator-(const RGB& first, const RGB& second);
}

#endif /* RGB_hpp */
