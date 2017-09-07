//
//  ZoomList.cpp
//  Lecture_30
//
//  Created by Daniel Dytert on 16.08.17.
//  Copyright © 2015 John Purcell. All rights reserved.
//

#include "ZoomList.hpp"
#include <iostream>

using namespace std;

namespace danlointeractive {
    
    ZoomList::ZoomList(int width, int height): m_width(width), m_height(height) {
        
    }
    
    void ZoomList::add(const Zoom& zoom) {
        
        zooms.push_back(zoom);
        
        m_xCenter += (zoom.x - m_width / 2) * m_scale;
        m_yCenter += -(zoom.y - m_height / 2) * m_scale;
        m_scale *= zoom.scale;
        
        cout << m_xCenter << ", " << m_yCenter << ", " << m_scale << endl;
        
    }
    
    pair<double, double> ZoomList::doZoom(int x, int y) {
        
        double xFractal = (x - m_width / 2) * m_scale + m_xCenter;
        double yFractal = (y - m_height / 2) * m_scale + m_yCenter;
        
        return pair<double, double>(xFractal, yFractal);
    }
    
}
