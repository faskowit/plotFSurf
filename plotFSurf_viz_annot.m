function [ fig ] = plotFSurf_viz_annot(F_LH,F_RH,...
                                        V_LH,V_RH,...
                                        lh_annot_file_path,...
                                        rh_annot_file_path,...
                                        weights_unknown,...
                                        alt_colors)
% Plot FreeSurfer annotation file
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
weights_LH = ones(length(V_LH(:,1)),1)*weights_unknown;
weights_RH = ones(length(V_RH(:,1)),1)*weights_unknown;

for idx = 1:Nrois 

    weights_LH(lh_parcel_inds == lh_annot_info.table(idx,5)) = idx;
    weights_RH(rh_parcel_inds == rh_annot_info.table(idx,5)) = idx;
end

%% plot

fig = figure;

% note, need the CDataMapping = 'direct' to get the color mapping correct
colormap( annot_colors  ) ;

% Left Hemisphere

subplot(221)
LH = trisurf(F_LH,V_LH(:,1),V_LH(:,2),V_LH(:,3),weights_LH);
set(LH,'EdgeColor','none');
axis equal; axis off
view(-90,0)
camlight headlight; material dull; lighting gouraud
LH.CDataMapping = 'direct' ;

subplot(223)
LH = trisurf(F_LH,V_LH(:,1),V_LH(:,2),V_LH(:,3),weights_LH);
set(LH,'EdgeColor','none');
axis equal; axis off
view(90,0)
camlight headlight; material dull; lighting gouraud
LH.CDataMapping = 'direct' ;

% Right Hemisphere

subplot(222)
RH = trisurf(F_RH,V_RH(:,1),V_RH(:,2),V_RH(:,3),weights_RH);
set(RH,'EdgeColor','none');
axis equal; axis off
view(90,0)
camlight headlight; material dull; lighting gouraud
RH.CDataMapping = 'direct' ;

subplot(224)
RH = trisurf(F_RH,V_RH(:,1),V_RH(:,2),V_RH(:,3),weights_RH);
set(RH,'EdgeColor','none');
axis equal; axis off
view(-90,0)
camlight headlight; material dull; lighting gouraud
RH.CDataMapping = 'direct' ;
