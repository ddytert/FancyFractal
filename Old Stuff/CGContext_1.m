//create a cgcontext
NSUInteger width = (NSUInteger)v.frame.size.width;
NSUInteger height = (NSUInteger)v.frame.size.height;
CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
NSUInteger bytesPerPixel = 4;
NSUInteger bytesPerRow = bytesPerPixel * width;
unsigned char *rawData = malloc(height * bytesPerRow);
NSUInteger bitsPerComponent = 8;
CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);


..and on second look, it's not actually wrong, just confusing. Their code is allocating the bitmapData, so it is up to them to free it when done. These days, you can let the CGBitmapContext manage its own data, by passing in NULL as the first argument to CGBitmapContextCreate -- it's generally much easier that way.
                    – Kurt Revis
                Apr 8 '12 at 6:54
                        

You need to draw the image (myImage) to a context that draws on the screen. Make a subclass of UIView and put your testDrawCG code into its drawRect: method. Then, still in drawRect:, draw myImage to the view's context like this:

CGContextDrawImage(UIGraphicsGetCurrentContext(), self.bounds, myImage);


https://stackoverflow.com/questions/10060404/how-to-draw-using-a-bitmap-context


    char *bitmapData = CGBitmapContextGetData(myBitmapContext); // 7

Now you're getting the raw data that backs the bitmap context. You don't need to do this.

	

There's a bunch of ways to do this. One of the more straightforward is to use CGContextDrawImage. In drawRect:

CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
CGDataProviderRef provider = CGDataProviderCreateWithData(nil, bitmap, bitmap_bytes, nil);
CGImageRef img = CGImageCreate(..., provider, ...);
CGDataProviderRelease(provider);    
CGContextDrawImage(ctx, dstRect, img);
CGImageRelease(img);

CGImageCreate has a bunch of arguments which I've left out here, as the correct values will depend on what your bitmap format is. See the CGImage reference for details.

Note that, if your bitmap is static, it may make sense to hold on to the CGImageRef instead of disposing of it immediately. You know best how your application works, so you decide whether that makes sense.


        32
        down vote



        accepted



            
            



    

You can use CGBitmapContextCreate to make a bitmap context from your 
raw data. Then you can create a CGImageRef from the bitmap context and 
save it. Unfortunately CGBitmapContextCreate is a little picky about the
 format of the data. It does not support 24-bit RGB data. The loop at 
the beginning swizzles the rgb data to rgba with an alpha value of zero 
at the end. You have to include  and link with ApplicationServices 
framework.



char* rgba = (char*)malloc(width*height*4);
for(int i=0; i < width*height; ++i) {
    rgba[4*i] = myBuffer[3*i];
    rgba[4*i+1] = myBuffer[3*i+1];
    rgba[4*i+2] = myBuffer[3*i+2];
    rgba[4*i+3] = 0;
}
CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
CGContextRef bitmapContext = CGBitmapContextCreate(
    rgba,
    width,
    height,
    8, // bitsPerComponent
    4*width, // bytesPerRow
    colorSpace,
    kCGImageAlphaNoneSkipLast);

CFRelease(colorSpace);

CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
CFURLRef url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, CFSTR("image.png"), kCFURLPOSIXPathStyle, false);

CFStringRef type = kUTTypePNG; // or kUTTypeBMP if you like
CGImageDestinationRef dest = CGImageDestinationCreateWithURL(url, type, 1, 0);

CGImageDestinationAddImage(dest, cgImage, 0);

CFRelease(cgImage);
CFRelease(bitmapContext);
CGImageDestinationFinalize(dest);
free(rgba);
https://stackoverflow.com/questions/1579631/converting-rgb-data-into-a-bitmap-in-objective-c-cocoa
    



Von meinem iPhone gesendet