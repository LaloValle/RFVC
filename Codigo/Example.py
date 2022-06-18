from itertools import chain
from cv2 import imread, imshow
from Images import *
from Backend import *
import cv2
import numpy as np

"""black_image = np.zeros((512,512,3),np.uint8)

cv2.imshow("Windows",black_image)

black_image[:,15] = 255,255,255
black_image[8,:] = 255,255,0

cv2.imshow("Windows 2",black_image)"""

# objects = cv2.imread('/home/lalovalle/Documents/OpenCV/Programs/Resources/Axolote.jpeg')

# threshold_used,objects_threshold = threshold_image(objects,150)
# print('Threshold used:',threshold_used)
"""print(objects_threshold)
print(objects_threshold.shape[:2])

g,r,b = cv2.split(objects_threshold)

cv2.imshow("Green channel",g)

cv2.imshow("Objects",objects)
cv2.imshow("Threshold Objects",objects_threshold)"""

"""
x = arange(60).reshape(5,4,3)
x[0:2,:2]
"""
"""MASK_1 = [
    [ [0,0,0],      [255,255,255] ],
    [ [255,255,255],[255,255,255] ]
]

objects_threshold[0:2,:2] = 0,0,0
print(objects_threshold[0:2,:2]-array(MASK_1))"""

# cv2.imshow("Threshold Objects modified",objects_threshold)
# cv2.imshow("Objects modified",objects)
# # bit_quad_masks = [[],[],[]]
# image = imread('./Resources/Outline_object.png')
# threshold_used,image_threshold = threshold_image(image)
# number_objects = get_number_objects(image_threshold,bit_quad_positions=bit_quad_masks)
# print('Positions masks',bit_quad_masks)
# print('Number objects', number_objects)

"""image_gap = imread('./Resources/Object_1_gap.png')
threshold_used_gap,image_gap_threshold = threshold_image(image_gap)
number_gaps = get_number_gaps(image_gap_threshold)

image_gaps = imread('./Resources/Object_2_gaps.png')
threshold_used_gaps,image_gaps_threshold = threshold_image(image_gaps)
number_gaps_2 = get_number_gaps(image_gaps_threshold)

print('Number of objects identified:',number_objects)
print('Number of gaps identified:',number_gaps)
print('Number of 2_gaps identified:',number_gaps_2)

print('Simply connected(original):',is_simply_connected(image_threshold))
print('Simply connected(1 Gap)',is_simply_connected(image_gap_threshold))
print('Multiply connected(2 gaps)',is_multiply_connected(image_gaps_threshold))

imshow("Original Image",image)
imshow("Threshold Image",image_threshold)
imshow("Threshold Image gap",image_gap_threshold)
imshow("Threshold Image gaps",image_gaps_threshold)"""

#imshow("Threshold Image Or",image_threshold)
# image_threshold[10:15,:5] = 0,0,255
# imshow("Threshold Image",image_threshold)
# print(image_threshold[2:5,3:6],'\n \n')
# print(image_threshold[2:5,4:7],'\n \n')
#print(image_threshold[2:5,3:6]*EAST,'\n =================== \n',image_threshold[2:5,3:6]*SOUTH,'\n =================== \n',image_threshold[2:5,3:6]*WEST,'\n =================== \n',image_threshold[2:5,3:6]*NORTH)

# chain_code = [1]
# position = array((12,12))
# for i in range(1):
#     image_subarray = image_threshold[position[1]:position[1]+3,position[0]:position[0]+3]
#     direction,steps = aux_contour_direction(i,image_subarray,chain_code,neighbouring_method='4')
#     print('Direction:',DIRECTIONS_4_NEIGHBOURS_LABELS[direction])
#     print('Steps:',steps)
#     print('Chain code:',chain_code,'\n \n')
#     if direction >= 0: image_threshold[position[1]:position[1]+3,position[0]:position[0]+3] += COLORED_4_NEIGHBOURS[direction] 
#     position += array(steps)
#------------------------------------------------
# chain_code = [2]
# position = array((12,12))
# for i in range(20):
#     image_subarray = image_threshold[position[1]:position[1]+3,position[0]:position[0]+3]
#     direction,steps = aux_contour_direction_2(image_subarray,chain_code,neighbouring_method='8')
#     print('Direction:',DIRECTIONS_8_NEIGHBOURS_LABELS[direction])
#     print('Steps:',steps)
#     print('Chain code:',chain_code,'\n \n')
#     if direction >= 0: image_threshold[position[1]:position[1]+3,position[0]:position[0]+3] += COLORED_8_NEIGHBOURS[direction] 
#     position += array(steps)

#image = imread('./Resources/3_objetos.jpg')
#image = grayscale_image(image)
# print('Shape >>',image.shape)
# threshold_used,image_threshold = threshold_image(image,60)

# print('Shape >>',image_threshold.shape)

# print('<--- Highlighting of contour started --->')
# chain_code,image_highlighted = highlight_contour(image_threshold,'8')
# # chain_code_2,image_highlighted_2 = highlight_contour(image_threshold,neighbouring_method='8')

# #print('Chain code len >>',chain_code)
# #print('Chain code len >>',chain_code_2)

# imshow("Threshold Image Outline",image_threshold)
# imshow("Highlight Image",image_highlighted)
# #imshow("Highlight Image 2",image_highlighted_2)
# cv2.waitKey(0)

# images = []
# print(zeros((2,2)))
# for i in range(2):
#     new = zeros((2,2))
#     images.append(new)
# images = stack(images,axis=2)
# images.append(ones(3))
# print(images)

dataset_path = Path.cwd()/'Resources/Dataset_training.dat'
dataset,labels,names = ImageClassifier.load_dataset(dataset_path)
# print('Dataset >>',dataset)
# print('\n Labels >>',labels)
# print('\nNames >>',names)

weights = ImageClassifier.stochastic_gradient_ascent_1(array(dataset,float64),labels)
print('Weights >>',weights)

#new_image = array([1.0,94.9609,998,415])

ImageClassifier.plotBestFit(weights,dataset_path)
#new_image_class = ImageClassifier.classify_logistic_regression(new_image,weights)
#print('New image class>>',new_image_class)

ImageClassifier.store_logreg_weights(weights,'Logreg_weights.dat')
new_weights = ImageClassifier.restore_logreg_weights('Logreg_weights.dat')
print('Weights >>',new_weights)