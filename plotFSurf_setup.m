function [ outStruct ] = plotFSurf_setup(subjects_dir,subject,...
                            lh_roi_txt,rh_roi_txt,...
                            lh_surface_asc,rh_surface_asc,...
                            medial_wall_bool)
% setup for plotting. use this function to obtain verticies and faces of
% the surface, and to parcellate the surface based on the roi lists
% provided via the text files
%
% INPUTS+
%
% subjects_dir: SUBJECTS_DIR in FreeSurfer
% subject:          subject in SUBJECTS_DIR (usually your fsaverage subject)
% lh_roi_txt:       text file listing ROI names in LH (no file prefix or 
%                   suffix)
% rh_roi_txt:       text file listing ROI names in RH (no file prefix or 
%                   suffix)
% lh_surface_asc:   asc file of cortical surface (example= lh.white.asc)
% rh_surface_asc:   asc file of cortical surface (example= lh.white.asc)
% medial_wall_bool: Add the medial wall label (this will increase your list
%                   of roi labels by one)
%
% OUTPUTS
% 
% MATLAB structure with the following fields:
% F_{LH,RH}:        faces of surface mesh for {LH,RH}
% V_{LH,RH}:        verticies of surface mesh for {LH,RH}
% label_roi:        [(num ROIs)x2] variable used to describe which parts of
%                   the surface correspond to whoch roi
% roinames:         [1x2] roi names for LH (col 1) and RH (col 2) 
% 
% 06/28/2017 M.Fukushima
% 03/30/2018 J.Faskowitz
% Indiana University
% Computational Cognitive Neurosciene Lab
% See LICENSE file for license

% deal with optional medial wall 
if ~exist('medial_wall_bool','var') || isempty(medial_wall_bool)
    medial_wall_bool = 0 ;
end

% Set SUBJECTS_DIR in FreeSurfer
setenv('SUBJECTS_DIR',subjects_dir)

% load ROI names from txt file
roinames = cell(2,1);
Nrois = zeros(2,1);
for kk = 1:2
  switch kk
    case 1
      fileID = fopen(lh_roi_txt);
    case 2
      fileID = fopen(rh_roi_txt);
  end
  C = textscan(fileID,'%s');
  fclose(fileID);
  roinames{kk} = C{1}; clear C
  Nrois(kk) = length(roinames{kk});
  
  % possibly add medial wall bool
  if medial_wall_bool
        roinames{kk}{end+1} = 'Medial_wall' ;
        Nrois(kk) = Nrois(kk) + 1 ;
  end
end

% Read label files
hemi = {'lh','rh'};
label_roi = cell(max(Nrois),2);
for kk = 1:2
  for idx = 1:Nrois(kk)
    lname = strcat(hemi{kk},'.',roinames{kk}{idx});
    label_roi{idx,kk} = read_label(subject,lname);
  end
end

% Load cortical surfaces
[F_LH, V_LH] = plotFSurf_load_surf(lh_surface_asc);
[F_RH, V_RH] = plotFSurf_load_surf(rh_surface_asc);

%% output
% package a struct
outStruct = struct() ;
outStruct.F_LH = F_LH ;
outStruct.V_LH = V_LH ;
outStruct.F_RH = F_RH ;
outStruct.V_RH = V_RH ;
outStruct.label_roi = label_roi ;
outStruct.roi_names = roinames' ;

