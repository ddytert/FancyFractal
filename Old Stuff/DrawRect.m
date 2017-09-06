CGBitmapContextCreate: invalid data bytes/row: should be at least 1920 for 8 integer bits/component, 3 components, kCGImageAlphaPremultipliedLast.
Aug 23 17:07:47  FancyFractal[6886] <Error>: CGBitmapContextCreate: invalid data bytes/row: should be at least 1920 for 8 integer bits/component, 3 components, kCGImageAlphaPremultipliedLast.
context is nil

{
    // Get current context
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];

    // Colorspace RGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    // Pixel Matrix allocation
    unsigned short *pixels = calloc(SIZE, sizeof(unsigned short));

    // Random pixels will give you a non-organized RAINBOW 
    for (int i = 0; i < WIDTH; i++) {
        for (int j = 0; j < HEIGHT; j++) {
            pixels[i+ j*HEIGHT] = arc4random() % USHRT_MAX;
        }
    }

    // Provider
    CGDataProviderRef provider = CGDataProviderCreateWithData(nil, pixels, SIZE, nil);

    // CGImage
    CGImageRef image = CGImageCreate(WIDTH,
                                     HEIGHT,
                                     BITS_PER_COMPONENT,
                                     BITS_PER_PIXEL,
                                     BYTES_PER_PIXEL*WIDTH,
                                     colorSpace,
                                     kCGImageAlphaNoneSkipFirst,
                                     // xRRRRRGGGGGBBBBB - 16-bits, first bit is ignored!
                                     provider,
                                     nil, //No decode
                                     NO,  //No interpolation
                                     kCGRenderingIntentDefault); // Default rendering

// Draw
CGContextDrawImage(context, self.bounds, image);

// Once everything is written on screen we can release everything
CGImageRelease(image);
CGColorSpaceRelease(colorSpace);
CGDataProviderRelease(provider);