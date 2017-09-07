//
//  FCWrapper.h
//  FancyFractal
//
//  Created by Daniel Dytert on 25.08.17.
//  Copyright © 2015 John Purcell. All rights reserved.
//

#ifndef FCWrapper_h
#define FCWrapper_h

#import <AppKit/AppKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface FCWrapper : NSObject

- (instancetype)initWithSize:(CGSize)frameSize bitmapData:(uint8 *)bitmap;

- (void)startRendering;
- (void)zoomIntoFractalAt:(CGPoint)location withZoom:(double)zoomFactor;

@end


#endif /* FCWrapper_h */
