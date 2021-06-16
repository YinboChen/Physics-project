function singleMatrix = oneEnergyEfficDistro_v2(file_name)
%Auther:Yinbo Chen
%Superviser: Hong Zhao
%Date: 6/15/2021
tic
cd Result;
%input txt
%file_name = "outputSingleRun_Electron_Ene_7.0_1000000.txt";
%file_name ="outputSingleRun_Electron_Ene_3.7_10000.txt";
% set up the energy channels size is 32 x 2
energy_channels = [
    1,1.1;1.1,1.2;1.2,1.3;1.3,1.4;1.4,1.5;
    1.5,1.6;1.6,1.7;1.7,1.8;1.8,1.9;1.9,2;
    2,2.1;2.1,2.21;2.21,2.32;2.32,2.44;2.44,2.56;
    2.56,2.69;2.69,2.83;
    2.83,2.97;2.97,3.12;3.12,3.28;3.28,3.45;3.45,3.62;3.62,3.81;3.81,4;
    4,4.2;4.2,4.5;4.5,4.8;4.8,5.2;5.2,5.6;5.6,6;6,6.5;6.5,7];

%initial output 32*1 array with name singleMatrix
singleMatrix = zeros(32, 1);


%recognize the paticle energy level from file name, only works when file
%name has 3.8_10 format number.
%3.8 is energy; 10 is beam number
token = str2double(split(regexp(file_name, '\d+\.\d+\_\d+', 'match', 'once'),"_"));
energy_beam = token(1);
beam_number = token(2);

    count_outer = 0;
    count_back = 0;
    singlesSum = 0;
    doublesSum = 0;
    fide = fopen(file_name,'r');
    
    for i = 1:beam_number
        for j = 1:18
            line = fgetl(fide);
            info = str2double(line);
            if  mod(j,2)==0 && j< 17 
                singlesSum = singlesSum + info;
            end
            if mod(j,2)==1 && j < 18 && j > 2
                doublesSum = doublesSum + info; 
            end
               
            if doublesSum ~=0 && j==18
                count_outer = count_outer+1;
                singlesSum = 0;
            end
            
            if j ==18 && info ~=0
                count_back = count_back +1;
                singlesSum = 0;
            end
            
            if j==18
                for k = 1:32 
                    if singlesSum>= energy_channels(k,1) && singlesSum< energy_channels(k,2)
                    singleMatrix(k)= singleMatrix(k)+1;  
                    end
                 end 
            end
            
        end
        singlesSum = 0;
        doublesSum = 0;
    end
 fclose(fide); 
 fprintf('The number of beams hit the outer_ring=%i\nThe numbers of beams hit the back=%i\n',count_outer,count_back);
 singleMatrix = singleMatrix /beam_number;
 toc
end