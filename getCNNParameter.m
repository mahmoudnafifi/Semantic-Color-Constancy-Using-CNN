function [param] = getCNNParameter


param.szIn=[224 224 4];
param.szOut=[1,4];
param.DataAugmentation='none'; %'randcrop' | 'randfliplr' | cell array of 'randcrop' and 'randfliplr'
param.Normalization='none'; %'none' 'zerocenter'
param.WeightLearnRateFactor=50;
param.BiasLearnRateFactor=50;
param.WeightL2Factor=0.8;

end

