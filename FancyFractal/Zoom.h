//
//  Zoom.h
//  Lecture_30
//
//  Created by Daniel Dytert on 16.08.17.
//  Copyright © 2017 Daniel Dytert. All rights reserved.
//

#ifndef Zoom_h
#define Zoom_h

namespace danlointeractive {
    
    struct Zoom {
        
        int x{0};
        int y{0};
        double scale{0.0};
        
        Zoom(int x, int y, double scale): x(x), y(y), scale(scale) {};
        
    };
}


#endif /* Zoom_h */
