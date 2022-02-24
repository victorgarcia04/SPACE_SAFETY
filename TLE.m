clc; clear all; close all
%% Victor Garcia Fernandez
mu = 3.986e5; %  Standard gravitational parameter for the earth

%% Latest TLE for all satellites 
% File name 
filename = 'IRIDIUM_TLE.txt';

% Open the TLE file and read TLE elements
fileID = fopen(filename, 'rb');
data1 = zeros(75,24);
data2 = zeros(75,9);
data3 = zeros(75,8);

for i = 1:75
    data1(i,:) = fscanf(fileID,'%24c%*s',1);
    data2(i,:) = fscanf(fileID,'%d%6d%*c%5d%*3c%*2f%f%f%5d%*c%*d%5d%*c%*d%d%5d',[1,9]);
    data3(i,:) = fscanf(fileID,'%d%6d%f%f%f%f%f%f%f',[1,8]);
end
fclose(fileID);

% Obtain orbital elements
epoch = data2(:,4)*24*3600;        % Epoch Date and Julian Date Fraction
inc   = data3(:,3);                % Inclination [deg]
RAAN  = data3(:,4);                % Right Ascension of the Ascending Node [deg]
e     = data3(:,5)/1e7;            % Eccentricity 
w     = data3(:,6);                % Argument of periapsis [deg]
M     = data3(:,7);                % Mean anomaly [deg]
n     = data3(:,8);                % Mean motion [Revs per day]
   
% Orbital elements

sma = (mu./(n.*2.*pi./(24*3600)).^2).^(1/3);     % Semi-major axis [km]    

%% PLOTS

% Altitude distribution plot
figure
histogram(sma-6378)
grid on
xlabel('Altitude [km]')
ylabel('Number of satellites in orbit')

% Inclination distribution plot
figure
histogram(inc)
grid on
xlabel('Inclination [º]')
ylabel('Number of satellites in orbit')

% Eccentricity distribution plot
figure
histogram(e)
grid on
xlabel('Eccentricity [-]')
ylabel('Number of satellites in orbit')

% Eccentricity distribution plot
figure
histogram(RAAN,15)
grid on
xlabel('RAAN [º]')
ylabel('Number of satellites in orbit')

%% READ HISTORICAL DATA
% TLE file name 
% file2 = 'IRIDIUM_152.txt'; %3182
file2 = 'IRIDIUM_96_.txt'; %4251
% file2 = 'IRIDIUM_114.txt'; %4240

% Open the TLE file and read TLE elements
fileID2 = fopen(file2, 'rb');
L2_sat = cell(13881,9);
L3_sat = cell(13881,9);
for i = 1:13881
    L2_sat(i,:) = split((fgetl(fileID2)));
    aux = split((fgetl(fileID2)));
    if length(aux) <9
        L3_sat(i,1:8) = aux;
        L3_sat(i,end) = {0};
    else
        L3_sat(i,:) = aux;
    end
end
fclose(fileID2);

%% Compute variables
for i = 1:13881
epoch_sat(i) = str2double(cell2mat(L2_sat(i,4)));        % Epoch Date and Julian Date Fraction
inc_sat(i)   = str2double(cell2mat(L3_sat(i,3)));                % Inclination [deg]
RAAN_sat(i)  = str2double(cell2mat(L3_sat(i,4)));                % Right Ascension of the Ascending Node [deg]
e_sat(i)     = str2double(cell2mat(L3_sat(i,5)))/1e7;            % Eccentricity 
w_sat(i)     = str2double(cell2mat(L3_sat(i,6)));                % Argument of periapsis [deg]
M_sat(i)     = str2double(cell2mat(L3_sat(i,7)));                % Mean anomaly [deg]
n_sat(i)     = str2double(cell2mat(L3_sat(i,8)));                % Mean motion [Revs per day]
sma_sat(i) = (mu/(n_sat(i)*2*pi/(24*3600))^2)^(1/3);     % Semi-major axis [km]    
end

%% HISTORICAL PLOTS

figure
plot((epoch_sat-epoch_sat(1))/365/3,e_sat)
grid on
xlabel('Years since launch')
ylabel('Eccentricity evolution [-]')

figure
plot((epoch_sat-epoch_sat(1))/365/3,sma_sat)
grid on
xlabel('Years since launch')
ylabel('Semi-major axis evolution [km]')

figure
plot((epoch_sat-epoch_sat(1))/365/3,sma_sat - 6378)
grid on
xlabel('Years since launch')
ylabel('Altitude evolution [km]')

figure
plot((epoch_sat-epoch_sat(1))/365/3,inc_sat)
grid on
xlabel('Years since launch')
ylabel('Inclination evolution [-]')

figure
plot((epoch_sat-epoch_sat(1))/365/3,RAAN_sat)
grid on
xlabel('Years since launch')
ylabel('RAAN evolution [-]')