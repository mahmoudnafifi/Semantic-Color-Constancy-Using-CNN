%Demo
I=double(imread('input_1.png'));
M=(imread('mask_1.png')); 
if size(M,3)==3
    M = rgb2gray(M); 
end
G=imread('target_1.png');
I_=zeros(224,224,4);
result=zeros(size(I));
I_(:,:,1:3)=imresize(I,[224,224],'nearest');
I_(:,:,4)=imresize(M,[224,224],'nearest');

load('net.mat');
load('avgimg.mat');

I_=preprocessing_(I_,avgimg);
predicted = predict(net,I_);
result(:,:,1)=I(:,:,1)./predicted(1);
result(:,:,2)=I(:,:,2)./predicted(2);
result(:,:,3)=I(:,:,3)./predicted(3);
imwrite(uint8(result),'result_wogamma.png');
subplot(1,4,1); imshow(uint8(I)); title('input','FontSize', 20);
subplot(1,4,2); imshow(uint8(result)); title('results w/o gamma', 'FontSize', 20);
result=min(((result/255).^(1/predicted(4)))*255,255);
imwrite(uint8(result),'result_wgamma.png');
subplot(1,4,3); imshow(uint8(result)); title('results w gamma', 'FontSize', 20);
subplot(1,4,4); imshow(G); title('ground-truth', 'FontSize', 20);
