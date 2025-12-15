# PAM-Otsu-Segmentation

This repository provides a simple Otsu threshold–based segmentation implementation for photoacoustic microscopy (PAM) data acquired using a customized imaging system.

The code was used for image segmentation in the study:

**Dual-modal metabolic analysis reveals hypothermia-reversible uncoupling of oxidative phosphorylation in neonatal brain hypoxia-ischemia**

## Method
Segmentation is performed using the classical Otsu method to automatically determine an intensity threshold from PAM images.  
This implementation is intended for basic foreground–background separation and does not involve machine learning or model training.

## Data
The input data are photoacoustic microscopy (PAM) images collected with a customized experimental system.  
Due to data size and ethical considerations, raw imaging data are not included in this repository.

## Usage
The scripts can be adapted to process PAM image data in standard array or image formats.  
Users may modify file paths and parameters according to their own datasets.

## Purpose
This code is provided to support reproducibility of the segmentation procedure reported in the associated manuscript.  
It is not intended as a general-purpose or optimized segmentation framework.

## License
This repository is shared for academic and non-commercial research use.
