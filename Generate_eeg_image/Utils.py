from torch.utils.data.dataset import Dataset
from Utils_Bashivan import *
import torch
import scipy.io as sio
import numpy as np


class EEGImagesDataset(Dataset):
    def __init__(self, label, image):
        self.label = label
        self.Images = image
        
    def __len__(self):
        return len(self.label)
    
    def __getitem__(self, idx):
        if torch.is_tensor(idx):
            idx = idx.tolist()
        image = self.Images[idx]
        label = self.label[idx]
        sample = (image, label)
        
        return sample

def create_img(filepath,savepath):
    feats = sio.loadmat(filepath)['power_features']
    locs = sio.loadmat('Sample Data/locations32.mat')
    locs_3d = locs['locations32_1']
    locs_2d = []
    # Convert to 2D
    for e in locs_3d:
        locs_2d.append(azim_proj(e))
    images = np.array(gen_images(np.array(locs_2d), feats[:, :], 32, normalize=True))
    sio.savemat(savepath, {"img": images})
    print("Images Created and Save in channelimage2")