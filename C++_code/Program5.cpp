//  Program 5 : Rotation
//  main.cpp
//  OpenCV Lab 1
//
//  Created by M'Hand Kedjar on 2016-01-20.
//  http://docs.opencv.org/2.4/modules/imgproc/doc/geometric_transformations.html#resize
//  Book Learning Image processing with OpenCV
//  Open Source
//

#include "opencv2/opencv.hpp"
#include <math.h>
using namespace cv;
int main( int argc, char** argv )
{
    // Read the source file
    Mat src;
    src = imread("../../data/mk2.jpg");
    // Apply skew
    Mat dst;
    double m = 1/tan(M_PI/3);
    Mat M = (Mat_<double>(2,3) << 1, m, 0, 0, 1, 0);
    warpAffine(src,dst,M,Size(src.cols+0.5*src.cols,src.rows));
    // Show the results
    namedWindow( " ORIGINAL ", WINDOW_AUTOSIZE );
    imshow( " ORIGINAL ", src );
    namedWindow( " SKEWED ", WINDOW_AUTOSIZE );
    imshow( " SKEWED ", dst );
    waitKey();
    return 0;
}