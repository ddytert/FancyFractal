//
//  Bitmap.cpp
//  Lecture_30
//
//  Created by Daniel Dytert on 12.08.17.
//  Copyright © 2015 John Purcell. All rights reserved.
//

#include <fstream>
#include <iostream>
#include "Bitmap.hpp"
#include "BitmapInfoHeader.h"
#include "BitmapFileHeader.h"


using namespace danlointeractive;


Bitmap::Bitmap(int width, int height, uint8_t *bitmap): m_width(width), m_height(height), m_pPixels(bitmap) {
    
}

int Bitmap::bitmapSize() const {
    return m_width * m_height * 4;
}

void Bitmap::setPixel(int x, int y, uint8_t red, uint8_t green, uint8_t blue) {
    
    int offset = (y * m_width * 4) + (x * 4);
        
    m_pPixels[offset + 0] = red;
    m_pPixels[offset + 1] = green;
    m_pPixels[offset + 2] = blue;
    m_pPixels[offset + 3] = 255;    // alpha
}


bool Bitmap::write(string filename) {
    
    BitmapFileHeader fileHeader;
    BitmapInfoHeader infoHeader;
    
    fileHeader.fileSize = sizeof(BitmapFileHeader) + sizeof(BitmapInfoHeader) + bitmapSize();
    fileHeader.dataOffset = sizeof(BitmapFileHeader) + sizeof(BitmapInfoHeader);
    
    infoHeader.width = m_width;
    infoHeader.height = m_height;
    
    ofstream file;
    file.open(filename, ios::out | ios::binary);
    
    if (!file) {
        return false;
    }
    
    file.write((char *)&fileHeader, sizeof(fileHeader));
    file.write((char *)&infoHeader , sizeof(infoHeader));
    file.write((char *)m_pPixels, bitmapSize());

    file.close();
    
    if (!file) {
        return false;
    }
    
    return true;
}

void Bitmap::fillWithColor(uint8_t red, uint8_t green, uint8_t blue) {
    
    int bmpSize = bitmapSize();
    
    for (int i = 0; i < bmpSize; i += 4) {
        
        m_pPixels[i + 0] = red;
        m_pPixels[i + 1] = green;
        m_pPixels[i + 2] = blue;
        m_pPixels[i + 3] = 255;
    }
}



Bitmap::~Bitmap() {
    
}

