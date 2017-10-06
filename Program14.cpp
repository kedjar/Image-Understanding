//  Program 14 : Canny filter
//  main.cpp
//  OpenCV Lab 1
//
//  Created by M'Hand Kedjar on 2016-01-20.
//  http://docs.opencv.org/3.0-beta/doc/py_tutorials/py_imgproc/py_canny/py_canny.html
//
//  Open Source
//
//


#include "opencv2/core/core.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "iostream"

using namespace cv;
using namespace std;

int main( )
{
    Mat src1;
    src1 = imread("../../data/mk3.jpg", CV_LOAD_IMAGE_COLOR);
    namedWindow( "Original image", CV_WINDOW_AUTOSIZE );
    imshow( "Original image", src1 );
    
    Mat gray, edge, draw;
    cvtColor(src1, gray, CV_BGR2GRAY);
    
    Canny( gray, edge, 50, 150, 3);
    
    edge.convertTo(draw, CV_8U);
    namedWindow("Canny edge detector", CV_WINDOW_AUTOSIZE);
    imshow("Canny edge detector", draw);
    
    waitKey(0);
    return 0;
} 