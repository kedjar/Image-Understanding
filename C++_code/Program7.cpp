//  Program 7 : Reflection
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
    // Apply the reflections
    Mat dsth, dstv, dst;
    Mat Mh = (Mat_<double>(2,3) << -1, 0, src.cols, 0, 1, 0);
              Mat Mv = (Mat_<double>(2,3) << 1, 0, 0, 0, -1, src.rows);
              Mat M = (Mat_<double>(2,3) << -1, 0, src.cols, 0, -1, src.rows);
              warpAffine(src,dsth,Mh,src.size());
              warpAffine(src,dstv,Mv,src.size());
              warpAffine(src,dst,M,src.size());
              // Show the results
              namedWindow( " ORIGINAL ", WINDOW_AUTOSIZE );
              imshow( " ORIGINAL ", src );
              namedWindow( " H-REFLECTION ", WINDOW_AUTOSIZE );
              imshow( " H-REFLECTION ", dsth );
              namedWindow( " V-REFLECTION ", WINDOW_AUTOSIZE );
              imshow( " V-REFLECTION ", dstv );
              namedWindow( " REFLECTION ", WINDOW_AUTOSIZE );
              imshow( " REFLECTION ", dst );
              waitKey();
    return 0;
}