//
//  RGB.cpp
//  Lecture_30
//
//  Created by Daniel Dytert on 19.08.17.
//  Copyright © 2015 John Purcell. All rights reserved.
//

#include "RGB.hpp"

namespace danlointeractive {
    
    
    RGB operator-(const RGB& first, const RGB& second) {
        
        return RGB(first.red - second.red, first.green - second.green, first.blue - second.blue);
    };
    
}
