function [RMSEI,RMSEP]=evaluateSCCNET(net, param, avg)

disp('Evaluate the model...');
disp('Get the validation data...');
base='../cnn_data/1';
validation='validation';
groundTruth='gt_validation';

Ifiles=dir(fullfile(base,validation,'*.tiff'));
Gfiles=dir(fullfile(base,groundTruth,'*.png'));
Gdata=dir(fullfile(base,groundTruth,'*.mat'));

result=zeros(param.szIn(1), param.szIn(2),3);

rmse_allimages_wg=0;
rmse_allimages_wog=0;
rmse_allparam=0;

rmse_nongammaimages=0;
rmse_rgbparam=0;

rmse_nongammaimages_gray=0;
rmse_rgbparam_gray=0;

numberOfImages=length(Ifiles);
numberOfNonGammaImages=0;
disp('Evaluation...');
for ind=1:length(Ifiles)
    if mod(ind,1000)==0
        disp(strcat(sprintf("%f ",ind/length(Ifiles)*100),'%'))
    end
    no_gamma=0;
    filenameI=Ifiles(ind).name;
    filenameG=Gfiles(ind).name;
    load(fullfile(base,groundTruth,Gdata(ind).name)); %g_truth
    if g_truth(4)==1 %no-gamma correction
        numberOfNonGammaImages=numberOfNonGammaImages+1;
        no_gamma=1;
    end
    I_=double(imread(fullfile(base,validation,filenameI)));
%      I_(:,:,4)=rand(size(I_(:,:,4)))*150;
    gt=imread(fullfile(base,groundTruth,filenameG));
    test=preprocessing_(I_,avg);
    I=I_(:,:,1:3);
    predicted = predict(net,test);
    rmse_allparam=rmse_allparam+sum(((predicted-g_truth).^2));
    
    result(:,:,1)=I(:,:,1)/predicted(1);
    result(:,:,2)=I(:,:,2)/predicted(2);
    result(:,:,3)=I(:,:,3)/predicted(3);
    rmse_allimages_wog=rmse_allimages_wog+(sum(((result(:)-I(:))/255).^2));
    result=min(((result/255).^(1/predicted(4)))*255,255);
    temp=(sum(((result(:)-I(:))/255).^2));
    rmse_allimages_wg=rmse_allimages_wg+temp;
    if no_gamma==1
        rmse_rgbparam=rmse_rgbparam+sum((predicted(1:3)-g_truth(1:3)).^2);
        rmse_nongammaimages=rmse_nongammaimages+temp;
        %grayworld
        [result,predicted_gray] = greyWorld(I(:,:,1:3));
        rmse_rgbparam_gray=rmse_rgbparam_gray+...
            sum((predicted_gray-g_truth(1:3).^2));
        rmse_nongammaimages_gray=rmse_nongammaimages_gray+...
            (sum(((result(:)-I(:))/255).^2));
    end
end

%normalization

rmse_allparam=sqrt(rmse_allparam/(4*numberOfImages));
rmse_rgbparam=sqrt(rmse_rgbparam/(3*numberOfNonGammaImages));
rmse_rgbparam_gray=sqrt(rmse_rgbparam_gray/(3*numberOfNonGammaImages));

rmse_allimages_wg=sqrt(rmse_allimages_wg/(numberOfImages* param.szIn(1)*...
    param.szIn(2)* param.szIn(3)));
rmse_allimages_wog=sqrt(rmse_allimages_wog/...
    (numberOfImages* param.szIn(1)*...
    param.szIn(2)* param.szIn(3)));

rmse_nongammaimages=sqrt(rmse_nongammaimages/...
    (numberOfNonGammaImages* param.szIn(1)*...
    param.szIn(2)* param.szIn(3)));

rmse_nongammaimages_gray=sqrt(rmse_nongammaimages_gray/...
    (numberOfNonGammaImages* param.szIn(1)*...
    param.szIn(2)* param.szIn(3)));

RMSEI.all_wg=rmse_allimages_wg;
RMSEI.all_wog=rmse_allimages_wog;
RMSEI.noGamma=rmse_nongammaimages;
RMSEI.gray=rmse_nongammaimages_gray;

RMSEP.all=rmse_allparam;
RMSEP.rgb=rmse_rgbparam;
RMSEP.gray=rmse_rgbparam_gray;
