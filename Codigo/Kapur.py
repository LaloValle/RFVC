import numpy as np
import cv2


    
def kapur_found(image):
    hist, _ = np.histogram(image, bins=range(256), density=True)
    c_hist = hist.cumsum()
    c_hist_i = 1.0 - c_hist

    # To avoid invalid operations regarding 0 and negative values.
    c_hist[c_hist <= 0] = 1
    c_hist_i[c_hist_i <= 0] = 1

    c_entropy = (hist * np.log(hist + (hist <= 0))).cumsum()
    b_entropy = -c_entropy / c_hist + np.log(c_hist)

    c_entropy_i = c_entropy[-1] - c_entropy
    f_entropy = -c_entropy_i / c_hist_i + np.log(c_hist_i)
    return np.argmax(b_entropy + f_entropy)
    




image = cv2.imread('Resources/Sencillas/3_objetos.jpg',cv2.IMREAD_GRAYSCALE)
k1 = kapur_threshold(image)
print('Threshold >> ',k1)

_,image = cv2.threshold(image,k1,255,cv2.THRESH_BINARY)
_,image2 = cv2.threshold(image,k1,255,cv2.THRESH_BINARY_INV)

cv2.imshow('Thresholded with Kapur',image)
cv2.imshow('Thresholded with Kapur 2',image2)

cv2.waitKey(15000)
cv2.destroyAllWindows()