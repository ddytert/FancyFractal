//
//  FCWrapper.m
//  FancyFractal
//
//  Created by Daniel Dytert on 25.08.17.
//  Copyright © 2017 Daniel Dytert. All rights reserved.
//
/*
 It’s as simple as that! Note the property is declared as assign, as you cannot use strong or weak because these don't make sense with non-Objective-C object types. The compiler cannot “retain” or “release” a C++ object type, because it’s not an Objective-C object.
 The correct memory management will still happen with assign because you’ve used a shared pointer. You could use a raw pointer, but then you would need to write the setter yourself to delete the old instance and set the new value as appropriate.
 */

#import "FCWrapper.h"
#import "FractalCreator.hpp"

using namespace danlointeractive;

@interface FCWrapper ()

@property (nonatomic, assign) CGSize frameSize;
@property (nonatomic, assign) uint8 *bitmap;
@property (nonatomic, assign) std::shared_ptr<FractalCreator> fractalCreator;

@end

@implementation FCWrapper

- (instancetype)initWithSize:(CGSize)fs bitmapData:(uint8 *)bitmap {
    
    self = [super init];
    
    if (self) {
        
        if (fs.width == 0 || fs.height == 0) {  // Check for invalid rectangle
            return nil;
        }
        _frameSize = fs;
        // Create FractalCreator object
        _fractalCreator = std::shared_ptr<FractalCreator>(new FractalCreator(fs.width, fs.height, bitmap));
                
        return self;
        
    } else {
        return nil;
    }
}

- (void)startRendering{
    
    if (_fractalCreator) {
        
        _fractalCreator->addRange(0.0, RGB(0, 0, 0));
        _fractalCreator->addRange(0.2, RGB(255, 0, 0));
        _fractalCreator->addRange(0.85, RGB(255, 255, 0));
        _fractalCreator->addRange(0.95, RGB(255, 0, 127));
        _fractalCreator->addRange(1.0, RGB(0, 0, 255));
        
        // Initital zoom -> Show whole fractal
        _fractalCreator->addZoom(Zoom((_frameSize.width / 2) - (_frameSize.width / 10), _frameSize.height / 2, 1.0));
        
        _fractalCreator->run("MyFancyFractal.bmp");
    }
}

- (void)zoomIntoFractalAt:(CGPoint)location withZoom:(double)zoomFactor {

    _fractalCreator->addZoom(Zoom(location.x, location.y, zoomFactor));
    _fractalCreator->run("MyFancyFractal.bmp");
}

- (void)dealloc {
    NSLog(@"FCWrapper destroyed..");
}

@end

