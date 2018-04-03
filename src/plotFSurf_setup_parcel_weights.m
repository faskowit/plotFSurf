function [ plotStruct ] = plotFSurf_setup_parcel_weights(dataStruct,...
                                                lh_weights,...
                                                rh_weights,...
                                                weights_unknown,...
                                                unknown_color,...
                                                weights_range,...
                                                cmap)
% Plot weights on parcellated cortical surfaces
%
% INPUTS
%
% dataStruct:                   struct returned by plotFSurf_setup func
% {lh,rh}_weights:              vector of weights for each ROI in 
%                               label_roi. ROIs per-hemisphere determined
%                               by regions fed to setup function
%                               (specifically the rois in lh_roi_txt and
%                               rh_roi_txt files). Check out how many
%                               weights to provide by running:
%                               `size(dataStruct.label_roi)`
% weights_unknown:              value for surface vertices not given value
%
% 09/22/2017 M.Fukushima
% 03/30/2018 J.Faskowitz
% Indiana University
% Computational Cognitive Neurosciene Lab
% See LICENSE file for license

%% check inputs

% check weights unknown variable
if ~exist('weights_unknown','var') || isempty(weights_unknown)
    weights_unknown = -999; % weight for unknown vertices
end

% check weights unknown variable
if ~exist('unknown_color','var') || isempty(unknown_color)
    unknown_color = [ 0.5 0.5 0.5 ]; 
end

% check weights unknown variable
if ~exist('weights_range','var') || isempty(weights_range)
    weights_range = ''; % weight for unknown vertices
end

% check weights unknown variable
if ~exist('cmap','var') || isempty(cmap)
    cmap = brewermap(250,'PuRd'); 
end

%% assign weights to regions

% Number of ROIs
Nrois(1) = length(dataStruct.label_roi(:,1)); % LH
Nrois(2) = length(dataStruct.label_roi(:,2)); % RH

% check if lenght of weights provided is correct
if (Nrois(1) ~= length(lh_weights)) || ...
        (Nrois(2) ~= length(rh_weights))
    disp('number of rois does not equal number of weights')
    disp(strcat('LH: num roi=',num2str(Nrois(1)),',num weights:',num2str(length(lh_weights))))
    disp(strcat('RH: num roi=',num2str(Nrois(2)),',num weights:',num2str(length(rh_weights))))
    disp('Dont forget, need a weight for all labels, including "unknown" or "midline"')
    exit 1
end

% weights
% set the whole surface to weights_unknown to begin with
weights_LH = ones(length(dataStruct.V_LH(:,1)),1)*weights_unknown;
weights_RH = ones(length(dataStruct.V_RH(:,1)),1)*weights_unknown;

% set weights for parcells
for idx = 1:Nrois(1)
    % add 1 because the label_roi num is 0-based
    weights_LH(dataStruct.label_roi{idx,1}(:,1)+1) = lh_weights(idx);
end
for idx = 1:Nrois(2)
    % add 1 because the label_roi num is 0-based
    weights_RH(dataStruct.label_roi{idx,2}(:,1)+1) = rh_weights(idx);
end

%% convert from weight to colormap index

[dir_cmap_ind_LH,dir_cmap_ind_RH,o_cmap] = plotSurf_weight_2_cmapInd(...
    weights_LH,weights_RH,weights_unknown,unknown_color,weights_range,cmap) ;

%% setup output struct
plotStruct = struct();

% the data has been setup to visualized directly
plotStruct.CDataMapStr = 'direct' ;
plotStruct.LH_weights = dir_cmap_ind_LH ;
plotStruct.RH_weights = dir_cmap_ind_RH ;
plotStruct.cmap = o_cmap ;

% use the func 'plotFSurf_viz_trisurf' to visualize
% below are notes/scratch on doing this viz

%% different ways to plot data...
% 
% % method using MATLAB's scale
%
% fig = figure;
% CDataMap = 'scaled' ;
% plotFSurf_viz_trisurf(dataStruct,weights_LH,weights_RH,brewermap(100,'PrGn'),CDataMap) 
%
% % method using new index for each surface vertex
%
% lh_ind = zeros(length(weights_LH)+length(weights_LH),1);
% lh_ind(1:length(weights_LH)) = 1 ;
% lh_ind = ~~lh_ind ;
% rh_ind = ~lh_ind ;
% 
% aaaa = 1:length(weights_LH)+length(weights_LH) ;
% 
% % weights_range = prctile([weights_LH ; weights_RH],[0 100]) ;
% 
% val2cmap = vals_2_colormap([weights_LH ; weights_RH],brewermap(100,'PrGn'),[-1 1]) ;
% 
% % [unique_val2cmap,~,unique_map] = unique(val2cmap,'rows') ;
% 
% fig = figure;
% CDataMap = 'direct' ;
% plotFSurf_viz_trisurf(dataStruct,aaaa(lh_ind),aaaa(rh_ind),val2cmap,CDataMap) 
% 
% % method using uniqe vertex indicies (makes darker vals for some reason)
%
% lh_ind = zeros(length(weights_LH)+length(weights_LH),1);
% lh_ind(1:length(weights_LH)) = 1 ;
% lh_ind = ~~lh_ind ;
% rh_ind = ~lh_ind ;
% 
% weights_range = prctile([weights_LH ; weights_RH],[0 100]) ;
% 
% val2cmap = vals_2_colormap([weights_LH ; weights_RH],brewermap(100,'PrGn'),[-1 1]) ;
% 
% [unique_val2cmap,~,unique_map] = unique(val2cmap,'rows') ;
% 
% fig = figure;
% CDataMap = 'direct' ;
% plotFSurf_viz_trisurf(dataStruct,unique_map(lh_ind),unique_map(rh_ind),unique_val2cmap,CDataMap) 

