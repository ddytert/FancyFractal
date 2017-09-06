//
//  BitmapFileHeader.h
//  Lecture_30
//
//  Created by Daniel Dytert on 10.08.17.
//  Copyright © 2017 DanLo Interactive. All rights reserved.
//

#ifndef BitmapFileHeader_h
#define BitmapFileHeader_h

#pragma pack(2)

namespace danlointeractive {
    
    struct BitmapFileHeader {
        char header[2]{'B', 'M'};
        int32_t fileSize;
        int32_t reserved{0};
        int32_t dataOffset;
    };
    
}

#endif /* BitmapFileHeader_h */
