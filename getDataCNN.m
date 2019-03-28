function [tbl] = getDataCNN(base,training,groundTruth)
%for regression!
%tbl: 1st col contains training images' names, 2->n cols repsonse data
%taken from groundTruth images.

data=imageDatastore(fullfile(base,training),'ReadFcn',@imread);
fileName=cell2mat(data.Files(1));
file=strrep(fileName,training,groundTruth);
sz=size(imread(file));
response=zeros(length(data.Files),sz(1)*sz(2)*sz(3));
for f=1:length(data.Files)
    fileName=cell2mat(data.Files(f));
    file=strrep(fileName,training,groundTruth);
    im=imread(file);
    response(f,:)=im(:)';
end
tbl=table([data.Files],response);
end