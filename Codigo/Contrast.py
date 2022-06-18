import cv2

# https://stackoverflow.com/questions/39308030/how-do-i-increase-the-contrast-of-an-image-in-python-opencv
def contrast(image,alpha:float=1.5,beta:float=0):
    return cv2.convertScaleAbs(image,alpha=alpha,beta=beta)


def main():
    image = cv2.imread('Resources/Complejas/Axolote.jpeg',cv2.IMREAD_GRAYSCALE)
    cv2.imshow('Imagen original',image)

    cv2.imshow('Contraste',contrast(image,alpha=3,beta=1))

    cv2.waitKey(0)
    cv2.destroyAllWindows()

if __name__ == '__main__': main()