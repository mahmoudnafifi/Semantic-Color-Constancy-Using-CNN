# Semantic white balance: Semantic Color Constancy using Convolutional Neural Network (SCCCNN)

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

@article{afifi2018semantic , 
title={Semantic White Balance: Semantic Color Constancy Using Convolutional Neural Network}, 
author={Afifi, Mahmoud}, 
journal={arXiv preprint arXiv:1802.00153}, 
year={2018} 
}
