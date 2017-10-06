//  Program 12 : Sobel derivatives - Scharr opeator
//  main.cpp
//  OpenCV Lab 1
//
//  Created by M'Hand Kedjar on 2016-01-20.
//  http://www.swarthmore.edu/NatSci/mzucker1/opencv-2.4.10-docs/doc/tutorials/imgproc/imgtrans/sobel_derivatives/sobel_derivatives.html
//
//  Open Source
//
//
#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
using namespace std;
using namespace cv;
int main() {
    Mat image = imread("../../data/mk3.jpg"), image_blurred;
    // Blur image with a Gaussian kernel to remove edge noise
    GaussianBlur(image, image_blurred, Size(3, 3), 0, 0);
    // Convert to gray
    Mat image_gray;
    cvtColor(image_blurred, image_gray, CV_RGB2GRAY);
    // Gradients in X and Y directions
    Mat grad_x, grad_y;
    Scharr(image_gray, grad_x, CV_32F, 1, 0);
    Scharr(image_gray, grad_y, CV_32F, 0, 1);
    // Calculate overall gradient
    pow(grad_x, 2, grad_x);
    pow(grad_y, 2, grad_y);
    Mat grad = grad_x + grad_y;
    sqrt(grad, grad);
    // Display
    namedWindow("Original image");
    namedWindow("Scharr edges");
    // Convert to 8 bit depth for displaying
    Mat edges;
    grad.convertTo(edges, CV_8U);
    imshow("Original image", image);
    imshow("Scharr edges", edges);
    while(char(waitKey(1)) != 'q') {}
    return 0;
}