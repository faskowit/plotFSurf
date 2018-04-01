function [ fig ] = plotFSurf_viz_parcel_weights(F_LH,F_RH,...
                                        V_LH,V_RH,...
                                        label_roi,...
                                        weights,...
                                        weights_unknown)
% Plot weights on parcellated cortical surfaces
%
% weights: vector of weights for each region in label_roi. It is assumed
% that weights for LH rois come before weights for RH rois. 
%
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

% Number of ROIs
Nrois(1) = length(label_roi(:,1)); % LH
Nrois(2) = length(label_roi(:,2)); % RH

% weights
% set the whole surface to weights_unknown to begin with
weights_LH = ones(length(V_LH(:,1)),1)*weights_unknown;
weights_RH = ones(length(V_RH(:,1)),1)*weights_unknown;

% set weights for parcells
for idx = 1:Nrois(1)
  weights_LH(label_roi{idx,1}(:,1)+1) = weights(idx);
end
for idx = 1:Nrois(2)
  weights_RH(label_roi{idx,2}(:,1)+1) = weights(idx+Nrois(1));
end

%% plot

fig = figure;
% Left Hemisphere
subplot(221)
LH = trisurf(F_LH,V_LH(:,1),V_LH(:,2),V_LH(:,3),weights_LH);
set(LH,'EdgeColor','none');
axis equal; axis off
view(-90,0)
camlight headlight; material dull; lighting gouraud

subplot(223)
LH = trisurf(F_LH,V_LH(:,1),V_LH(:,2),V_LH(:,3),weights_LH);
set(LH,'EdgeColor','none');
axis equal; axis off
view(90,0)
camlight headlight; material dull; lighting gouraud

% Right Hemisphere

subplot(222)
RH = trisurf(F_RH,V_RH(:,1),V_RH(:,2),V_RH(:,3),weights_RH);
set(RH,'EdgeColor','none');
axis equal; axis off
view(90,0)
camlight headlight; material dull; lighting gouraud

subplot(224)
RH = trisurf(F_RH,V_RH(:,1),V_RH(:,2),V_RH(:,3),weights_RH);
set(RH,'EdgeColor','none');
axis equal; axis off
view(-90,0)
camlight headlight; material dull; lighting gouraud
