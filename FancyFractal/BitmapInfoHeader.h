//
//  BitmapInfoHeader.h
//  Lecture_30
//
//  Created by Daniel Dytert on 11.08.17.
//  Copyright © 2015 John Purcell. All rights reserved.
//

#ifndef BitmapInfoHeader_h
#define BitmapInfoHeader_h

#pragma pack(2)

namespace danlointeractive {

struct BitmapInfoHeader {
    int32_t headerSize{40};
    int32_t width{0};
    int32_t height{0};
    int16_t planes{1};
    int16_t bitsPerPixel{32};
    int32_t compression{0};
    int32_t dataSize{0};
    int32_t horizontalResolution{2400};
    int32_t verticalResolution{2400};
    int32_t colors{0};
    int32_t importantColors{0};
};
    
}

#endif /* BitmapInfoHeader_h */
