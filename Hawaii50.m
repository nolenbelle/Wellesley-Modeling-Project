%% Grace, Nolen, and KTP
% Hawaii sea level rise

%% Step #1: load in dataset 1 --> monthly global mean sea level rise 1870-2001 from .txt file

fileID = fopen('church_white_grl_gmsl.txt','r');
rawglobalslr = fscanf(fileID,'%f %f %f',[3, Inf]);
fclose(fileID);

globalslr = rawglobalslr';

%% Step #1a: analyze dataset 1

figure(1);
plot(globalslr(:,1),globalslr(:,2));

%% Step #2 load in dataset 2 --> local sea level rise, Hawaii cities 

%Var1 = year
%Var2 = month
%Var3 = day
%Var4 = sea level
% lat lon

honolulu = readtable('d057_honolulu.csv');      %21.30700	-157.86700
nawiliwili = readtable('d058_nawiliwili.csv');  %21.96700	-159.35000
kahului = readtable('d059_kahului.csv');        %20.90000	-156.46700
hilo = readtable('d060_hilo.csv');              %19.73300	-155.06700
mokuoloe = readtable('d061_mokuoloe.csv');      %21.43300	-157.80000
barberspt = readtable('d547_barberspoint.csv'); %21.32000	-158.12000
kaumalapau = readtable('d548_kaumalapau.csv');  %20.78000	-156.90000
kawaihae = readtable('d552_kawaihae.csv');      %20.03300	-155.83300

%% Step #3: load in dataset 3 --> global monthly SST 1891-present from .nc file
% data from NOAA
