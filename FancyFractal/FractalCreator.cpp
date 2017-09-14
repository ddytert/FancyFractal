//
//  FractalCreator.cpp
//  Lecture_30
//
//  Created by Daniel Dytert on 18.08.17.
//  Copyright © 2015 John Purcell. All rights reserved.
//

#include "FractalCreator.hpp"
#include "Mandelbrot.hpp"
#include <iostream>
#include <math.h>
#include <assert.h>

using namespace std;


namespace danlointeractive {
    
    void FractalCreator::run(string name) {
        
        calculateIterations();
        calculateRangeTotals();
        drawFractal();
        writeBitmap(name);
    }
    
    void FractalCreator::addRange(double rangeEnd, const RGB& rgb) {
        
        m_ranges.push_back(rangeEnd * Mandelbrot::MAX_ITERATIONS);
        m_colors.push_back(rgb);
        
        if (m_bGotFirstRange) {
            m_rangeTotals.push_back(0);
        }
        m_bGotFirstRange = true;
    }
    
    void FractalCreator::addZoom(const Zoom& zoom) {
        
        m_zoomList.add(zoom);
    }
    
    
     // Constructor for FCWrapper
    
    FractalCreator::FractalCreator(int width, int height, uint8_t *bitmap):
    m_width(width),
    m_height(height),
    m_bitmap(width, height, bitmap),
    m_zoomList(width, height),
    m_histogram(new int[Mandelbrot::MAX_ITERATIONS]{}),
    m_fractal(new int[width * height]),
    m_ranges(),
    m_colors() {
        
        addZoom((Zoom(m_width / 2, m_height / 2, 4.0 / m_width)));
    }
    
    void FractalCreator::calculateIterations() {
        
        for (int y = 0; y < m_height; y++) {
            cout << "Line: " << y << endl;
            for (int x = 0; x < m_width; x++) {
                
                pair<double, double> coords = m_zoomList.doZoom(x, y);
                
                int iterations = Mandelbrot::getIterations(coords.first, coords.second);
                
                m_fractal[y * m_width + x] = iterations;
                
                if (iterations != Mandelbrot::MAX_ITERATIONS) {
                    m_histogram[iterations]++;
                }
            }
        }
    }
    
    void FractalCreator::calculateRangeTotals() {
        
        int rangeIndex = 0;
        
        for (int i = 0; i < Mandelbrot::MAX_ITERATIONS; i++) {
            int pixels = m_histogram[i];
            
            if (i >= m_ranges[rangeIndex + 1]) {
                rangeIndex++;
            }
            m_rangeTotals[rangeIndex] += pixels;
        }
        
        for (int value: m_rangeTotals) {
            cout << "Range total: " << value << endl;
        }
    }
    
    void FractalCreator::drawFractal() {
        
        int total = 0;
        for (int i = 0; i < Mandelbrot::MAX_ITERATIONS; i++) {
            total += m_histogram[i];
        }
        
        for (int y = 0; y < m_height; y++) {
            for (int x = 0; x < m_width; x++) {
                
                
                uint8_t red = 0;
                uint8_t green = 0;
                uint8_t blue = 0;
                
                int iterations = m_fractal[y * m_width + x];
                
                int range = getRange(iterations);
                int rangeTotal = m_rangeTotals[range];
                int rangeStart = m_ranges[range];
                
                RGB& startColor = m_colors[range];
                RGB& endColor = m_colors[range + 1];
                RGB colorDiff = endColor - startColor;
                
                if (iterations != Mandelbrot::MAX_ITERATIONS) {
                    
                    int totalPixels = 0;
                    
                    for (int i = 0; i < iterations; i++) {
                        totalPixels += m_histogram[i];
                    }
                    red = startColor.red + colorDiff.red * (double)totalPixels/rangeTotal;
                    green = startColor.green + colorDiff.green * (double)totalPixels/rangeTotal;
                    blue = startColor.blue + colorDiff.blue * (double)totalPixels/rangeTotal;
                }
                m_bitmap.setPixel(x, y, red, green, blue);
            }
        }
    }
    
    void FractalCreator::writeBitmap(string name) {
        
        bool success = m_bitmap.write(name);
        
        if (success == true) {
            cout << "Successfully written bmp to disk!" << endl;
        } else {
            cout << "Could'nt write bmp to disk!" << endl;;
        }
    }
    
    int FractalCreator::getRange(int iterations) const {
        
        int range = 0;
        
        for (int i = 1; i < m_ranges.size(); i++) {
            range = i;
            if (m_ranges[i] > iterations) {
                break;
            }
        }
        range--;
        
        assert(range > -1);
        assert(range < m_ranges.size());
        
        return range;
    }
    
    FractalCreator::~FractalCreator() {
        cout << "Fractal Creator destroyed.." << endl;
    }
}
