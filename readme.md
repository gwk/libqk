Copyright 2013 George King.  
Permission to use this file is granted in libqk/license.txt.

libqk
=====

libqk is a utility library for OS X and iOS Objective-C application programming.


## Features

### Build scripts for creating the following static libs for both architectures (including fat iOS/Simulator libs):
* libjpeg/libturbojpg
* libpng
* libsqlite3

The image libraries are useful for situations that require manipulating image data directly, e.g. creating OpenGL textures. Core Graphics can load both PNG and JPG files, but imposes its own limited pixel formats on the resulting image data. 

### JNB
An experimental file format called JNB (JSON, Null, Bytes). In the future this may be generalized to TNB (Text, Null, Bytes). The basic idea is to create a hybrid file format consisting of a textual header, a null terminator and padding, followed by a 16 byte aligned binary data section. The header describes the binary data structure sufficiently so that it can be correctly parsed (and perhaps verified). This approach makes it easy to inspect the textual header on the command line, easy to parse arbitrarily complex metadata from the header, but also provides the density of raw binary storage.

### Cross-platform Objective-C
* A variety of categories extend the Foundation classes.
* Core Foundation wrapper class provides the convenience of ARC for CF types.
* Core Graphics wrapper classes and utilities.
* OpenGL utilities, including convenient shader and program objects that ease the shader development cycle.
* NSUIView is a macro definition and category extending and to a small extent unifying NSView and UIView.
* QKData protocol enables abstract interface-oriented programming for binary data.
* QKImage provides an image buffer class that can be used with both Core Graphics and OpenGL.
* PNG and JPG loaders for QKImage.
* C vector types defined via macros.
* A variety of helpful macros.

### iOS
* Useful categories for various UI classes.
* QKScrollView provides OpenGL-compatible scrolling with arbitrary UIView overlays (has some limitations; if I need this again I will probably write my own scroll view rather than dealing with never-ending UIScrollView idiosyncrasies).
* GLKit utilities.

### Mac OS X
* Useful categories for various UI classes.
* Layer-backed windowing utilities.
* QKWindow class reduces some of the complexity of NSWindow.
