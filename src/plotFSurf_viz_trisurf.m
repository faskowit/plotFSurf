function [] = plotFSurf_viz_trisurf(dataStruct,...
                                    weights_LH,...
                                    weights_RH,...
                                    cmap,CDataMapStr,...
                                    plotViewStr) 
% function to viz surface using trisurf function
%
% INPUTS:
% dataStruct:                   struct returned by plotFSurf_setup func
% weights_{LH,RH}:              vector of weights for each roi, length = 
%                               number points in each hemisphere surface.
%                               The previous functions should have taken
%                               care to make these vectors for you so you
%                               dont have to worrry about it! 
% cmap:                         colormap to be used in colormap() func
% CDataMapStr:                  option for mapping colors. either scaled or
%                               direct.
% plotViewSrt:                  view to output. options for plot view can 
%                               specify hemisphere (lh or rh) and (med)ial 
%                               or (lat)eral, with colon inbetween. 
%                               i.e. 'lh:lat'; 'all' will show all 4 views
%
% 09/22/2017 M.Fukushima
% 03/30/2018 J.Faskowitz
% Indiana University
% Computational Cognitive Neurosciene Lab
% See LICENSE file for license

if ~exist('plotViewStr','var') || isempty(plotViewStr)
    plotViewStr = 'all'; % weight for unknown vertices
end 

if ~ismember(CDataMapStr, {'scaled' 'direct'})
   disp('CDataMapStr must be either "scaled" or "direct"') 
end

if ~ismember(plotViewStr, {'all' 'lh:lat' 'lh:med' 'rh:lat' 'rh:med'})
    disp('invalid "plotView" variable')
    exit 1
end
    
%% viz it

colormap( cmap ) ;

% Left Hemisphere

if strcmp(plotViewStr,'all')
    subplot(221)
end
if strcmp(plotViewStr,'all') || strcmp(plotViewStr,'lh:lat')
    LH = trisurf(dataStruct.F_LH,...
        dataStruct.V_LH(:,1),...
        dataStruct.V_LH(:,2),...
        dataStruct.V_LH(:,3),...
        weights_LH);
    set(LH,'EdgeColor','none');
    axis equal; axis off
    view(-90,0)
    camlight headlight; material dull; lighting gouraud
    LH.CDataMapping = CDataMapStr ;
end

if strcmp(plotViewStr,'all')
    subplot(223)
end
if strcmp(plotViewStr,'all') || strcmp(plotViewStr,'lh:med')
    LH = trisurf(dataStruct.F_LH,...
        dataStruct.V_LH(:,1),...
        dataStruct.V_LH(:,2),...
        dataStruct.V_LH(:,3),...
        weights_LH);
    set(LH,'EdgeColor','none');
    axis equal; axis off
    view(90,0)
    camlight headlight; material dull; lighting gouraud
    LH.CDataMapping = CDataMapStr ;
end

% Right Hemisphere

if strcmp(plotViewStr,'all')
    subplot(222)
end
if strcmp(plotViewStr,'all') || strcmp(plotViewStr,'rh:lat')
    RH = trisurf(dataStruct.F_RH,...
        dataStruct.V_RH(:,1),...
        dataStruct.V_RH(:,2),...
        dataStruct.V_RH(:,3),...
        weights_RH);
    set(RH,'EdgeColor','none');
    axis equal; axis off
    view(90,0)
    camlight headlight; material dull; lighting gouraud
    RH.CDataMapping = CDataMapStr ;
end

if strcmp(plotViewStr,'all')
    subplot(224)
end
if strcmp(plotViewStr,'all') || strcmp(plotViewStr,'rh:med')
    RH = trisurf(dataStruct.F_RH,...
        dataStruct.V_RH(:,1),...
        dataStruct.V_RH(:,2),...
        dataStruct.V_RH(:,3),...
        weights_RH);
    set(RH,'EdgeColor','none');
    axis equal; axis off
    view(-90,0)
    camlight headlight; material dull; lighting gouraud
    RH.CDataMapping = CDataMapStr ;
end
