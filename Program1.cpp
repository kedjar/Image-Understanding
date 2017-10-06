//  Program 1 : Acquiring and displaying an image
//  main.cpp
//  OpenCV Lab 1
//
//  Created by M'Hand Kedjar on 2016-01-20.
//  From http://docs.opencv.org/3.0-beta/doc/tutorials/introduction/display_image/display_image.html
//  Open Source
//

#include <opencv2/opencv.hpp>

using namespace cv;

int main(){
    
    Mat image = imread("../../data/mk2.jpg");       // Creating the matrice image and reading the file
   
    if(image.empty()){                             // Check for invalid input
        return -1;
    }
    
    namedWindow("M'Hand Kedjar", WINDOW_AUTOSIZE); // Create a windows for display
    imshow("M'Hand Kedjar", image);                // Show the image inside it
    
    waitKey(0);                                    // Wait for a keystroke in the window
    
}