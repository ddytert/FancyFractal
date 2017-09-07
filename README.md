# FancyFractal
A fractal viewer for Mac OS  X, programmed in C++ using an Objective-C++ wrapper to work with Swift

The code for the creation of fractals was taken from the great Udemy online course "Learn Advanced C++ Programming"
by John Purcell.
As an exercise I wanted to 'connect' the fractal creation classes, written in C++, with swift to display the rendered
fractals in a windwow on a Mac.
I use a "FCWrapper"-object written in a mixture of Objective-C and C++ (a file with .mm ending). This class is made
visible to swift by using a "Bridiging-Header" file.


