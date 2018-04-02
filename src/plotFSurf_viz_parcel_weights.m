function [ fig ] = plotFSurf_viz_parcel_weights(dataStruct,...
                                                lh_weights,...
                                                rh_weights,...
                                                weights_unknown,...
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
%                               rh_roi_txt files).  
% weights_unknown:              value for any surface areas not given value
%
% 09/22/2017 M.Fukushima
% 03/30/2018 J.Faskowitz
% Indiana University
% Computational Cognitive Neurosciene Lab
% See LICENSE file for license

% check weights unknown variable
if ~exist('weights_unknown','var') || isempty(weights_unknown)
    weights_unknown = -1; % weight for unknown vertices
end

% check weights unknown variable
if ~exist('cmap','var') || isempty(cmap)
    cmap = 'default'; % weight for unknown vertices
end

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
  weights_LH(dataStruct.label_roi{idx,1}(:,1)+1) = lh_weights(idx);
end
for idx = 1:Nrois(2)
  weights_RH(dataStruct.label_roi{idx,2}(:,1)+1) = rh_weights(idx);
end

%% plot

fig = figure;
CDataMap = 'scaled' ;
plotFSurf_viz_trisurf(dataStruct,weights_LH,weights_RH,cmap,CDataMap) 

