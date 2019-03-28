function [trainingD,responseD,avgimg] = ...
    getData_(base,training,response)
%for regression!
%avgimg -> avgerage image to be used in the pre-processing step 

tPath=fullfile(base,training);
rPath=fullfile(base,response);
Tdata=dir(fullfile(tPath,'*.tiff'));
Rdata=dir(fullfile(rPath,'*.mat'));

L=min(length(Tdata),1000);

fileName=fullfile(tPath,Tdata(1).name);
I=imread(fileName); %load I
szT=size(I);
fileName=fullfile(rPath,Rdata(1).name); %we assume response files have the same names
load(fileName) %load g_truth
szR=size(g_truth);
trainingD=zeros(szT(1),szT(2),szT(3),L);
%responseD=zeros(szR(1),szR(2),szR(3),length(Tdata));
responseD=zeros(L,szR(1)*szR(2));
avgimg=zeros(szT(1),szT(2),szT(3));
for f=1:L
    fileNameT=fullfile(tPath,Tdata(f).name);
    fileNameR=fullfile(rPath,Rdata(f).name);
    I=double(imread(fileNameT)); %load I
    avgimg=avgimg+I;
    trainingD(:,:,:,f)=I;
    load(fileNameR); %load g_truth
    responseD(f,:)=g_truth;
end
avgimg=avgimg/L; %get avg image
end