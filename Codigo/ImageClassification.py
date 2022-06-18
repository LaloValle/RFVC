import cv2
import pickle
from numpy import *
from pathlib import Path
import matplotlib.pyplot as plt
from matplotlib import projections
from matplotlib.text import Annotation
from mpl_toolkits.mplot3d.proj3d import proj_transform

class ImageClassifier():
    HORIZONTAL_SOBEL_KERNEL = array([[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]])

    def convolution(image, kernel, average=False, verbose=False):
        # The image with 3 channels is transformed into gray scale
        if len(image.shape) == 3:
            image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        
        image_row, image_col = image.shape
        kernel_row, kernel_col = kernel.shape

        output = zeros(image.shape)

        pad_height = int((kernel_row - 1) / 2)
        pad_width = int((kernel_col - 1) / 2)

        padded_image = zeros((image_row + (2 * pad_height), image_col + (2 * pad_width)))

        padded_image[pad_height:padded_image.shape[0] - pad_height, pad_width:padded_image.shape[1] - pad_width] = image

        for row in range(image_row):
            for col in range(image_col):
                output[row, col] = sum(kernel * padded_image[row:row + kernel_row, col:col + kernel_col])
                if average:
                    output[row, col] /= kernel.shape[0] * kernel.shape[1]
        return output
    
    def sobel_edge_detection(image, verbose=False):
        new_image_x = ImageClassifier.convolution(image, ImageClassifier.HORIZONTAL_SOBEL_KERNEL, verbose)
        new_image_y = ImageClassifier.convolution(image, flip(ImageClassifier.HORIZONTAL_SOBEL_KERNEL.T, axis=0), verbose)
        gradient_magnitude = sqrt(square(new_image_x) + square(new_image_y))
        return gradient_magnitude

    def load_dataset(path:Path):
        """Simple function that retrieves the data and splits them into data and class labels

        Returns
        -------
        dataset : list
            List with the data in n+1 columns, being the first just a nth0 feature valued as 1 for compute propouse
        
        labels : list
            List of the class labels

        images_names : list
            List of the images names located at the last column of each line
        """
        dataset = []; labels = []; images_names = [] 
        with open(path.as_posix(),'r') as test_file:
            for line in test_file.readlines():
                line_elements = line.strip().split()
                images_names.append(line_elements.pop()[1:])
                labels.append(int(line_elements.pop()))
                dataset.append([1.0]+list(map(float,line_elements)))
        return dataset,labels,images_names

    # Logistic Regression algorithm functions
    # Training phase algorithms
    def sigmoid(z):
        return 1.0/(1+exp(-z))

    def stochastic_gradient_ascent_1(dataset,class_labes,number_iterations=150):
        """Function that trains the model of the logistic regression using one instance at
        time during a determined number of cycles

        Parameters
        ----------
        dataset : list
            Vector or list with the values of the features+1(the 0th feature)
        
        class_labels : list
            List with the clases of each entry(0 or 1 value)

        Returns
        -------
        weights : matrix
            Matrix with dimensions(#_features+1) with the value of the weights
        """
        m,n = shape(dataset)
        weights = ones(n,float64)
        for j in range(number_iterations):
            data_index = range(m)
            for i in range(m):
                alpha = 4/(1.0+j+i)+0.01
                random_index = int(random.uniform(0,len(data_index)))
                h = ImageClassifier.sigmoid(sum(dataset[random_index]*weights))
                error = class_labes[random_index] - h
                weights = weights + alpha*error*dataset[random_index]
                delete(data_index,random_index)
        return weights

    # Classification algorithm
    def classify_logistic_regression(vector,weights):
        probability = ImageClassifier.sigmoid(sum(vector*weights))
        if probability > 0.5:
            return 1.0
        return 0.0
    
    # Storing/Restoring of the weights in a file
    def store_logreg_weights(input_weights:ndarray,filename:str):
        with open(filename,'wb') as file:
            pickle.dump(input_weights,file)

    def restore_logreg_weights(filename:str) -> ndarray :
        weights = {}
        with open(filename,'rb') as file:
            weights = pickle.load(file)
        return weights

    # Plotting functions
    def plotBestFit(weights,dataset_path:Path,vector=None):
        dataMat,labelMat,names=ImageClassifier.load_dataset(dataset_path)
        dataArr = array(dataMat)
        n = shape(dataArr)[0] 
        xcord1 = []; ycord1 = []; zcord1 = []
        xcord2 = []; ycord2 = []; zcord2 = []
        for i in range(n):
            if int(labelMat[i])== 1:
                xcord1.append(dataArr[i,1]); ycord1.append(dataArr[i,2]); zcord1.append(dataArr[i,3])
            else:
                xcord2.append(dataArr[i,1]); ycord2.append(dataArr[i,2]); zcord2.append(dataArr[i,3])
        fig = plt.figure()
        ax = plt.axes(projection='3d')
        ax.scatter(xcord1, ycord1, zcord1, s=30, c='red', marker='s')
        ax.scatter(xcord2, ycord2, zcord2, s=30, c='purple', marker='p')
        # Names of the images represented by each point
        for j, xyz_ in enumerate(zip(list(dataArr[:,1]),list(dataArr[:,2]),list(dataArr[:,3]))):
            ImageClassifier.annotate3D(ax, s=names[j], xyz=xyz_, fontsize=5, xytext=(-3,3),textcoords='offset points', ha='right',va='bottom')

        # Classifier Plane
        x = linspace(dataArr[:,1].min(),dataArr[:,1].max(),100)
        y = linspace(dataArr[:,2].min(),dataArr[:,2].max(),100)
        x,y = meshgrid(x,y)
        z = (weights[0]-weights[1]*x-weights[2]*y)/weights[3]
        surface = ax.plot_surface(x,y,z)
        
        ax.set_xlabel('SI Mean', fontweight ='bold')
        ax.set_ylabel('Ancho', fontweight ='bold')
        ax.set_zlabel('Alto', fontweight ='bold')

        # A new vector to be classified
        if type(vector) != type(None) : ax.scatter(vector[1], vector[2], vector[3], s=30, c='green', marker='D')

        plt.show()
        #https://www.geeksforgeeks.org/three-dimensional-plotting-in-python-using-matplotlib/
        #https://www.geeksforgeeks.org/3d-scatter-plotting-in-python-using-matplotlib/
        #https://datascience.stackexchange.com/questions/11430/how-to-annotate-labels-in-a-3d-matplotlib-scatter-plot
        #https://numpy.org/doc/stable/reference/generated/numpy.linspace.html
        #https://math.stackexchange.com/questions/404440/what-is-the-equation-for-a-3d-line
        #https://stackoverflow.com/questions/1642730/how-to-delete-columns-in-numpy-array
    
    def annotate3D(ax, s, *args, **kwargs):
        tag = Annotation3D(s, *args, **kwargs)
        ax.add_artist(tag)

class Annotation3D(Annotation):
    def __init__(self, s, xyz, *args, **kwargs):
        Annotation.__init__(self,s, xy=(0,0), *args, **kwargs)
        self._verts3d = xyz        

    def draw(self, renderer):
        xs3d, ys3d, zs3d = self._verts3d
        xs, ys, zs = proj_transform(xs3d, ys3d, zs3d, renderer.M)
        self.xy=(xs,ys)
        Annotation.draw(self, renderer)