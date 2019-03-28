function showWeights(net, convNum)
net=alexnet;
layers=net.Layers;

switch convNum
    case 1
        i=2;
    case 2
        i=6;
    case 3
        i=10;
    case 4
        i=12;
    case 5
        i=14;
end
clear w
w=layers(i).Weights;
for d=1:size(w,3) %depth
    
    for r=1 : 10
        ind=randi([1,size(w,4)]);
        cur_w=w(:,:,d,ind);
        subplot(size(w,3),10,r+(d-1)*10); imshow(cur_w,[]);
    end
end

end