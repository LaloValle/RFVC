from itertools import count
import cv2
import matplotlib
from numpy import *
from ImagesResources import *
import matplotlib
from matplotlib import pyplot as plt
from pathlib import Path

#============
# Práctica 1
#============
# 1
def open_image_grayscale(image_path:str):
    return cv2.imread(image_path,cv2.IMREAD_GRAYSCALE)
def grayscale_image(image):
    return cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
    
# 2
def get_pixel(image:array,x:int,y:int) -> list :
    return image[y,x]
# 3
def image_of_histogram(image:array,path:Path=Path.cwd()/'.images',image_name:str='Image',title:str='Histogram') -> Path:
    gray_levels,hist = unique(image, return_counts=True)

    matplotlib.use('Agg') # Changes the GUI framework instead of Qt
    figure = plt.figure()
    axis = plt.subplot(111)
    figure.title = title
    figure.xlabel = 'Niveles de gris'
    figure.ylabel = 'Frecuencia de aparición'
    
    path = path/'Histogram_{}.png'.format(image_name)

    axis.bar(gray_levels,hist)
    figure.savefig(path.as_posix())

    return path
def histogram_no_image(image:array,density=False):
    gray_levels,hist = unique(image,return_counts=True)
    if density: hist = hist/hist.sum()
    return gray_levels,hist

# 4
def threshold_image(image:array,threshold:float=127.0,value:float=255.0):
    threshold,image_1_channel = cv2.threshold(image,threshold,value,cv2.THRESH_BINARY)
    # binarized Image of 3 channels
    return threshold,cv2.merge([copy(image_1_channel),copy(image_1_channel),copy(image_1_channel)])

# 5
def get_number_objects(image:array,neighbours:str='8') -> int :
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
            if array_equal(bit_quad_aux,MASK_WHITE): pass
            else: # Then if it's not, if it matches with any of the 3 masks
                if array_equal(bit_quad_aux,MASK_1):   count_mask_1 += 1
                elif array_equal(bit_quad_aux,MASK_2): count_mask_2 += 1
                elif array_equal(bit_quad_aux,MASK_3): count_mask_3 += 1

    # 4-Neighbour Number of objects
    if neighbours == '4':
        return count_mask_1 - count_mask_2 + count_mask_3
    
    # 8-Neighbour Number of objects
    if neighbours == '8':
        return count_mask_1 - count_mask_2 - count_mask_3

# 6
def get_number_gaps(image:array,neighbours:char='8') -> int :
    return 1 - get_number_objects(image,neighbours)  # For 1 object

# 7
def is_simply_connected(image:array,number_gaps:int=inf) -> bool :
    # If no number of gaps is provided it's verified the number
    if number_gaps == inf: number_gaps = get_number_gaps(image)
    return True if number_gaps <= 0 else False

def is_multiply_connected(image:array,number_gaps:int=-1) -> bool :
    if number_gaps < 0: number_gaps = get_number_gaps(image)
    return True if number_gaps > 0 else False

# 8
def directions_to_labels(direction_list:array,neighbouring_method:char='4'):
    return [(DIRECTIONS_4_NEIGHBOURS_LABELS if neighbouring_method == '4' else DIRECTIONS_8_NEIGHBOURS_LABELS)[index] for index,_ in direction_list]

def contour_direction(image:array, chain_code:list, neighbouring_method:char='4', intern_contour:bool=False):
    """Function that determines the direction of what the next step in the contour should be, given a 
    sub-array of an image(3x3x3) that is compare in order to identified the next posible directions
    (except the opposite) depending of the last direction evaluated

    Parameters
    ----------
    image : array
        Sub-array of the image(3x3x3) that will be compared to the directions mask and should correspond to the
        contour of the object
    
    chain_code : list
        List of the subsecuent directions taken along the contour of the object
    
    neighbouring_method(optional) : char
        Determines which method would be use{4-Neighbours,8-Neigbhousr}

    intern_contour(optional) : bool
        When dealing with a intern contour the image window it's colored-inverted so that it could be manage as
        the exterior contour and thus the functioning logic must not be changed

    Returns
    -------
    direction_identified : int
        Index of the direction matched with the sub-array given image
    
    direction_XY_step : tuple
        Tuple with the augment of each coordinate in the direction of the mask matched
    """
    image_window = copy(image)
    # If it's dealing with an intern contour then the windows color is inverted
    if intern_contour: image_window = bitwise_not(image_window)
    # Variables related to the neighbouring method
    directions_N_neighbours = DIRECTIONS_4_NEIGHBOURS if neighbouring_method == '4' else DIRECTIONS_8_NEIGHBOURS
    direction_XY_step = DIRECTION_XY_STEP_4 if neighbouring_method == '4' else DIRECTION_XY_STEP_8
    # Gets the index of the last direction
    last_direction = chain_code[-1]
    # Modifiable list of the bit-quad directions list
    directions_list = list(directions_N_neighbours)
    # The directions list gets modified so that the elements correspond to the order in wich each direction should be
    # checked for the next step, this according to the last direction identified.
    # The first element in the list is the next direction posible after last direction, the opposite direction is discarded
    # being replaced by the same last direction. The directions that were listed befored the last direction are appended
    # at the tail of the list
    if neighbouring_method == '4':
        directions_list = directions_list[last_direction:]+directions_list[:last_direction]
        directions_list[1] = directions_list.pop(0)
    elif neighbouring_method == '8':
        if last_direction == 0: directions_list = [directions_list.pop()]+directions_list
        else: directions_list = directions_list[last_direction-1:]+directions_list[:last_direction-1]
        directions_list[2:4] = [directions_list.pop(0),directions_list.pop(0)]
        if last_direction%2 == 0: # When the direction is pair, is 1 of the four conventional cardinal points and every pair of directions needs to be swap so the cardinal direction is first checked than the diagonal
            for i in range(3): directions_list.insert((2*i)+1,directions_list.pop(2*i))
    # Useful variables in loop
    index_matched = -1; direction_matched = False
    # Main loop that compares the order mask in the directions_list with the window image
    for index in range(len(directions_list)):
        direction_matched = array_equal(image_window*directions_list[index][1],EMPTY_MASK)
        if direction_matched: index_matched = index; break

    if not direction_matched: return -1,[]
    new_direction = directions_list[index_matched][0]
    # The new direction is added to the chain code list
    chain_code.append(new_direction)
    return new_direction,direction_XY_step[new_direction]

def choose_start_direction(image_window:array,neighbouring_method:char='4'):
    number_white_pixels = 0; direction = (2 if neighbouring_method == '4' else 4) # West
    for rows in image_window:
        for pixel in rows:
            if pixel.sum() == 765: number_white_pixels += 1
    n,m = image_window.shape[:2]
    mean_pixels = (n*m)/2
    if number_white_pixels < mean_pixels: direction = 0 # East
    return direction

def contour_already_colored(image_window:array, direction:str):
    if direction == 'East': 
        if image_window[1,-1].sum() == 255: return True
    elif direction == 'North-East':
        if image_window[0,-1].sum() == 255: return True
    elif direction == 'North':
        if image_window[0,1].sum() == 255: return True
    elif direction == 'North-West':
        if image_window[0,0].sum() == 255: return True
    elif direction == 'West':
        if image_window[1,0].sum() == 255: return True
    elif direction == 'South-West':
        if image_window[-1,0].sum() == 255: return True
    elif direction == 'South':
        if image_window[-1,1].sum() == 255: return True
    elif direction == 'South-East':
        if image_window[-1,-1].sum() == 255: return True
    elif direction == 'Center':
        if image_window[1,1].sum() == 255: return True
    return False

def save_new_contour(contours_chain_code:dict,position_start:tuple,chain_code:list):
    chain_code.pop(0) # The artificial first direction is removed
    contours_chain_code[position_start] = list(chain_code)

def highlight_contour(image:array, neighbouring_method:char='4',backend=None):
    """Method that highlights the contours of the objects depicted in the image
    A main loop it's used to find a match in the image with the mask #1 of the bit quad masks.
    When there is a match, a second loop executes running indefinite iterations in which using
    the contour_direction() method, the window 3x3x3 of the image takes one step and colors the
    pixel. This happens until the outline or internal contour of the object, its closed.
    Then, the chain code with the starting pixel position, is saved in a dictonary.
    Again the main loop keep running until findind another match in the mask, and the process
    repeats.
    When no more matches are found, the chain code with the initial positions as keys, and the
    chain code of the contour as value, are returned as a record of the path follow, and that
    could be used to highlight again the objects without computing this method again, but one
    less complex and computationally cheaper

    Parameters
    ----------
    image : array
        Image already thresholded in a binary image
    
    neighbouring_method(Optional) : char
        Method use to highlight the contour of the objects

    Returns
    -------
    contours_chain_code : dict
        Dictrionary with the chain codes of each found contour in the image
    
    image : array
        Image with the found contours already colored in red
    """
    if backend != None: backend.actionsStatus.emit(2,"Calculando el resaltado de los contornos")
    # Chain code of each object
    contours_chain_code = {}; window_position = array((-1,-1)); initial_position = array((0,0)); number_contour = 1
    n,m = image.shape[:2]
    # Variables related to the masks of each method
    directions_labels = DIRECTIONS_4_NEIGHBOURS_LABELS if neighbouring_method == '4' else DIRECTIONS_8_NEIGHBOURS_LABELS
    colored_neighbours = COLORED_4_NEIGHBOURS if neighbouring_method == '4' else COLORED_8_NEIGHBOURS
    colored_neighbours_inverted = COLORED_4_NEIGHBOURS_INVERTED if neighbouring_method == '4' else COLORED_8_NEIGHBOURS_INVERTED

    # Loop to find the bit-quad masks that match the image
    for x in range(m-1):
        for y in range(n-1):
            bit_quad_window = image[y:y+2,x:x+2]
            image_aux = copy(image)
            # First is verified if a window is just white pixels
            if array_equal(bit_quad_window,MASK_WHITE): pass
            else: # Then if it's not, if it matches with the first mask
                if array_equal(bit_quad_window,MASK_1): window_position = array((x,y))
                
                # Verifies there are some valid coordinates and starts the highlight of the contour
                if -1 not in window_position:
                    next_position = False
                    # The window it's located in the upper-left corner of the position of the matched mask
                    window_position = array((window_position[0]-1,window_position[1]-1),uint16)
                    initial_position = copy(window_position)
                    image_window = image_aux[window_position[1]:window_position[1]+3,window_position[0]:window_position[0]+3] # Window 3x3x3
                    
                    # Verifies that the center of the windows is not already colored
                    if not contour_already_colored(image_window,'Center'):
                        start_direction = choose_start_direction(image_window,neighbouring_method)
                        # The center gets colored when going to the west
                        if start_direction: image_aux[window_position[1]:window_position[1]+3,window_position[0]:window_position[0]+3] += colored_neighbours[-1]
                        # Assignment of key(name of object) and chain code initialized with the start direction
                        chain_code_aux = [start_direction]
                        
                        # Loop for the directions of all the pixels in the contour
                        # Will keep running until no valid direction is returned or the pixel to be evaluated is already colored
                        while not next_position:
                            image_window = image_aux[window_position[1]:window_position[1]+3,window_position[0]:window_position[0]+3]
                            # It's checked if the border has already being colored
                            # A pixel already colored sings that a contour object it's tried to be evaluated or the process has contoured the complete object
                            # Or if the distance of current window position to the initial position is 1 or 0
                            if contour_already_colored(image_window,directions_labels[chain_code_aux[-1]]):
                                if len(chain_code_aux) > 1: # A contour has been completely runned and closed
                                    save_new_contour(contours_chain_code,tuple(initial_position),chain_code_aux); number_contour += 1
                                    print('!!! Finished contour highlighted because a colored pixel was found !!!')
                                    if backend != None: backend.report_number_contourn_found(len(contours_chain_code.keys()))
                                next_position = True
                                window_position = array((-1,-1))
                                initial_position = array((0,0))
                                image = copy(image_aux)

                            elif absolute(window_position-initial_position).sum() in [0,1] and len(chain_code_aux) > 4:
                                print('!!! Finished contour highlighted by completely running it !!!')
                                save_new_contour(contours_chain_code,tuple(initial_position),chain_code_aux); number_contour += 1
                                if backend != None: backend.report_number_contourn_found(len(contours_chain_code.keys()))
                                next_position = True
                                window_position = array((-1,-1))
                                initial_position = array((0,0))
                                image = copy(image_aux)
                                
                            else:
                                # The next direction is acquired
                                # If the start direction it's East(0), then it's taken as an intern contour
                                direction,step = contour_direction(image_window,chain_code_aux, neighbouring_method, intern_contour=True if not start_direction else False)
                                if direction == -1: # No mask could match the window provided
                                    print('!!! No mask could match the window, trying again with the reverse direction !!!')
                                    # All parameters are reversed as if starting again
                                    window_position = copy(initial_position)
                                    image_aux = copy(image)
                                    start_direction = (2 if neighbouring_method == '4' else 4) if not start_direction else 0
                                    if start_direction: image_aux[window_position[1]:window_position[1]+3,window_position[0]:window_position[0]+3] += colored_neighbours[-1]
                                    chain_code_aux = [start_direction]
                                else:
                                    # The contour gets colored
                                    image_aux[window_position[1]:window_position[1]+3,window_position[0]:window_position[0]+3] += colored_neighbours_inverted[chain_code_aux[-1]] if not start_direction else colored_neighbours[chain_code_aux[-1]]
                                    # The window moves a step in the direction identified
                                    window_position += array(step,uint16)
    return contours_chain_code,image


#============
# Práctica 2
#============
# 1
def noise(noise_type:str,image,**kargs):
    list_keys = list(kargs)
    image = copy(image)

    if noise_type == "gaussian":
        #
        # https://www.programcreek.com/python/?code=ugent-korea%2Fpytorch-unet-segmentation%2Fpytorch-unet-segmentation-master%2Fsrc%2Fpre_processing.py
        #
        # Obtains the values of the mean and standard deviation
        mean = kargs['mean'] if 'mean' in list_keys else 0; std_deviation = kargs['std_deviation'] if 'std_deviation' in kargs.keys() else 0.1
        print('mean >>',mean,'  std deviation >>',std_deviation)
        # Creates the noise in a random manner according to the normal distribution with the given mean and standard deviation
        gauss = random.normal(mean,std_deviation,image.shape)
        # The noise gets added
        noisy_image = image + gauss
        # Rectifies that values an the upper and lower limit do not exceeds 0-255
        noisy_image[noisy_image > 255] = 255; noisy_image[noisy_image < 0] = 0
        return noisy_image.astype(uint8)
    elif noise_type == "s&p":
        #
        # https://blog.kyleingraham.com/2017/02/04/salt-pepper-noise-and-median-filters-part-ii-the-code/
        #
        l = 101 if 'l' not in list_keys else kargs['l']
        # Convert the image to 0 to 1 float to avoid wrapping that occurs with uint8
        image.astype(float16, copy = False)
        image = multiply(image, (1/255))
        # Generate noise to be added to the image
        noise = random.randint(l, size=image.shape)
        # Convert high and low bounds of l in noise to salt and pepper noise then add it to
        # our image. 1 is subtracted from l to match bounds behaviour of random.randint.
        image = where(noise == 0, 0, image)
        image = where(noise == (l-1), 1, image)
        # Properly handles the conversion from float16 back to uint8
        image = cv2.convertScaleAbs(image, alpha = (255/1))        
        return image

#2
def filtering(filter_type:str,image,n:int=3,**kargs):
    image = copy(image)

    if filter_type == 'mean':
        # Kernel creation
        #   Before applying any convolution with an image using a 2D matrix it's needed to ensure 
        #   all the values are normalize, thus the division of the matrix
        kernel = ones((n,n),float32)/(n**2)
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

#3
def contrast(image,alpha:float=1.5,beta:float=0):
    return cv2.convertScaleAbs(image,alpha=alpha,beta=beta)

#4
def round_overlapped_objects(image,threshold):
    # The distance transform requires the background to be black and as
    # a standard the objects are always black, thus the image gets the colors inverted
    aux_image = 255- copy(image[:,:,0])
    # The distance transformation is applied
    aux_image = cv2.distanceTransform(aux_image, cv2.DIST_L2, cv2.DIST_MASK_PRECISE)
    # As the result of the distance transformation is make in very small steps the resultant image must be normalized
    cv2.normalize(aux_image,aux_image,0.0,1.0,cv2.NORM_MINMAX)
    cv2.imshow('Distance Transformation',aux_image)
    # A threshold is applied
    _,aux_image = threshold_image(aux_image,threshold,1.0)
    # And normalized back to values between 0 and 255    
    cv2.normalize(aux_image,aux_image,0,255,cv2.NORM_MINMAX)
    # Before start counting the objects the image must be
    # reversed so the objects are black and the backgound white again
    aux_image = 255 - aux_image
    # cv2.imshow('Round objects identified',aux_image)
    return get_number_objects(aux_image)

#5
def morphological_operation(morph_op_type:str,image,n:int=3,spatial_structure:str='rect',**kargs):
    image = copy(image)
    structuring_element = cv2.getStructuringElement(cv2.MORPH_CROSS if spatial_structure == 'cross' else cv2.MORPH_RECT,(n,n))

    if morph_op_type == 'erosion':
        return cv2.erode(image,structuring_element)
    elif morph_op_type == 'dilation':
        return cv2.dilate(image,structuring_element)
    elif morph_op_type == 'closing':
        return cv2.morphologyEx(image,cv2.MORPH_CLOSE,structuring_element)
    elif morph_op_type == 'opening':
        return cv2.morphologyEx(image,cv2.MORPH_OPEN,structuring_element)

#6
def kapur_threshold(image):
    # Probability of each pixel value
    p,_ = histogram(image, bins=range(256), density=True)
    # Cumulative probabilities for C1 and C2
    c1 = p.cumsum(); c2 = 1.0 - c1
    # When the probabilities are 0 its changed to 1 so that it won't affect when used as divider
    c1[c1 <= 0] = 1; c2[c2 <= 0] = 1
    # Entropy of the image
    #   To avoid the case: ln(0)
    #   And as the entropy for each pixel values is p*ln(p)
    #   the values of p that are 0 are changed to 1 so when the entropy its
    #   applied the this pixel value won't affect the whole entropy
    #   ** The entropy of the whole image will be the last element of H_u
    p_1 = copy(p); p_1[p_1 == 0.0] = 1
    H_u = -(p_1*log(p_1)).cumsum()
    H_t = H_u[-1]
    # Functional
    #   Jk(u) = H_c1(u)+H_c2(u) = ln(c1*c2)+[H(u)/c1]+[(H_t-H(u))/c2]
    Jk = log(c1*c2)+(H_u/c1)+((H_t-H_u)/c2)
    return argmax(Jk)

def cheng_threshold(image):
    # Frecuency of each pixel value
    _,p = histogram_no_image(image)
    # The filter for reducing 0 gets applied
    p = mean_filter(p)
    # Probabilities of each pixel value
    p = p/p.sum()
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
    CT = -log(G*G_c) + 2*log(c1*c2)
    return argmax(CT)
def mean_filter(vector,filter_size:int=5):
    new_vector = copy(vector); side_elements = int(filter_size/2)
    zeros_in_vector = where(vector <= 0)[0]
    if zeros_in_vector.size > 0:
        for index in zeros_in_vector:
            elements_mean = array(range(index-side_elements,index+(filter_size-1-side_elements)))
            elements_mean = where(elements_mean >= vector.shape[0], elements_mean-vector.shape[0], elements_mean)
            new_vector[index] = ceil(mean(vector[elements_mean])) 
    return new_vector