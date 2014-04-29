Copyright 2013 George King.  
Permission to use this file is granted in libqk/license.txt.

libqk
=====

libqk is a utility library for OSX and iOS Objective-C application programming.
It is highly experimental; some parts are stable, some parts are unstable, and some parts are completely broken.


## Features

### Build scripts for creating the fat static libs for both platforms (including fat iOS/Simulator libs):
* libjpeg/libturbojpg
* libpng
* libsqlite3
* opencv

The image libraries are useful for situations that require manipulating image data directly, e.g. creating OpenGL textures. Core Graphics can load both PNG and JPG files, but imposes its own limited pixel formats on the resulting image data. 

### Cross-platform Objective-C
* A variety of categories extend the Foundation classes.
* Core Foundation wrapper class provides the convenience of ARC for CF types.
* Core Graphics wrapper classes and utilities.
* OpenGL utilities, including convenient shader and program objects that ease the shader development cycle.
* CUI classes unify various similar AppKit and UIKit classes (your mileage may vary!).
* QKData protocol enables abstract interface-oriented programming for binary data.
* QKImage provides an image buffer class that can be used with both Core Graphics and OpenGL.
* PNG and JPG loaders for QKImage.
* C vector types defined via macros.
* A variety of helpful macros.

### iOS
* QKViewController base class.
* QKScrollView.
* QKTableView extends QKScrollView (not UITableView) to provide simplified block-based table implementations with generic UIView cells.

### Mac
* Layer-backed windowing utilities.
* QKWindow class reduces some of the complexity of NSWindow.
