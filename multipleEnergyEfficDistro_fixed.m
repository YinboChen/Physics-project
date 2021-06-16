function singleMatrix = oneEnergyEfficDistro(file_name)
%Auther:Yinbo Chen
%Superviser: Hong Zhao
%Date: 6/10/2021
tic
clc;
clear;

%input txt
%file_name = file_name;
%file_name = "outputSingleRun_Electron_Ene_7.0_1000000.txt";
file_name ="outputSingleRun_Electron_Ene_3.7_10000.txt";

% set up the energy channels size is 32 x 2
energy_channels = [
    1,1.1;1.1,1.2;1.2,1.3;1.3,1.4;1.4,1.5;
    1.5,1.6;1.6,1.7;1.7,1.8;1.8,1.9;1.9,2;
    2,2.1;2.1,2.21;2.21,2.32;2.32,2.44;2.44,2.56;
    2.56,2.69;2.69,2.83;
    2.83,2.97;2.97,3.12;3.12,3.28;3.28,3.45;3.45,3.62;3.62,3.81;3.81,4;
    4,4.2;4.2,4.5;4.5,4.8;4.8,5.2;5.2,5.6;5.6,6;6,6.5;6.5,7];
size(energy_channels)

%initial output 32*1 array with name singleMatrix
singleMatrix = zeros(size(energy_channels, 1),1);


%recognize the paticle energy level from file name, only works when file
%name has 3.8_10 format number.
%3.8 is energy; 10 is beam number
token = str2double(split(regexp(file_name, '\d+\.\d+\_\d+', 'match', 'once'),"_"));
energy_beam = token(1);
beam_number = token(2);

%real particle number from data file
realCount_number = linecount(file_name);

%check point if equal build array
equalOrNot = checkParticaleNum(beam_number,realCount_number);

Z = prepareDataArray(file_name,beam_number,equalOrNot);

goodArray =goodBeam(Z);
goodOneColArray = sum1to16layers(goodArray);

output_final=compareToEnergyChannels(goodOneColArray,energy_channels,beam_number);

singleMatrix = output_final(:,2);
toc

function trueOrFalse= checkParticaleNum(beam_number,realCount_number)
    if beam_number ==realCount_number
        trueOrFalse = 1;
        fprintf('Particale Number is matched!');
    else 
        trueOrFalse = 0;
        fprintf('Particle Number is unmatched!');
    end
end
%read txt file and out put an array with size (length of raw data * 18)
function Z = prepareDataArray(file_name,beam_number,equalOrNot)
%initialize an array
    if equalOrNot ==1
        Z = zeros(beam_number,18);
        %reopen the txt file
        fid = fopen(file_name,'r');
        line = fgetl(fid);
        x = 1;
        y = 1;
        s1 = 'Edep (MeV)):';
        while ischar(line)
          if strcmp(strtrim(line), s1)==1    
            line = NaN;
          end
          if rem(y, 18)==0
             x = x + 1;
             y=1;
          end      
          if ~isnan(line)
            Z(x,y) = str2double(line);
            y = y+1;            
          end
%         Z(x,y) = str2double(line);
%         y = y+1;            
        line = fgetl(fid);  
        end
        fclose(fid);
    end
end

%this function is to check the length of the raw data sets
%return number of beams(total length/ 18layers)
function m = linecount(file_name)
tfid = fopen(file_name,'r');
n = 0;
tline = fgetl(tfid);
while ischar(tline)
  tline = fgetl(tfid);
  n = n+1;
end
fclose(tfid);
m = n/18;
end

%this function is to check how many Particle hit outer ring(even layer) and back
%side (17th layer)
function goodA= goodBeam(A)
    outer_ring = 0;
    back_hit =0;
    %good beam numbers
    R = size(A,1)
    temp_countOuter = A(:,2)+A(:,4)+A(:,6)+A(:,8)+A(:,10)+A(:,12)+A(:,14)+A(:,16);
    %temp_countOuter = sum(B.').';
    temp_countBack = A(:,17);
   % temp_Both =horzcat(temp_countOuter,temp_countBack);
    temp_index = temp_countOuter +temp_countBack;
    
    for m = 1: R
        
        if temp_countOuter(m)>0
            outer_ring = outer_ring +1;       
        end
        
        if temp_countBack(m)>0
            back_hit = back_hit +1;
        end
        
        if temp_index(m)~=0
            temp_index(m);
            A(m,:)=0;   
        end    
    end
      
    goodA = A;
    size(goodA) 
    fprintf('The number of beams hit the out_ring=%i\nThe numbers of beams hit the back=%i\n',outer_ring,back_hit);
     
end

%sum 1 to 16 layer and store into a new size=(filted_particle_number *1) array 
function s = sum1to16layers(goodParticleArray)
    s = sum(goodParticleArray(:,1:16),2);
end

%Compare particle energy to energy_channels and increase count number by 1
%in the right channels
%output array is a size = energy_channels x 2, col_1= particle numbers,
%col_2 = percentage
function outputArray = compareToEnergyChannels(goodOneColArray,energy_channels,beam_number)
    R_energy = size(energy_channels,1);
    R_goodCol = size(goodOneColArray,1);
    outputArray = zeros(R_energy,2);
    for i = 1 :R_goodCol
        for j = 1: R_energy
                if goodOneColArray(i)>= energy_channels(j,1) && goodOneColArray(i)< energy_channels(j,2)
                    outputArray(j,1)= outputArray(j)+1;
                end
        end      
    end
    for h = 1: size(outputArray,1)
        %based on total particle number,if base on good particle uncomment
        %next part
        outputArray(h,2) = outputArray(h,1)/beam_number;
        %outputArray(h,2) = outputArray(h,1)/R_goodCol;
    end
    
end

%generate the plot image
function set_array = plotImages(outputArray,energy_channels, beam_number)
    %set a new array for plot size= energy_channels(:,1) x 2
    set_array = zeros(size(energy_channels,1),2);
    set_array(:,1)= energy_channels(:,1);
    set_array(:,2)= outputArray(:,2);
end


end