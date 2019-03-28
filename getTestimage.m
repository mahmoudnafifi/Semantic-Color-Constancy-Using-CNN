function [I,gT]=getTestimage(rand)
if nargin==0
    base='../cnn_data/1/';
    direc='validation';
    baseG='../cnn_data/1/gt_';
    filename='ADE_val_00000001_4.tiff';
    gt_filename=strcat(filename(1:end-4),'png');
    I=double(imread(fullfile(strcat(base,direc),filename)));
    gT=imread(fullfile(strcat(baseG,direc),gt_filename));
    
    
elseif strcmp(rand,'rand') %get four random images
    base='../cnn_data/1/';
    direc='validation'; %validation
    baseG='../cnn_data/1/gt_';
    files=dir(fullfile(strcat(base,direc),'*.tiff'));
    ind=randi([1 length(files)]);
    
    filename=files(ind).name;
    gt_filename=strcat(filename(1:end-4),'png');
    I=double(imread(fullfile(strcat(base,direc),filename)));
    gT=imread(fullfile(strcat(baseG,direc),gt_filename));
    
    
else
    error('undefined setting, use rand instead!');
end