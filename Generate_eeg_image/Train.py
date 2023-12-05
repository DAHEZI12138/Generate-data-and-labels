import numpy as np
import torch
import os
from Utils import *

names = [] #file names of the EEG power features
for name in names:
    filepath = filepath0 + '/' + name #path of EEG power features
    savepath = savepath0 + '/' + name #save path of EEG image
    create_img(filepath, savepath)

