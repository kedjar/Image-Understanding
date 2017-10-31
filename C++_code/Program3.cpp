//  Program 3 : Scaling of an image
//  main.cpp
//  OpenCV Lab 1
//
//  Created by M'Hand Kedjar on 2016-01-20.
//  http://docs.opencv.org/2.4/modules/imgproc/doc/geometric_transformations.html#resize
//  Book Learning Image processing with OpenCV
//  Open Source
//
#include "opencv2/opencv.hpp"
using namespace cv;
int main( int argc, char** argv )
{
    // Read the source file
    Mat src;
       src = imread("../../data/mk2.jpg");
    // Apply the scale
    Mat dst;
    resize(src, dst, Size(0,0), 0.5, 0.5);
    // Show the results
    namedWindow( " ORIGINAL ", WINDOW_AUTOSIZE );
    imshow( " ORIGINAL ", src );
    namedWindow( " SCALED ", WINDOW_AUTOSIZE );
    imshow( " SCALED ", dst );
    waitKey();
    return 0;
}