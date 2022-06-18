from math import sqrt
from turtle import shape
import numpy as np
import os
import cv2

def noise(noise_type:str,image,**kargs):
    list_keys = list(kargs)
    image = np.copy(image)

    if noise_type == "gaussian":
        #
        # https://www.programcreek.com/python/?code=ugent-korea%2Fpytorch-unet-segmentation%2Fpytorch-unet-segmentation-master%2Fsrc%2Fpre_processing.py
        #
        # Obtains the values of the mean and standard deviation
        mean = kargs['mean'] if 'mean' in list_keys else 0; std_deviation = kargs['std_deviation'] if 'std_deviation' in kargs.keys() else 0.1
        print('mean >>',mean,'  std deviation >>',std_deviation)
        # Creates the noise in a random manner according to the normal distribution with the given mean and standard deviation
        gauss = np.random.normal(mean,std_deviation,image.shape)
        # The noise gets added
        noisy_image = image + gauss
        # Rectifies that values an the upper and lower limit do not exceeds 0-255
        noisy_image[noisy_image > 255] = 255; noisy_image[noisy_image < 0] = 0
        return noisy_image.astype(np.uint8)
    elif noise_type == "s&p":
        #
        # https://blog.kyleingraham.com/2017/02/04/salt-pepper-noise-and-median-filters-part-ii-the-code/
        #
        l = 101 if 'l' not in list_keys else kargs['l']
        # Convert the image to 0 to 1 float to avoid wrapping that occurs with uint8
        image.astype(np.float16, copy = False)
        image = np.multiply(image, (1/255))
        # Generate noise to be added to the image
        noise = np.random.randint(l, size=image.shape)
        # Convert high and low bounds of l in noise to salt and pepper noise then add it to
        # our image. 1 is subtracted from l to match bounds behaviour of np.random.randint.
        image = np.where(noise == 0, 0, image)
        image = np.where(noise == (l-1), 1, image)
        # Properly handles the conversion from float16 back to uint8
        image = cv2.convertScaleAbs(image, alpha = (255/1))        
        return image
    else: return np.zeros(image.shape)
    """ elif noise_type == "poisson":
        vals = len(np.unique(image))
        vals = 2 ** np.ceil(np.log2(vals))
        noisy = np.random.poisson(image * vals) / float(vals)
        return noisy
    elif noise_type =="speckle":
        row,col,ch = image.shape
        gauss = np.random.randn(row,col,ch)
        gauss = gauss.reshape(row,col,ch)        
        noisy = image + image * gauss
        return noisy """

def main():
    image = cv2.imread('Resources/Complejas/Axolote.jpeg',cv2.IMREAD_GRAYSCALE)
    cv2.imshow('Imagen original',image)
    noisy_image = noise('gaussian',image,mean=0,std_deviation=30)
    cv2.imshow('Imagen con ruido',noisy_image)
    noisy_image_2 = noise('s&p',image)
    cv2.imshow('Imagen con sp ruido',noisy_image_2)

    cv2.waitKey(0)
    cv2.destroyAllWindows()

if __name__ == '__main__': main()