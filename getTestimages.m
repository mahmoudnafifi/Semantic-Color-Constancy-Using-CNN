function [images]=getTestimages()
base='results';
input='input';
groundTruth='ground-truth';

Ifiles=dir(fullfile(base,input,'*.tiff'));
Gfiles=dir(fullfile(base,groundTruth,'*.png'));

for ind=1:length(Ifiles)
    filenameI=Ifiles(ind).name;
    filenameG=Gfiles(ind).name;
    images(ind).I=double(imread(fullfile(base,input,filenameI)));
  
    images(ind).gT=imread(fullfile(base,groundTruth,filenameG));
    images(ind).name=filenameG;
end

