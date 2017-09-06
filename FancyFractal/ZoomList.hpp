//
//  ZoomList.hpp
//  Lecture_30
//
//  Created by Daniel Dytert on 16.08.17.
//  Copyright © 2017 DanLo Interactive. All rights reserved.
//

#ifndef ZoomList_hpp
#define ZoomList_hpp

#include <stdio.h>
#include <vector>
#include "Zoom.h"

using namespace std;

namespace danlointeractive {
    
    class ZoomList {
        
    private:
        double m_xCenter{0.0};
        double m_yCenter{0.0};
        double m_scale{1.0};
        
        int m_width{0};
        int m_height{0};
        vector<Zoom> zooms;
        
    public:
        ZoomList(int width, int height);
        void add(const Zoom& zoom);
        pair<double, double> doZoom(int x, int y);
    };
}

#endif /* ZoomList_hpp */
