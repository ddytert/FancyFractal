# FancyFractal
A fractal viewer for Mac OS  X, programmed in C++ using an Objective-C++ wrapper to work with Swift

The code for the creation of fractals was taken from John Purcell's online course "Learn Advanced C++ Programming" on Udemy,
a great course by the way.

As an exercise I wanted to 'connect' the fractal creation classes, written in C++, to swift to display the rendered
fractals in a windwow on a Mac.

I use a "FCWrapper"-object written in Objective-C and C++ (a a mixture of both languages, the file has .mm as ending).
This class is made visible to swift by using a "Bridiging-Header" file. The ViewController, written in Swift, creates
an FCWrapper object and calls methods on this object. The FCWrapper object itself creates an object of the
"FractalCreator" C++ class. The calls from the ViewController are redirected via the FCWrapper object to the
FractalCreator object. The FractalCreator object holds a pointer to a raw bitmap buffer. The bitmap buffer is created
in the ViewController object and a pointer to the buffer is given via the FCWrapper object to the FractalCreator object.
The FractalCreator writes directly into the buffer via a Bitmap object, which has a pointer to the bitmap.




