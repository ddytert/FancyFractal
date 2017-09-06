//
//  FractalCreator.hpp
//  Lecture_30
//
//  Created by Daniel Dytert on 18.08.17.
//  Copyright © 2017 DanLo Interactive. All rights reserved.
//

#ifndef FractalCreator_hpp
#define FractalCreator_hpp

#include <stdio.h>
#include <string>
#include "Bitmap.hpp"
#include "ZoomList.hpp"
#include "RGB.hpp"


using namespace std;

namespace danlointeractive {

    class FractalCreator {
        
    private:
        int m_width{0};
        int m_height{0};
        Bitmap m_bitmap;
        ZoomList m_zoomList;
        unique_ptr<int[]> m_histogram{nullptr};
        unique_ptr<int[]> m_fractal{nullptr};
        
        vector<int> m_ranges;
        vector<RGB> m_colors;
        vector<int >m_rangeTotals;
        bool m_bGotFirstRange{false};
        
        void calculateIterations();
        void calculateRangeTotals();
        void drawFractal();
        void writeBitmap(string name);
        int getRange(int iterations) const;
        
    public:
        FractalCreator(int width, int height);
        FractalCreator(int width, int height, uint8_t *bitmap); // Constructor for FCWrapper
        ~FractalCreator();


        void addRange(double rangeEnd, const RGB& rgb);
        void addZoom(const Zoom& zoom);
        void run(string name);

    };
    
    
    
    
    
}

#endif /* FractalCreator_hpp */
