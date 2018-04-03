%% recipe for plotting on a surface
% Indiana University
% Computational Cognitive Neurosciene Lab
% See LICENSE file for license

clc 
clearvars

addpath(strcat(pwd,'/'))
addpath(strcat(pwd,'/src/external/'))

%% step one
% run the prep_subj (in bash) to get surface in ascii format and to 
% potentially get parcellated regions. 
% 
% a call to that function might look like:
% ./src/external/prep_subj.sh ./example_data/ fsaverage ./example_data/prep_plotFSurf YeoUpsample
% which would put the data we want in the ./example_data/prep_plotFSurf dir
%
%% step two
% read in the data

dataStruct = plotFSurf_read_in_data('./example_data/prep_plotFSurf/lh.inflated.srf',...
    './example_data/prep_plotFSurf/rh.inflated.srf',...
    './example_data/','fsaverage',...
    './example_data/prep_plotFSurf/lh.label_list.txt',...
    './example_data/prep_plotFSurf/rh.label_list.txt',...
    0) ;

%% step three
% get values we would like to plot per ROI, and convert these values into
% indices that will be useful for viz

% lets make up some weights
LH_weights = rand(58,1) ;
RH_weights = rand(58,1) ;

% since we know that the first label is the
% Background+FreeSurfer_Defined_Medial_Wall, lets make this first value
% into something outside the 'normal range'
LH_weights(1) = -1 ;
RH_weights(1) = -1 ;

% lets get a nice colormap
cmap_to_use = brewermap(100,'YlOrRd') ;

plotStruct = plotFSurf_setup_parcel_weights(dataStruct,...
    LH_weights,RH_weights,cmap_to_use,-1) ;

%% step 4
% viz it using the info from the `dataStruct` & `plotStruct`

plotFSurf_viz_trisurf(dataStruct,...
    plotStruct.LH_vals,plotStruct.RH_vals,...
    plotStruct.cmap,plotStruct.CDataMapStr,'lh:lat')

%% bonus step!!!
% the viz for annotation is all in one func

% viz for annotation files! 
plotFSurf_viz_annot(dataStruct,...
    './example_data/fsaverage/label/lh.YeoUpsample.annot',...
    './example_data/fsaverage/label/rh.YeoUpsample.annot')
