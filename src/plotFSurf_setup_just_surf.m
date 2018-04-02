function [ dataStruct ] = plotFSurf_setup_just_surf(lh_surface_asc,rh_surface_asc)
% 09/22/2017 M.Fukushima
% 03/30/2018 J.Faskowitz
% Indiana University
% Computational Cognitive Neurosciene Lab
% See LICENSE file for license

% Load cortical surfaces
[F_LH, V_LH] = plotFSurf_load_surf(lh_surface_asc);
[F_RH, V_RH] = plotFSurf_load_surf(rh_surface_asc);

%% output

% package a struct to be used in other functions
dataStruct = struct() ;
dataStruct.F_LH = F_LH ;
dataStruct.V_LH = V_LH ;
dataStruct.F_RH = F_RH ;
dataStruct.V_RH = V_RH ;

