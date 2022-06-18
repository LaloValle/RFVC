import numpy as np
import cv2

# https://www.coseries.com/morphological-transformations-in-python-using-opencv/
# https://pyimagesearch.com/2021/04/28/opencv-morphological-operations/
def morpholical_operation(morph_op_type:str,image,n:int=3,spatial_structure:str='rect',**kargs):
    image = np.copy(image)
    structuring_element = cv2.getStructuringElement(cv2.MORPH_CROSS if spatial_structure == 'cross' else cv2.MORPH_RECT,(n,n))

    if morph_op_type == 'erosion':
        return cv2.erode(image,structuring_element)
    elif morph_op_type == 'dilation':
        return cv2.dilate(image,structuring_element)
    elif morph_op_type == 'closing':
        return cv2.morphologyEx(image,cv2.MORPH_CLOSE,structuring_element)
    elif morph_op_type == 'opening':
        return cv2.morphologyEx(image,cv2.MORPH_OPEN,structuring_element)

def main():
    image = cv2.imread('Resources/Sencillas/pyimage.png',cv2.IMREAD_GRAYSCALE)
    cv2.imshow('Imagen original',image)

    cv2.waitKey(0)
    cv2.destroyAllWindows()

if __name__ == '__main__': main()