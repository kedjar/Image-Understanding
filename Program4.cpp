//  Program 4 : Translation
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
    // Apply translation
    Mat dst;
    Mat M = (Mat_<double>(2,3) << 1, 0, 300, 0, 1, 250);
    warpAffine(src,dst,M,src.size());
    // Show the results
    namedWindow( " ORIGINAL ", WINDOW_AUTOSIZE );
    imshow( " ORIGINAL ", src );
    namedWindow( " TRANSLATED ", WINDOW_AUTOSIZE );
    imshow( " TRANSLATED ", dst );
    waitKey();
    return 0;
}