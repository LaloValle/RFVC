import cv2
from numpy import *
from Images import *
from pathlib import Path
from ImageClassification import *

from PySide6.QtCore import QObject, Slot, Signal, QRunnable, QThreadPool

class Backend(QObject):

    backend_instance = None

    def __init__(self):
        QObject.__init__(self)

        self.image_path = ''
        self.image = []
        self.neighbour_method = '8'
        self.number_gaps = inf

        self.threadpool = QThreadPool()

        self.logreg_weights = ImageClassifier.restore_logreg_weights('Logreg_weights.dat')

        Backend.backend_instance = self

    # Signals with the interface
    pixelColor = Signal(int,int,int)
    pixelGrayscale = Signal(int)
    newImagePath = Signal(str,str)  # Name and path
    newPlotHistogram = Signal(str,str)
    actionsStatus = Signal(int,str)

    def get_backend():
        if Backend.backend_instance == None: Backend.backend_instance = Backend()
        return Backend.backend_instance

    #============
    # Práctica 1
    #============
    # Slots
    @Slot(str)
    def open_image(self,image_path:str):
        try:
            self.image_path = Path(image_path)
            self.image = cv2.imread(image_path)
            
            print('<--- Image sucessufully opened --->')
            self.actionsStatus.emit(1,'Imagen abierta')
        except e:
            print('!!! There\'s been a problem triying to open the image !!!')
            print(e)
            self.actionStatus.emit(-1,'La imagen no se abrió')

    @Slot()
    def close_image(self):
        if type(self.image) != list: print('<--- Closing image --->')
        self.image_path = ''
        self.image = []
        self.number_gaps = inf

    @Slot(int,int)
    def get_pixel_color(self,x:int,y:int):
        pixel = get_pixel(self.image,x,y)
        if type(pixel) == uint8: self.pixelGrayscale.emit(pixel)
        elif type(pixel) == ndarray: self.pixelColor.emit(pixel[2],pixel[1],pixel[0])

    @Slot()
    def image_to_grayscale(self):
        try:
            self.write_new_image( grayscale_image(self.image),'grayscale' )

            print('<--- Image sucessufully converted in grayscale --->')
            self.actionsStatus.emit(1,'Imagen convertida a niveles de gris')
        except e:
            print('!!! There\'s been a problem triying to transform the image !!!')
            self.actionsStatus.emit(-1,'No se pudo convertir la imagen')

    @Slot(int)
    def threshold_the_image(self,threshold:int):
        try:
            tr,thresholded_image = threshold_image(self.image,threshold)
            self.write_new_image( thresholded_image,'threshold_{}'.format(threshold) )

            print('<--- Image sucessufully thresholded into binary values --->')
            self.actionsStatus.emit(1,'Imagen binarizada con un umbral de {}'.format(tr))
        except e:
            print('!!! There\'s been a problem triying to binarize the image({}) !!!'.format(e))
            self.actionsStatus.emit(-1,'No se pudo binarizar la imagen')

    @Slot()
    def get_image_histogram(self):
        histogram_path = image_of_histogram(self.image,title='Histograma de la imagen \'\''.format(self.image_path.stem),image_name=self.image_path.stem)
        self.actionsStatus.emit(1,'Mostrando el histograma')
        self.newPlotHistogram.emit(histogram_path.stem,histogram_path.as_posix())

    @Slot()
    def get_image_number_objects(self):
        thread = ImageThreading(Backend.thread_count_objects)
        self.threadpool.start(thread)

    @Slot()
    def get_image_number_gaps(self):
        try:
            gaps = get_number_gaps(self.image,self.neighbour_method)

            self.number_gaps = gaps
            print('<--- {} gaps identified --->'.format(gaps))
            if gaps == 0: self.actionsStatus.emit(1,'No se identificaron agujeros'.format(gaps))
            else: self.actionsStatus.emit(1,'{} agujeros identificados'.format(gaps))
        except:
            print('!!! There\'s been a problem triyin to identified the number of gaps !!!')
            self.actionsStatus.emit(-1,'No se contabilizaron los agujeros')
    
    @Slot()
    def get_image_connection(self):
        try:
            self.actionsStatus.emit(2,"Calculando el tipo de conexión")

            simply_connected = is_simply_connected(self.image,self.number_gaps)
            multiply_connected = is_multiply_connected(self.image,self.number_gaps)
            connected_string = 'Simplemente conectada' if simply_connected else ('Multiplemente conectada' if multiply_connected else '')

            if connected_string:
                print('<--- The image has been identified as {} --->'.format(connected_string))
                self.actionsStatus.emit(1,'Identificada como {}'.format(connected_string))
            else:
                print('<--- No type of connection was identified --->')
                self.actionsStatus.emit(1,'No se identificó el tipo de conexión')
        except:
            print('!!! There\'s been a problem triyin to identified the number of gaps !!!')
            self.actionsStatus.emit(-1,'No se contabilizaron los agujeros')
    @Slot()
    def get_image_highlighted(self):
        thread = ImageThreading(Backend.thread_function_highlight_contour)
        self.threadpool.start(thread)

    @Slot()
    def classify_image(self):
        thread = ImageThreading(Backend.thread_function_SI_mean,copy(self.image))
        self.threadpool.start(thread)

    #============
    # Práctica 2
    #============
    @Slot()
    def invert_image(self):
        try:
            self.write_new_image( cv2.bitwise_not(self.image), 'inverted' )

            print('<--- Image inverted --->')
            self.actionsStatus.emit(1,'Imagen invertida exitosamente')
        except e:
            print('!!! There\'s been a problem triying to invert the image colors !!!')
            self.actionsStatus.emit(-1,'No se pudo invertir los colores de la imagen')

    @Slot(int)
    def salt_pepper_noise(self,l):
        try:
            self.write_new_image( noise('s&p',self.image,l=l),'s&p' )

            print('<--- Salt and Pepper noise added --->')
            self.actionsStatus.emit(1,'Ruido tipo Sal y Pimienta aplicado')
        except e:
            print('!!! There\'s been a problem triying to add salt and pepper noise to the image !!!')
            self.actionsStatus.emit(-1,'No se le pudo agregar ruido a la imagen')

    @Slot(int,int)
    def gaussian_noise(self,mean,std_deviation):
        try:
            self.write_new_image( noise('gaussian',self.image,mean=mean,std_deviation=std_deviation),'gaussian_noise' )

            print('<--- Gaussian noise added --->')
            self.actionsStatus.emit(1,'Ruido tipo Gausiano aplicado')
        except e:
            print('!!! There\'s been a problem triying to add Gaussian noise to the image !!!')
            self.actionsStatus.emit(-1,'No se le pudo agregar ruido a la imagen')

    @Slot(str,int,int)
    def filter_image(self,type,kernel_size,std_deviation):
        try:
            self.write_new_image( filtering(type,self.image,kernel_size,std_deviation=std_deviation), type )

            print('<--- Filter type({}) applied to the image --->'.format(type))
            self.actionsStatus.emit(1,'Filtro tipo \'{}\' aplicado'.format(type))
        except e:
            print('!!! There\'s been a problemn trying to apply the filter to the image !!!')
            self.actionsStatus.emit(-1,'No se pudo realizar el filtrado a la imagen')
    
    @Slot(str,int)
    def apply_morph_op(self,type,kernel_size):
        try:
            self.write_new_image( morphological_operation(type,self.image,kernel_size), type )

            print('<--- Morphological operation type({}) applied to the image --->'.format(type))
            self.actionsStatus.emit(1,'Operación morfológica tipo \'{}\' aplicada'.format(type))
        except e:
            print('!!! There\'s been a problem trying to apply the morphological operation to the image !!!')
            self.actionsStatus.emit(-1,'No se pudo realizar la operación morfológica a la imagen')

    @Slot(int)
    def count_round_overlapped_objects(self,threshold:int):
        try:
            self.actionsStatus.emit(1,'Computing the number of round objects')
            number_objects = round_overlapped_objects(self.image,float(threshold/10))

            print('<--- Number of round overlapped: {} --->'.format(number_objects))
            self.actionsStatus.emit(1,'Found {} round objects'.format(number_objects))
        except e:
            print('!!! There\'s been a problem trying to count the number of round objects !!!')
            self.actionsStatus.emit(-1,'No se pudo realizar la contabilización de objetos redondos')

    @Slot(str)
    def automatic_thresholding(self,type:str):
        try:
            tr,image = threshold_image(self.image,(kapur_threshold(self.image) if type == 'kapur' else cheng_threshold(self.image)))
            self.write_new_image( image, type )

            print('<--- The threshold found for {} is {}  --->'.format(type,tr))
            self.actionsStatus.emit(1,'El umbra con el método {} fue {}'.format(type,tr))
        except e:
            print('!!! There\'s been a problem trying found the {} threshold !!!')
            self.actionsStatus.emit(-1,'No se pudo realizar la operación para el umbral de {}'.format(type))

    @Slot(float,float)
    def apply_contrast(self,alpha,beta):
        try:
            self.write_new_image( contrast(self.image,alpha,beta), 'contrast' )

            print('<--- Contrast applied to the image --->'.format(type))
            self.actionsStatus.emit(1,'El contraste se aplicó a la imagen')
        except e:
            print('!!! There\'s been a problem trying to apply the contrast to the image !!!')
            self.actionsStatus.emit(-1,'No se pudo realizar el contraste en la imagen')


    # Thread functions
    def thread_count_objects():
        backend = Backend.get_backend()
        try:
            objects = get_number_objects(backend.image,backend.neighbour_method)

            print('<--- {} objects identified --->'.format(objects))
            if objects == 0: backend.actionsStatus.emit(1,'No se identificaron objetos'.format(objects))
            else: backend.actionsStatus.emit(1,'{} objetos identificados'.format(objects))
        except:
            print('!!! There\'s been a problem triyin to identified the number of objects !!!')
            backend.actionsStatus.emit(-1,'No se contabilizaron los objetos')

    def thread_function_highlight_contour():
        backend = Backend.get_backend()
        try:
            chain_codes,highligted_image = highlight_contour(backend.image,backend.neighbour_method,backend)

            print('<--- {} contours found --->'.format(len(chain_codes.keys())))
            backend.actionsStatus.emit(1,'Se encontraron {} contornos'.format(len(chain_codes.keys())))

            backend.write_new_image(highligted_image,'highlight')
        except:
            print('<--- The image couldn\'t be highlighted --->')
            backend.actionsStatus.emit(-1,"No se resalto los contornos")

    def thread_function_SI_mean(image):
        backend = Backend.get_backend()
        backend.actionsStatus.emit(2,'Calculando SI Mean')

        sobel_operator_image = ImageClassifier.sobel_edge_detection(image)
        height,width = sobel_operator_image.shape
        image_complexity = sobel_operator_image.sum()/(width*height)
        
        print('<--- SI Mean = {} --->'.format(image_complexity))

        image_vector = array([1.0,image_complexity,width,height])
        image_class = ImageClassifier.classify_logistic_regression(image_vector,backend.logreg_weights)
        backend.actionsStatus.emit(0,'Imagen clasificada como {}({}) con un SI Mean: {}'.format('sencilla' if image_class else 'compleja', image_class, image_complexity))
    
    def thread_count_round_overlapped_objects(threshold):
        backend = Backend.get_backend()
        try:
            backend.actionsStatus.emit(1,'Computing the number of round objects')
            number_objects = round_overlapped_objects(backend.image,float(threshold/10))

            print('<--- Number of round overlapped: {} --->'.format(number_objects))
            backend.actionsStatus.emit(1,'Found {} round objects'.format(number_objects))
        except e:
            print('!!! There\'s been a problem trying to count the number of round objects !!!')
            backend.actionsStatus.emit(-1,'No se pudo realizar la contabilización de objetos redondos')


    # Auxiliar methods
    def write_new_image(self,new_image,action:str):
        new_path = Path.cwd()/'.images/{}{}'.format(self.image_path.stem+'_'+action,self.image_path.suffix)

        cv2.imwrite(new_path.as_posix(),new_image)
        self.image = None
        self.image = copy(new_image)
        self.image_path = new_path
        
        self.newImagePath.emit(self.image_path.name,self.image_path.parent.as_posix())

    def report_number_contourn_found(self,number:int):
        self.actionsStatus.emit(0,'{} contornos han sido identificados ...'.format(number))

class ImageThreading(QRunnable):

    def __init__(self,*args,**kwargs):
        super().__init__()
        self.thread_function = args[0]
        self.thread_function_parameters = args[1:] if len(args) > 1 else []
        self.kwargs = kwargs

    @Slot()
    def run(self):
        if self.thread_function_parameters: self.thread_function(self.thread_function_parameters[0])
        else: self.thread_function()