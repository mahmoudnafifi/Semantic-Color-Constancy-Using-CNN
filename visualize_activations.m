function visualize_activations( net )

%load test image
sz=[224,224,4];
image1_path='ADE_val_00000074_6.tiff';
im1 = imread(image1_path);
im2 = im1; im2(:,:,4)=50;
im1=imresize(im1,[sz(1),sz(2)]);
im2=imresize(im2,[sz(1),sz(2)]);
if size(im1,3)~=4 || size(im2,3)~=4
error('use 4D images -> RGBM');
end
%show them
figure;
subplot(221);
imshow(im1(:,:,1:3)); title('Image 1 (RGB)');
subplot(222);
imshow(im1(:,:,4),[]); title('Image 1 (mask)');
subplot(223);
imshow(im2(:,:,1:3)); title('Image 2 (RGB)');
subplot(224);
imshow(im2(:,:,4),[]); title('Image 2 (mask)');
print('test images.png','-dpng');


act1 = activations(net,im1,'conv1','OutputAs','channels');
sz = size(act1);
act1 = reshape(act1,[sz(1) sz(2) 1 sz(3)]);
figure;
montage(mat2gray(act1),'Size',[8 12])
title('conv1 Activation (image1)');
print('conv1 Activation (image1).png','-dpng');

act1 = activations(net,im2,'conv1','OutputAs','channels');
act1 = reshape(act1,[sz(1) sz(2) 1 sz(3)]);
figure;
montage(mat2gray(act1),'Size',[8 12])
title('conv1 Activation (image2)');
print('conv1 Activation (image2).png','-dpng');

act5 = activations(net,im1,'conv5','OutputAs','channels');
sz = size(act5);
act5 = reshape(act5,[sz(1) sz(2) 1 sz(3)]);
figure;
montage(imresize(mat2gray(act5),[48 48]))
title('conv5 Activation (image1)');
print('conv5 Activation (image1).png','-dpng');

act5 = activations(net,im2,'conv5','OutputAs','channels');
sz = size(act5);
act5 = reshape(act5,[sz(1) sz(2) 1 sz(3)]);
figure;
montage(imresize(mat2gray(act5),[48 48]))
title('conv5 Activation (image2)');
print('conv5 Activation (image2).png','-dpng');

end

