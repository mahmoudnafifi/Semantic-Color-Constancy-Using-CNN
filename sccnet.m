function net=sccnwet(checkpoint_,checkpoint_file)
close all
clc
%% Remove the comments from the following if you want to re-train the network (be careful, you need to generate the training data in 4D TIFF format).
% %% Checks
% if nargin>2
%     error('Too much inputs');
% elseif nargin==0
%     checkpoint_=0;
% elseif nargin==1
%     error('Too few inputs');
% end
% 
% %% Load check points (if required)
% if checkpoint_==1
%     disp('Loading check point...');
%     options = getTrainingOption();
%     load(fullfile(options.CheckpointPath,checkpoint_file))
%     layers=net.Layers;
% end
% 
%% Here, you want to locate all training images in the path specified in line 44
% %% Training options
% options = getTrainingOption();
% if exist(options.CheckpointPath,'dir')==0
%     mkdir(options.CheckpointPath)
% end
% 
% %% CNN parameters
% disp('Loading parameters...');
% [param] = getCNNParameter;
% 
% %% CNN Architecture
% 
% %load check point (if required)
% if checkpoint_~=1
%     disp('Build the network...');
%     layers=getCNN_alex(param);
% end
% 
% 
% %% Load training data
% disp('Loading training data...');
% [t,r,avgimg]=getData_('../cnn_data/1','training','GT_training'); %load data
% 
% %% Preprocessing
% disp('Processing training data...');
% t=preprocessing_(t,avgimg); %pre-processing (zerocenters)
% 
% %% Training
% disp('Start training...');
% net = trainNetwork(t,r,layers,options);

% Save model
% disp('Saving the trained CNN model...');
% save('net.mat','net');
% save('param.mat','param');
% save('avgimg.mat','avgimg');


% loading the network
load('net.mat');
load('param.mat');
load('avgimg.mat');

% Testing
% get 40 random images
% resF='.\results\result_rand';
% disp('Testing using 40 random images...');
% for i_=1:10
%     h=figure('units','normalized','outerposition',[0 0 1 1]);
%     for fig=1:4
%         [img,gt_img]=getTestimage('rand'); %[images,masks]=getTestimages (in the future)
%         result=zeros(param.szIn(1), param.szIn(2),3);
%         test=preprocessing_(img,avgimg);
%         predicted = predict(net,test);
%         result(:,:,1)=img(:,:,1)/predicted(1);
%         result(:,:,2)=img(:,:,2)/predicted(2);
%         result(:,:,3)=img(:,:,3)/predicted(3);
%         subplot(4,4,1+4*(fig-1)); imshow(uint8(img(:,:,1:3))); if fig==1 title('input','FontSize', 20); end
%         subplot(4,4,2+4*(fig-1)); imshow(uint8(result)); if fig==1 title('results w/o gamma', 'FontSize', 20); end
%         result=min(((result/255).^(1/predicted(4)))*255,255);
%         subplot(4,4,3+4*(fig-1)); imshow(uint8(result)); if fig==1 title('results w gamma', 'FontSize', 20); end
%         subplot(4,4,4+4*(fig-1)); imshow(gt_img); if fig==1 title('ground-truth', 'FontSize', 20); end
%     end
%     print(fullfile(resF,strcat(num2str(sum(clock)),'.png')),'-dpng');
%     close(h);
% end

% testing using a set of images
resF='.\results\results';
disp('Testing using a set of input images...');
imgs=getTestimages();
for i_=1:length(imgs)
    figure('units','normalized','outerposition',[0 0 1 1]);
    curr_name=imgs(i_).name;
    sz_=size(imgs(i_).I);
    result=zeros(sz_(1), sz_(2),3);
    test=preprocessing_(imgs(i_).I,avgimg);
    predicted = predict(net,test);
    result(:,:,1)=imgs(i_).I(:,:,1)/predicted(1);
    result(:,:,2)=imgs(i_).I(:,:,2)/predicted(2);
    result(:,:,3)=imgs(i_).I(:,:,3)/predicted(3);
    imwrite(uint8(result),fullfile(resF,strcat(curr_name(1:end-4),'_wogamma.png')));
    subplot(1,4,1); imshow(uint8(imgs(i_).I(:,:,1:3))); title('input','FontSize', 20);
    subplot(1,4,2); imshow(uint8(result)); title('results w/o gamma', 'FontSize', 20);
    result=min(((result/255).^(1/predicted(4)))*255,255);
    imwrite(uint8(result),fullfile(resF,strcat(curr_name(1:end-4),'_wgamma.png')));
    subplot(1,4,3); imshow(uint8(result)); title('results w gamma', 'FontSize', 20);
    subplot(1,4,4); imshow(imgs(i_).gT); title('ground-truth', 'FontSize', 20);
end

% Test using wrong mask
sz=param.szIn;
image1_path='ADE_val_00000074_6.tiff';
im1 = double(imread(image1_path));
im2 = im1; im2(:,:,4)=rand(size(im2(:,:,4)))*150;
im1=imresize(im1,[sz(1),sz(2)]);
im2=imresize(im2,[sz(1),sz(2)]);
if size(im1,3)~=4 || size(im2,3)~=4
    error('use 4D images -> RGBM');
end
% show them
figure;
subplot(221);
imshow(im1(:,:,1:3)/255,[]); title('Image 1 (RGB)');
subplot(222);
imshow(im1(:,:,4)/255,[]); title('Image 1 (mask)');
subplot(223);
imshow(im2(:,:,1:3)/255,[]); title('Image 2 (RGB)');
subplot(224);
imshow(im2(:,:,4)/255,[]); title('Image 2 (mask)');
print('test images.png','-dpng');

figure('units','normalized','outerposition',[0 0 1 1]);
test1=preprocessing_(im1,avgimg);
result=zeros(sz(1), sz(2),3);
test1=preprocessing_(test1,avgimg);
predicted1 = predict(net,test1);
result(:,:,1)=im1(:,:,1)/predicted1(1);
result(:,:,2)=im1(:,:,2)/predicted1(2);
result(:,:,3)=im1(:,:,3)/predicted1(3);
subplot(1,3,1); imshow(uint8(im1(:,:,1:3))); title('input','FontSize', 20);
subplot(1,3,2); imshow(uint8(result)); title('results w/o gamma', 'FontSize', 20);
result=min(((result/255).^(1/predicted1(4)))*255,255);
subplot(1,3,3); imshow(uint8(result)); title('results w gamma', 'FontSize', 20);
print('results with mask.png','-dpng');


figure('units','normalized','outerposition',[0 0 1 1]);
test2=preprocessing_(im2,avgimg);
result=zeros(sz(1), sz(2),3);
test2=preprocessing_(test2,avgimg);
predicted2 = predict(net,test2);
result(:,:,1)=im2(:,:,1)/predicted2(1);
result(:,:,2)=im2(:,:,2)/predicted2(2);
result(:,:,3)=im2(:,:,3)/predicted2(3);
subplot(1,3,1); imshow(uint8(im2(:,:,1:3))); title('input','FontSize', 20);
subplot(1,3,2); imshow(uint8(result)); title('results w/o gamma', 'FontSize', 20);
result=min(((result/255).^(1/predicted2(4)))*255,255);
subplot(1,3,3); imshow(uint8(result)); title('results w gamma', 'FontSize', 20);
print('results with a wrong mask.png','-dpng');

% % evaluation
%% Here, you want to locate all validation images in a directory named "validation" in the path specificed in "base" variable in evaluateSCCNET function
% [RMSEI,RMSEP]=evaluateSCCNET(net, param, avgimg);
% RMSEI
% RMSEP
% % visaulization
% showWeights(net,1);
% disp('Visualizing the learned features...');
% visualize_features(net);
% disp('Visualizing the activations the CNN...');
% visualize_activations(net);
end


