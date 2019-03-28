function [data]=preprocessing_(data,avg)
target_sz=[224,224,4];
if length(size(data))==4
    len=size(data,4);
    sample(:,:,:)=data(:,:,:,1);
else
    len=1;
    sample=data;
end
curr_sz=size(sample);
if curr_sz(1)~=target_sz(1) || curr_sz(2)~=target_sz(2) || curr_sz(3)~=target_sz(3)
    error('error in size');
end

%split the operation into multiple phases
ph=1; finished=0;
while ~finished
   if ph*1000> size(data,4)
       finished=1;
       range=[1+(ph-1)*1000:size(data,4)];
   else
       range=[1+(ph-1)*1000:ph*1000];
   end
   data(:,:,1:3,range)=data(:,:,1:3,range)-avg(:,:,1:3);
   ph=ph+1;
end
end