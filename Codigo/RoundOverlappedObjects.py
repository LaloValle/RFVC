import numpy as np
import cv2
from ImagesResources import *

def round_overlapped_objects(image):
    aux_image = np.copy(image)
    np.bitwise_not(aux_image,aux_image)
    
    return aux_image

def get_number_objects(image:np.array,neighbours:str='8') -> int :
    """Allows to determine the number of solid objects whitout gaps

    Parameters
    ----------
    image : array
    
    neighbours : char
        Refers to the method used: 4-Neighbours of 8-Neighbours
    
    """
    if neighbours not in ['4','8']: return -1  # Error in the function because invalid neighbours method

    count_mask_1 = count_mask_2 = count_mask_3 = 0

    n,m = image.shape[:2]

    for x in range(m-1):
        for y in range(n-1):
            bit_quad_aux = image[y:y+2,x:x+2]
            # First is verified if a window is just white pixels
            if np.array_equal(bit_quad_aux,MASK_WHITE): pass
            else: # Then if it's not, if it matches with any of the 3 masks
                if np.array_equal(bit_quad_aux,MASK_1):   count_mask_1 += 1
                elif np.array_equal(bit_quad_aux,MASK_2): count_mask_2 += 1
                elif np.array_equal(bit_quad_aux,MASK_3): count_mask_3 += 1

    # 4-Neighbour Number of objects
    if neighbours == '4':
        return count_mask_1 - count_mask_2 + count_mask_3
    
    # 8-Neighbour Number of objects
    if neighbours == '8':
        return count_mask_1 - count_mask_2 - count_mask_3

# https://docs.opencv.org/3.4/d2/dbd/tutorial_distance_transform.html
def main():
    structuring_element = cv2.getStructuringElement(cv2.MORPH_RECT,(5,5))

    # Obtención imagen en escala de grises
    #image = cv2.imread('Resources/Pruebas/Objects_pixelart.png',cv2.IMREAD_GRAYSCALE)
    image = cv2.imread('Resources/Pruebas/monedas_2.jpeg',cv2.IMREAD_GRAYSCALE)
    threshold,image = cv2.threshold(image,200,255,cv2.THRESH_BINARY)
    cv2.imshow('Imagen original',image)
    # Se invierte la imagen para que el objeto sea blanco y el fondo negro
    image = 255-image
    cv2.imshow('Imagen umbralizada e invertida',image)

    # Transformada distancia
    dist = cv2.distanceTransform(image, cv2.DIST_L2,cv2.DIST_MASK_PRECISE)
    # Como el resultado de la transformada distancia se realiza en pasos muy pequeños se debe normalizar para ser observados
    cv2.normalize(dist,dist,0.0,1.0,cv2.NORM_MINMAX)
    print('dist >> ',dist.shape)
    cv2.imshow('Transformada distancia normalizada',dist)

    # Se aplica un umbralado
    threshold,dist = cv2.threshold(dist,0.6,1.0,cv2.THRESH_BINARY)
    cv2.imshow('Transformada distancia normalizada y umbralada',dist)
    
    cv2.normalize(dist,dist,0,255,cv2.NORM_MINMAX)
    dist = 255 - dist
    cv2.imshow('Objetos',dist)
    

    """ image = cv2.imread('Resources/Pruebas/Objetos_redondos.png',cv2.IMREAD_GRAYSCALE)
    threshold,image = cv2.threshold(image,200,255,cv2.THRESH_BINARY)
    dist = 255-image
    cv2.imshow('Imagen original',image)

    structuring_element = cv2.getStructuringElement(cv2.MORPH_RECT,(5,5))
    dist = cv2.dilate(dist,structuring_element)
    dist = cv2.dilate(dist,structuring_element)
    dist = cv2.dilate(dist,structuring_element) """

    #print('Numero objetos >> ', get_number_objects(dist))

    cv2.waitKey(15000)
    cv2.destroyAllWindows()

if __name__ == '__main__': main()