//
//  Bitmap.hpp
//  Lecture_30
//
//  Created by Daniel Dytert on 12.08.17.
//  Copyright © 2015 John Purcell. All rights reserved.
//

#ifndef Bitmap_hpp
#define Bitmap_hpp

#include <stdio.h>
#include <string>

using namespace std;

namespace danlointeractive {
    
    class Bitmap {
    private:
        int m_width{0};
        int m_height{0};
        uint8_t* m_pPixels{nullptr};
        
    public:
        Bitmap(int width, int height);
        Bitmap(int width, int height, uint8_t *bitmap);
        int bitmapSize() const;
        void setPixel(int x, int y, uint8_t red, uint8_t green, uint8_t blue);
        bool write(string filename);
        void fillWithColor(uint8_t red, uint8_t green, uint8_t blue);
        virtual ~Bitmap();
    };
}

#endif /* Bitmap_hpp */
