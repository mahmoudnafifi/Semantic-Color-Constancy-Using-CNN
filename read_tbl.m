function [data,labels] = read_tbl(filename)

% This function reads a "tbl"-file - the data table file recorded (and encrypted)
% by the Lab-Volt data acquisition software...
%
% Use:
%
% [data,labels] = read_tbl(filename)
%
% filename specifies the "tbl"-file to be read
% data will contain the data entries from the file
% labels - strings containing channels' legends
%
% Copyleft by Gleb V. Tcheslavski, 2007, gleb@vt.edu

if ~exist(filename,'file')
  error(['Specified file ' filename ' does not exist in MATLAB path.']);
end

fid = fopen(filename);

fseek(fid,0,'bof');
header_string = cellstr(char(fread(fid,15,'10*char'))');

% analysis - need to determine the number of records first

ind = 128;
fseek(fid,ind,'bof');
a = fread(fid,1,'*char');
while a > 12
    ind = ind + 1;
    a = fread(fid,1,'*char');
end;
ind = ind + 1;
a = fread(fid,1,'*char');
while a > 12
    ind = ind + 1;
    a = fread(fid,1,'*char');
end;
d_count = 1;        %number of data entries - assume that at least one data entry exists
fcon = 1;
ind = ind + 36;             % pointer to the second "k"
while fcon == 1
    fseek(fid,ind,'bof');
    marker1 = fread(fid,1,'uint8');
    marker2 = fread(fid,1,'uint8');
    if marker1 == 0 & marker2 == 75
        fcon = 0;
    else
        d_count = d_count+1;
        ind = ind + 12;
    end
end;
if d_count == 0
  error('The specified file contains no data');
end

% retrieve file containt

ind = 122;                  % the file position indicator
data = [];        % out - stores an individual data column (data entries of the same type)
labels = [];                % stores the labels for the channels recorded
fcon = 1;                   % will be set to zero when all data is read

while fcon == 1
    fseek(fid,ind,'bof');
    marker1 = fread(fid,1,'uint8');
    marker2 = fread(fid,1,'uint8');
    if marker1 == 0 & marker2 == 75
        out = [];
        ind = ind + 6;
        fseek(fid,ind,'bof');
        units = [];
        a = fread(fid,1,'*char');
        while a > 12
            units = [units a];
            ind = ind + 1;
            a = fread(fid,1,'*char');
        end;
        ind = ind + 1;
        chann = [];
        a = fread(fid,1,'*char');
        while a > 12
            chann = [chann a];
            ind = ind + 1;
            a = fread(fid,1,'*char');
        end;
        labels = [labels cellstr([chann ', ' units])];  %updates the labels
        ind = ind+17;
            % start acqiring data entries
        for ind1 = 1:d_count
            fseek(fid,ind,'bof');
            aux = fread(fid,1,'float64');
            if abs(aux) < 10^(-150)
                aux = 0;
            end
            out = [out; aux];
            ind = ind + 12;
        end
        data = [data flipud(out)];
        ind = ind+7;
        
     else
        fcon = 0;
    end
end;

fclose(fid);