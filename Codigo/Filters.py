from math import sqrt
from turtle import shape
import numpy as np
import os
import cv2
from pip import main

# https://datamahadev.com/filters-in-image-processing-using-opencv/
def filtering(filter_type:str,image,n:int=3,**kargs):
    image = np.copy(image)

    print('Tipo filtro >>',filter_type)
    if filter_type == 'mean':
        # Kernel creation
        #   Before applying any convolution with an image using a 2D matrix it's needed to ensure 
        #   all the values are normalize, thus the division of the matrix
        kernel = np.ones((n,n),np.float32)/(n**2)
        # Mean filtering
        #   ddepth: a -1 value means the final image will also have the same depth as the original
        return cv2.filter2D(image,-1,kernel)
    elif filter_type == 'gaussian':
        std_deviation = 0 if 'std_deviation' not in list(kargs) else kargs['std_deviation']
        return cv2.GaussianBlur(image,(n,n),std_deviation)
    elif filter_type == 'median':
        return cv2.medianBlur(image,n)
    elif filter_type == 'max':
        # The morphological dilation is equivalent to a maximum filter
        kernel = cv2.getStructuringElement(cv2.MORPH_RECT,(n,n))
        return cv2.dilate(image,kernel)
    elif filter_type == 'min':
        # The morphological erosion is equivalent to a minimum filter
        kernel = cv2.getStructuringElement(cv2.MORPH_RECT,(n,n))
        return cv2.erode(image,kernel)
        

def main():
    image = cv2.imread('Resources/Complejas/Axolote.jpeg',cv2.IMREAD_GRAYSCALE)
    cv2.imshow('Imagen original',image)
    filtered_image_5 = filtering('mean',image,n=5)
    cv2.imshow('Imagen filtrada mean',filtered_image_5)
    filtered_image_gauss = filtering('gaussian',image,n=5,std_deviation=2)
    cv2.imshow('Imagen filtrada gaussian',filtered_image_gauss)
    filtered_image_median = filtering('median',image,n=5)
    cv2.imshow('Imagen filtrada median',filtered_image_median)
    filtered_image_max = filtering('max',image,n=5)
    cv2.imshow('Imagen filtrada max',filtered_image_max)
    filtered_image_min = filtering('min',image,n=5)
    cv2.imshow('Imagen filtrada min',filtered_image_min)

    cv2.waitKey(0)
    cv2.destroyAllWindows()

if __name__ == '__main__': main()