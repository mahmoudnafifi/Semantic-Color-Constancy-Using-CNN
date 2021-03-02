# Semantic white balance: Semantic Color Constancy using Convolutional Neural Network (SCCCNN)

<p align="center">
  <img src="https://www.mathworks.com/matlabcentral/mlc-downloads/downloads/c869ba7c-7e9f-4a7f-8ea4-90a5bb94953f/33f9c6dc-845c-433d-b251-678bf2190a76/images/screenshot.jpg" width="65%"/>
  </p>


Note that color constancy using diagonal correction should be applied to the linear RAW image. Here, we did not use that because of the absence of semantic segmentation models for RAW images (just a proof of concept). Read the report for more information.

To generate semantic masks, you can download Refinenet from the following link:

https://github.com/guosheng/refinenet

Remember: you have to use the model trained on MIT ADE20K dataset (ResNet-152) for scene understanding

Download the semantic white balance network from the following link:
https://drive.google.com/open?id=0B6CktEG1p54WVVpyMlhOMjBjZk0


Because of the 4-D images, you are going to get an error states the following:
Error using imageInputLayer>iParseInputArguments (line 59)
The value of 'InputSize' is invalid. Expected input image size to be a 2 or 3 element vector. For a 3-element vector, the
third element must be 3 or 1.

To fix it,  do the following:
-Open Matlab  (run as administrator)
-Write:
`edit imageInputLayer.m`

-replace the following code:

```
function tf = iIsValidRGBImageSize(sz)
tf = numel(sz) == 3 && sz(end) == 3;
end
```

with the modified function:

```
function tf = iIsValidRGBImageSize(sz)
tf = numel(sz) == 3 && (sz(end) == 3 || sz(end) == 4);
end
```
-save 


You can read the report from here: https://arxiv.org/abs/1802.00153 

If you use this code, please cite it as: 

Mahmoud Afifi. "Semantic White Balance: Semantic Color Constancy Using Convolutional Neural Network." arXiv preprint arXiv:1802.00153 (2018). 

[![View Semantic-Color-Constancy-Using-CNN on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/64839-semantic-color-constancy-using-cnn)


### Related Research Projects
- sRGB Image White Balancing:
  - [When Color Constancy Goes Wrong](https://github.com/mahmoudnafifi/WB_sRGB): The first work for white-balancing camera-rendered sRGB images (CVPR 2019).
  - [White-Balance Augmenter](https://github.com/mahmoudnafifi/WB_color_augmenter): Emulating white-balance effects for color augmentation; it improves the accuracy of image classification and image semantic segmentation methods (ICCV 2019).
  - [Color Temperature Tuning](https://github.com/mahmoudnafifi/ColorTempTuning): A camera pipeline that allows accurate post-capture white-balance editing (CIC best paper award, 2019).
  - [Interactive White Balancing](https://github.com/mahmoudnafifi/Interactive_WB_correction): Interactive sRGB image white balancing using polynomial correction mapping (CIC 2020).
  - [Deep White-Balance Editing](https://github.com/mahmoudnafifi/Deep_White_Balance): A multi-task deep learning model for post-capture white-balance editing (CVPR 2020).
- Raw Image White Balancing:
  - [APAP Bias Correction](https://github.com/mahmoudnafifi/APAP-bias-correction-for-illumination-estimation-methods): A locally adaptive bias correction technique for illuminant estimation (JOSA A 2019).
  - [SIIE](https://github.com/mahmoudnafifi/SIIE): A sensor-independent deep learning framework for illumination estimation (BMVC 2019).
  - [C5](https://github.com/mahmoudnafifi/C5): A self-calibration method for cross-camera illuminant estimation (arXiv 2020).
- Image Enhancement:
  - [CIE XYZ Net](https://github.com/mahmoudnafifi/CIE_XYZ_NET): Image linearization for low-level computer vision tasks; e.g., denoising, deblurring, and image enhancement (arXiv 2020).
  - [Exposure Correction](https://github.com/mahmoudnafifi/Exposure_Correction): A coarse-to-fine deep learning model with adversarial training to correct badly-exposed photographs (CVPR 2021).
 - Image Manipulation:
    - [MPB](https://github.com/mahmoudnafifi/modified-Poisson-image-editing): Image blending using a two-stage Poisson blending (CVM 2016).
    - [Image Recoloring](https://github.com/mahmoudnafifi/Image_recoloring): A fully automated image recoloring with no target/reference images (Eurographics 2019).
    - [Image Relighting](https://github.com/mahmoudnafifi/image_relighting): Relighting using a uniformly-lit white-balanced version of input images (Runner-Up Award overall tracks of AIM 2020 challenge for image relighting, ECCV Workshops 2020). 
    - [HistoGAN](https://github.com/mahmoudnafifi/HistoGAN): Controlling colors of GAN-generated images based on features derived directly from color histograms (CVPR 2021). 
