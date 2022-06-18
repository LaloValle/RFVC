import cv2
from numpy import *
from Images import *

RESOURCES = './Resources/'

positions_bit_quad = [[],[],[]]

#image = cv2.imread(RESOURCES+'Outline_object.png')
#threshold_use,image_threshold = threshold_image(image,threshold=60)
#number_objects = get_number_objects(image_threshold,neighbours='4')

# image_2 = cv2.imread(RESOURCES+'Objects_pixelart.png')
# threshold_use,image_threshold_2 = threshold_image(image_2,threshold=60)
# number_objects_2 = get_number_objects(image_threshold_2,neighbours='4')

# image_3 = cv2.imread(RESOURCES+'Object_1_gap.png')
# threshold_use,image_threshold_3 = threshold_image(image_3,threshold=60)

# image_4 = cv2.imread(RESOURCES+'Object_2_gaps.png')
# threshold_use,image_threshold_4 = threshold_image(image_4,threshold=60)

# image_5 = cv2.imread(RESOURCES+'3_objetos_umbralada.jpg')
# threshold_use,image_threshold_5 = threshold_image(image_5,threshold=60)

# print('<--- Number objects = {},{} --->'.format(number_objects,number_objects_2))

# contours_chain_code,image_highlighted = highlight_contour(image_threshold)
# print('Contours Names >> ',contours_chain_code.keys())
# contours_chain_code_2,image_highlighted_2 = highlight_contour(image_threshold_2)
# print('Contours Names >> ',contours_chain_code_2.keys())
# contours_chain_code_3,image_highlighted_3 = highlight_contour(4)
# print('Contours Names >> ',contours_chain_code_3.keys())
# contours_chain_code_4,image_highlighted_4 = highlight_contour(image_threshold_4)
# print('Contours Names >> ',contours_chain_code_4.keys())
# contours_chain_code_5,image_highlighted_5 = highlight_contour(image_threshold_5)
# print('Contours Names >> ',contours_chain_code_5.keys())

# cv2.imshow("Threshold image",image_threshold)
# cv2.imshow("Outlined image",image_highlighted)
# cv2.imshow("Threshold image 2",image_threshold_2)
# cv2.imshow("Outlined image 2",image_highlighted_2)
# cv2.imshow("Threshold image 3",image_threshold_3)
# cv2.imshow("Outlined image 3",image_highlighted_3)
# cv2.imshow("Threshold image 4",image_threshold_4)
# cv2.imshow("Outlined image 4",image_highlighted_4)
# cv2.imshow("Threshold image 5",image_threshold_5)
# cv2.imshow("Outlined image 5",image_highlighted_5)

#cv2.imwrite(RESOURCES+'3_objetos_umbralada.jpg',image_5)

# cv2.waitKey(0)
# cv2.destroyAllWindows()


# ---------------------------------------------------------------

print(directions_to_labels(DIRECTIONS_8_NEIGHBOURS,'8'))
print('------------------------------------------')
print('------------------------------------------')
for index in range(4):
    aux_contour_direction_2([],[index])
    print('------------------------------------------')