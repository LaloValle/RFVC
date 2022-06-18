import numpy as np
import cv2

def cheng_threshold(image):
    # Probability of each pixel value
    p,_ = np.histogram(image, bins=range(256), density=True)
    # Cumulative probabilities for C1 and C2
    c1 = p.cumsum(); c2 = 1.0 - c1
    # Cumulative sum of the square of pixels probability and the complement
    G = (p**2).cumsum(); G_c = G[-1]-G
    # When the probabilities are 0 its changed to 1 so that it
    # won't affect when used inside the natural logarithm
    c1[c1 <= 0] = 1; c2[c2 <= 0] = 1
    G[G == 0] = 1; G_c[G_c == 0] = 1
    # Functional
    # CT(u) = C_c1(u)+C_c2(u) = -ln[G(u)xG'(u)]+2ln[P1(u)+P2(u)]
    CT = -np.log(G*G_c) + 2*np.log(c1*c2)
    return np.argmax(CT)

def cheng_threshold_filter(image,filter_size:int=5):
    # Frecuency of each pixel value
    p,_ = np.histogram(image, bins=range(256))
    # Probability of each pixel
    p = mean_filter(p,filter_size)/p.sum()
    # Cumulative probabilities for C1 and C2
    c1 = p.cumsum(); c2 = 1.0 - c1
    print(c1)
    # Cumulative sum of the square of pixels probability and the complement
    G = (p**2).cumsum(); G_c = G[-1]-G
    # When the probabilities are 0 its changed to 1 so that it
    # won't affect when used inside the natural logarithm
    c1[c1 <= 0] = 1; c2[c2 <= 0] = 1
    G[G == 0] = 1; G_c[G_c == 0] = 1
    # Functional
    # CT(u) = C_c1(u)+C_c2(u) = -ln[G(u)xG'(u)]+2ln[P1(u)+P2(u)]
    CT = -np.log(G*G_c) + 2*np.log(c1*c2)
    return np.argmax(CT)
    


def mean_filter(vector,filter_size:int=5):
    side_elements = int(filter_size/2)
    for index in np.where(vector == 0)[0]:
        if index+(filter_size-1-side_elements) < vector.shape[0]:
            vector[index] = np.ceil(np.mean(vector[list(range(index-side_elements,index+(filter_size-1-side_elements)))])) 
    return vector

image = cv2.imread('Resources/Sencillas/3_objetos.jpg',cv2.IMREAD_GRAYSCALE)
cheng = cheng_threshold(image)
cheng2 = cheng_threshold_filter(image,12)
print('Cheng threshold >>', cheng,cheng2)

_,image = cv2.threshold(image,cheng,255,cv2.THRESH_BINARY)
_,image2 = cv2.threshold(image,cheng2,255,cv2.THRESH_BINARY)

cv2.imshow('Thresholded with Cheng',image)
cv2.imshow('Thresholded with Cheng filter',image2)

cv2.waitKey(15000)
cv2.destroyAllWindows()