function [ fig ] = plotFSurf_viz_annot(dataStruct,...
                                       lh_annot_file_path,...
                                       rh_annot_file_path,...
                                       weights_unknown,...
                                       alt_colors)
% Plot FreeSurfer annotation file
%
% INPUTS
%
% dataStruct:                   struct returned by plotFSurf_setup func
% {lh,rh}_annot_file_path:      file path to FreeSurfer annotation
% weights_unknown:              value for any surface areas not given value 
% alt_colors:                   alternative color scheme other than that
%                               provided in annot file
%
% 09/22/2017 M.Fukushima
% 03/30/2018 J.Faskowitz
% Indiana University
% Computational Cognitive Neurosciene Lab
% See LICENSE file for license

if ~exist('weights_unknown','var') || isempty(weights_unknown)
    weights_unknown = -1; % weight for unknown vertices
end

if ~exist('alt_colors','var') || isempty(alt_colors)
    alt_colors = ''; % weight for unknown vertices
end

% use the FreeSurfer func to read in the annot
[~,lh_parcel_inds,lh_annot_info] = read_annotation(lh_annot_file_path) ;
[~,rh_parcel_inds,rh_annot_info] = read_annotation(rh_annot_file_path) ;

if isempty(alt_colors)
    annot_colors = lh_annot_info.table(:,1:3) ./ 255 ;
else
    annot_colors = alt_colors ;
end

Nrois = lh_annot_info.numEntries ;

% weights
% set the whole surface to weights_unknown to begin with
weights_LH = ones(length(dataStruct.V_LH(:,1)),1)*weights_unknown;
weights_RH = ones(length(dataStruct.V_RH(:,1)),1)*weights_unknown;

for idx = 1:Nrois 

    weights_LH(lh_parcel_inds == lh_annot_info.table(idx,5)) = idx;
    weights_RH(rh_parcel_inds == rh_annot_info.table(idx,5)) = idx;
end

%% plot

fig = figure;
CDataMap = 'direct' ;
cmap = annot_colors ;
plotFSurf_viz_trisurf(dataStruct,weights_LH,weights_RH,cmap,CDataMap) 
