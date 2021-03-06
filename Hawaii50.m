%% Grace, Nolen, and KTP
% Hawaii sea level rise

%% Step #1: load in dataset 1 --> monthly global mean sea level rise 1870-2001 from .txt file
% File info: Columns: Year, Sea Level (mm) from, Standard deva
fileID = fopen('church_white_grl_gmsl.txt','r');
rawglobalslr = fscanf(fileID,'%f %f %f',[3, Inf]);
fclose(fileID);

globalslr = rawglobalslr';

%%
%convert years from scientific notation to decimal notation
allYears = unique(fix(globalslr(:,1)));
%yearList = NaN*zeros(length(allYears),1);    
% 

k=1;
for year = allYears(1):allYears(end)              
    globalMeans(k,1) = year;
    indYear = find(fix(globalslr(:,1)) == year);
    yearMean = mean(globalslr(indYear,2));
    globalMeans(k,2) = yearMean;
    k=k+1;
end
%% Step #1a: analyze dataset 1

figure(1); clf;
%sea level (mm) by time 1860-present
plot(globalslr(:,1),globalslr(:,2));
xlabel('Years');
ylabel('Change in Sea Level (mm)');

figure(2); clf;
%sea level (mm) by time 1860-present
plot(globalMeans(:,1),globalMeans(:,2));
xlabel('Years');
ylabel('Change in Sea Level (mm)');

%% Step #2 load in dataset 2 --> local sea level rise, Hawaii cities 
% info: from 1927-present

%Var1 = year
%Var2 = month
%Var3 = day
%Var4 = sea level (units?)
% lat lon

honoluluData = readtable('d057_honolulu.csv');      %21.30700	-157.86700
nawiliwiliData = readtable('d058_nawiliwili.csv');  %21.96700	-159.35000
kahuluiData = readtable('d059_kahului.csv');        %20.90000	-156.46700
hiloData = readtable('d060_hilo.csv');              %19.73300	-155.06700
mokuoloeData = readtable('d061_mokuoloe.csv');      %21.43300	-157.80000
barbersptData = readtable('d547_barberspoint.csv'); %21.32000	-158.12000
kaumalapauData = readtable('d548_kaumalapau.csv');  %20.78000	-156.90000
kawaihaeData = readtable('d552_kawaihae.csv');      %20.03300	-155.83300

cityLat = [21.30700, 21.96700, 20.90000, 19.73300, 21.43300, 21.32000, 20.78000, 20.03300];
cityLon = [-157.86700, -159.35000, -156.46700, -155.06700, -157.80000, -158.12000, -156.90000, -155.83300];

%% plot tidal gauge locations
figure(3); clf
worldmap([18 23],[-160 -154])
geoshow('landareas.shp','FaceColor','black')
title('Tidal Gauge Locations')
scatterm(cityLat,cityLon,50,'r','filled');

%% Step #2b: For each location, average the data to yearly values
%convert years from scientific notation to decimal notation
% honYears = table2array(unique(honolulu(:,1)));
% 
% k=1;
% for year = honYears(1):honYears(end)              
%     honList(k,1) = year;
%     indYear = find(table2array(honolulu(:,1)) == year);
%     yearMean = mean(table2array(honolulu(indYear,4)));
%     honList(k,2) = yearMean;
%     k=k+1;
% end
%% using MonthToYearMean function to condense data to yearly means
%dataNames = {honoluluData nawiliwiliData kahuluiData hiloData mokuoloeData barbersptData kaumalapauData kawaihaeData}

honolulu = MonthToYearMean(honoluluData);
nawiliwili = MonthToYearMean(nawiliwiliData);
kahului = MonthToYearMean(kahuluiData);
hilo = MonthToYearMean(hiloData);
mokuoloe = MonthToYearMean(mokuoloeData);
barberspt = MonthToYearMean(barbersptData);
kaumalapau = MonthToYearMean(kaumalapauData);
kawaihae = MonthToYearMean(kawaihaeData);
%% excluding outliers

honSort = rmoutliers(honolulu);
nawSort = rmoutliers(nawiliwili);
kahSort = rmoutliers(kahului);
%hilSort = rmoutliers(hilo);
hilSort = rmoutliers(hilo,'ThresholdFactor',2); %needed to get rid of more outliers
mokSort = rmoutliers(mokuoloe);
barSort = rmoutliers(barberspt);
kauSort = rmoutliers(kaumalapau);
kawSort = rmoutliers(kawaihae);

% figure(3); clf;
% subplot(2,1,1);
% plot(hilSort(:,1),hilSort(:,2));
% subplot(2,1,2);
% plot(hilSort2(:,1),hilSort2(:,2));
% 
% figure(4); clf;
% subplot(2,1,1);
% plot(honSort(:,1),honSort(:,2));
% subplot(2,1,2);
% plot(honSort2(:,1),honSort2(:,2));

%% plotting each local sea level rise (with and without outliers)
%Classification Learne
placeNames = {honolulu nawiliwili kahului hilo mokuoloe barberspt kaumalapau kawaihae};
sortedNames = {honSort, nawSort, kahSort, hilSort, mokSort, barSort, kauSort, kawSort};

for num = 1:8
    figure(3+num); clf;
%without outliers
    subplot(2,1,1);
    plot(sortedNames{num}(:,1),sortedNames{num}(:,2)); 
%with outliers
    subplot(2,1,2);
    plot(placeNames{num}(:,1),placeNames{num}(:,2)); %with outliers
    xlabel('Years');
    ylabel('Change in Sea Level (mm)');
end

%% plotting all local stations on one graph

sortedNames = {honSort, nawSort, kahSort, hilSort, mokSort, kawSort};
for num = 1:6
    plot(sortedNames{num}(:,1),sortedNames{num}(:,2),'LineWidth',2);
    hold on
end
xlabel('Years');
ylabel('Sea Level (mm)')
legend('honolulu','nawiliwili','kahului','hilo','mokuoloe','kawaihae');

%% make an array of years by local stations and global sea level (after outliers removed)
totalYears = unique([honSort(:,1);nawSort(:,1);kahSort(:,1);hilSort(:,1);mokSort(:,1);kawSort(:,1)]);
placeNames = {honSort nawSort kahSort hilSort mokSort kawSort};

seaLevel_grid = NaN*zeros(length(totalYears),7);  
seaLevel_grid(:,1) = totalYears;

for i = 1:6
    place = placeNames{i};
    for j = 1:length(place)
        indYear = find(place(j,1) == totalYears);
        seaLevel_grid(indYear,1+i) = place(j,2);
    end
end     

%% plot grid with no outliers (looks weird, don't use???)
for num = 1:6
    plot(seaLevel_grid(:,1),seaLevel_grid(:,1+num),'LineWidth',2);
    hold on
end
xlabel('Years');
ylabel('Sea Level (mm)');
legend('honolulu','nawiliwili','kahului','hilo','mokuoloe','kawaihae');

%% Step #2c: Calculate rates of change for each station

seaChange_grid = zeros(length(seaLevel_grid(:,1)),7);
seaChange_grid(:,1) = seaLevel_grid(:,1);

for i = 2:7 %station indices
    baseValue = placeNames{i-1}(1,2);
    seaChange_grid(:,i) = seaLevel_grid(:,i)-baseValue;
end

seaChange_grid(isnan(seaChange_grid)) = 0;

% for i = 1:6
%     baseValue = placeNames{i}(1,2);
%     placeNames{i}(:,3) = placeNames{i}(:,2)-baseValue;
% end

%% Plotting for rates of change
for num = 1:6
    plot(placeNames{num}(:,1),placeNames{num}(:,3),'LineWidth',2);
    hold on
end
xlabel('Years');
ylabel('Sea Level (mm)')
legend('honolulu','nawiliwili','kahului','hilo','mokuoloe','kawaihae');

%% Comparing SST to Sea Level Change

% Step 1: Average local stations for a Hawaii measurement

hawaii_seaLevel_grid = NaN*zeros(length(seaLevel_grid(:,1)),2);
hawaii_seaLevel_grid(:,1) = seaLevel_grid(:,1);
hawaii_seaLevel_grid(:,2) = nanmean(seaLevel_grid(:,2:end),2);

% Step 2: Create an array with Sea Level measurements and SST
% SST - 1891 to 2017
% Sea Level - 1905 to 2019

seaLevel_SST_grid = NaN*zeros(113,3);
seaLevel_SST_grid(:,1:2) = hawaii_seaLevel_grid(1:113,:);
seaLevel_SST_grid(:,3) = sstYearlyMean(15:end);
nooutliers = rmoutliers(seaLevel_SST_grid);

% Step 3: Plot Sea Level vs SST

scatter(nooutliers(:,3),nooutliers(:,2));

%% Step #3: load in dataset 3 --> global monthly SST 1891-present from .nc file
% data from NOAA
% NBB has full global data set on her comp. It runs through HistoricSSTdata
% info: from 1891-present
%       this is only the Hawaiian subset
%       3D which goes lon X lat X time
%       time is months from 1891 January to 2019 March

ncfile = 'SST1x1Hawaii.nc' ; % nc file name
% To get information about the nc file
ncinfo(ncfile);
% to display nc file
ncdisp(ncfile);
% to read a variable 'var' exisiting in nc file
sstHawaii = ncread(ncfile,'sst');
%% Step #3b: Average the SST for each year
% ignore the last 'page' in this file)
sstYearlyHawaii = zeros(10,6,127);

%sum all temps over each year then divide
for i = 1:10
    for j = 1:6
        for k = 1:1523
           sstYearlyHawaii(i,j,(floor(k/12)+1)) = sstYearlyHawaii(i,j,(floor(k/12)+1)) + sstHawaii(i,j,k);
        end 
    end 
end 

%removes missing values by averaging over local area
for i = 1:10
    for j = 1:6
        for k = 1:127
           if (sstYearlyHawaii(i,j,k) > 1000000)
                   sstYearlyHawaii(i,j,k) = (sstYearlyHawaii(i+1,j,k) + sstYearlyHawaii(i-1,j,k)+sstYearlyHawaii(i,j+1,k) + sstYearlyHawaii(i,j-1,k))/4;                         
           end 
        end 
    end 
end 

%take the yearly average
sstYearlyHawaii = sstYearlyHawaii/12;

%This is the average over each page so the value for all of Hawaii
sstYearly3D =  mean(sstYearlyHawaii,[1 2]);
sstYearlyMean = zeros(127,1);

for i = 1:1
    for j = 1:1
        for k = 1:127
           sstYearlyMean(k,1) = sstYearly3D(i,j,k);
        end 
    end 
end 

sstYears = zeros(127,1);
sstYears(1,1) = 1891;
for i = 2:127
    sstYears(i,1) = sstYears(i-1,1) +1;
end 

%% Step #3c Plot SST over time
figure(12); clf
plot(sstYears(2:127,:), sstYearlyMean(2:127,:));


%% Load Topographic basemap --> this pulls up a web-based topo map !

% View Glider Path on Map from OpenTopoMap.org 
% Add a custom basemap and plot the path of a glider on it.
% Copyright 2018 The MathWorks, Inc.

%this plots a sample dataset from the Matlab system, will try soon with
%actual data of importance! -GC
%trk = gpxread('sample_mixed.gpx','FeatureType','track');

% Map buisness 
name = 'opentopomap';
url = 'a.tile.opentopomap.org';
copyright = char(uint8(169));
attribution = [ ...
      "map data:  " + copyright + "OpenStreetMap contributors,SRTM", ...
      "map style: " + copyright + "OpenTopoMap (CC-BY-SA)"];
displayName = 'Open Topo Map';
addCustomBasemap(name,url,'Attribution',attribution,'DisplayName',displayName)
webmap opentopomap

for x=1:30
    lat=Hospitals.latitude(x);
    lon=Hospitals.longitude(x);
    wmmarker(lat, lon);
end

%% TRYING TO PLOT POINTS
pts = geopoint(Hospitals.latitude,Hospitals.longitude)
gb = geobubble(Hospitals.Latitude,Hospitals.Longitude,'Basemap','opentopomap');
gb.BubbleWidthRange = 20;
gb.MapLayout = 'maximized';
gb.ZoomLevel = 14;

%% this plots that sample data from above
%wmline(trk,'LineWidth',2)

hold on
geoscatter(Hospitals.latitude,Hospitals.longitude,'filled');
geolimits([18.0 22.5],[-161.0 -154.5]);

%% --> I cant get this to work rn Im just trying other basemap things
figure(81)
geobasemap('usgstopo');
geolimits([18.0 22.5],[-161.0 -154.5]);
%%
openExample('map/ViewLocationsPlacenamesBubblesOpenStreetMapExample')
