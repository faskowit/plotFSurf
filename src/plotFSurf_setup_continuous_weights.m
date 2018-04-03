function [ plotStruct ] = plotFSurf_setup_continuous_weights(dataStruct,...
                                                lh_weights,...
                                                rh_weights,...
                                                cmap,...
                                                weights_unknown,...
                                                unknown_color,...
                                                weights_range)
% Plot continuous weights on cortical surfaces (no ROIs)
%
% INPUTS:
%
% dataStruct:                   struct returned by plotFSurf_setup func
% {lh,rh}_weights:              vector of weights for each surface; should
%                               be size: (num of verticies in hemi surf)x1
% cmap:                         the colormap that the data will correspond
%                               to. defualt: brewermap(250,'PuRd')
% weights_unknown (opt):        value for surface vertices not given value;
%                               make sure this value outside the expected
%                               range for your values. default: -999 
% unknown_color (opt):          color that will be added to cmap if unknown
%                               values are encountered. default: [.5 .5 .5]
% weights_range:                can give a range to visualize; higher and 
%                               lower values will be trimed to the min and
%                               max provided here. format [ min max ].
%                               default: [ min(data) max(data) ]
%
% OUPUT:
% 
% a MATLAB structure with the following fields:
% 
% {LH,RH}_weights:              output values that index the cmap provided
% CDataMapStr:                  how the CDataMap should function; based on
%                               this function, it will be set to 'direct'
% cmap:                         the cmap that should be used for viz; if
%                               there were unknown values in the final
%                               mapped data, there will be an additional
%                               row (compared to input cmap) corresponding
%                               to the unknown_color
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

% weights
% set the whole surface to weights_unknown to begin with
weights_LH = ones(length(dataStruct.V_LH(:,1)),1)*weights_unknown;
weights_RH = ones(length(dataStruct.V_RH(:,1)),1)*weights_unknown;

% set weights for parcells
% assume that unknown weights in input vecs were set to NaN
tmp_ind = ~isnan(lh_weights) ; 
weights_LH(tmp_ind) = lh_weights(tmp_ind);

tmp_ind = ~isnan(rh_weights) ; 
weights_RH(tmp_ind) = rh_weights(tmp_ind);

%% convert from weight to colormap index

[dir_cmap_ind_LH,dir_cmap_ind_RH,o_cmap] = plotFSurf_weight_2_cmapInd(...
    weights_LH,weights_RH,weights_unknown,unknown_color,weights_range,cmap) ;

%% setup output struct
plotStruct = struct();

% the data has been setup to visualized directly
plotStruct.CDataMapStr = 'direct' ;
plotStruct.LH_vals = dir_cmap_ind_LH ;
plotStruct.RH_vals = dir_cmap_ind_RH ;
plotStruct.cmap = o_cmap ;

% use the func 'plotFSurf_viz_trisurf' to visualize
% below are notes/scratch on doing this viz

% fig = figure;
% CDataMap = 'direct' ;
% plotFSurf_viz_trisurf(dataStruct,dir_cmap_ind_LH,dir_cmap_ind_RH,o_cmap,CDataMap) 

