function [ dataStruct ] = plotFSurf_read_in_data(lh_surface_asc,...
                                                 rh_surface_asc,...
                                                 subjects_dir,subject,...
                                                 lh_roi_txt,...
                                                 rh_roi_txt,...
                                                 medial_wall_bool)
% setup for plotting. use this function to obtain verticies and faces of
% the surface, and visualize rois on the surface based on the roi lists
% provided via the text files
%
% INPUTS:
%
% lh_surface_asc:   asc file of cortical surface (example= lh.white.asc)
% rh_surface_asc:   asc file of cortical surface (example= lh.white.asc)
% 
% note: you minimally need these ascii surfaces to do viz; if you would
% like to viz data in a parcellation, you should provide the opt inputs
%
% OPTIONAL INPUTS:
%
% subjects_dir: SUBJECTS_DIR in FreeSurfer
% subject:          subject in SUBJECTS_DIR (usually your fsaverage subject)
% lh_roi_txt:       text file listing ROI names in LH (no file prefix or 
%                   suffix)
% rh_roi_txt:       text file listing ROI names in RH (no file prefix or 
%                   suffix)
% medial_wall_bool: Add the medial wall label (this will increase your list
%                   of roi labels by one)
%
% OUTPUT:
% 
% MATLAB structure with the following fields:
%
% F_{LH,RH}:        faces of surface mesh for {LH,RH}
% V_{LH,RH}:        verticies of surface mesh for {LH,RH}
%
% OUPUTS BASED ON OPTIONAL INPUTS:
%
% label_roi:        [(num ROIs)x2] variable used to describe which parts of
%                   the surface correspond to whoch roi
% roinames:         [1x2] roi names for LH (col 1) and RH (col 2) 
% 
% 06/28/2017 M.Fukushima
% 03/30/2018 J.Faskowitz
% Indiana University
% Computational Cognitive Neurosciene Lab
% See LICENSE file for license
%
% Note: We retain the kind of clunky method for reading in ROIs for two
% reasons: 1) reading in the annot file we cannot be sure which hemisphere
% an ROI belongs to and 2) this method can flexibly accomodate people who
% want to plot only select labels--not the whole parcellation
%

% deal with optional medial wall 
if ~exist('lh_roi_txt','var') || isempty(lh_roi_txt)
    lh_roi_txt = '' ;
end

% deal with optional medial wall 
if ~exist('rh_roi_txt','var') || isempty(rh_roi_txt)
    rh_roi_txt = '' ;
end

% deal with optional medial wall 
if ~exist('medial_wall_bool','var') || isempty(medial_wall_bool)
    medial_wall_bool = 0 ;
end

if (~isempty(lh_roi_txt)) || (~isempty(rh_roi_txt))

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
        
        if fileID > 0
            C = textscan(fileID,'%s');
            fclose(fileID);
            roinames{kk} = C{1}; clear C
            Nrois(kk) = length(roinames{kk});
        else
            roinames{kk} = '' ;
            Nrois(kk) = 0 ;
        end
        
        % possibly add medial wall bool
        if (medial_wall_bool) && (fileID > 0)
            roinames{kk}{end+1} = 'Medial_wall' ;
            Nrois(kk) = Nrois(kk) + 1 ;
        end
    end

    % check_file = strcat(subjects_dir,'/',subject,'/label/lh.',roinames{1}{1},'.label') ;
    % if exist(check_file,'file') == 0
    %    disp('need to run FreeSurfer function "mri_annotation2label" on annot')
    %    disp('before running this program')
    %    exit 1
    % end

    % Read label files
    hemi = {'lh','rh'};
    label_roi = cell(max(Nrois),2);
    for kk = 1:2
      for idx = 1:Nrois(kk)
        lname = strcat(hemi{kk},'.',roinames{kk}{idx});
        label_roi{idx,kk} = read_label(subject,lname);
      end
    end

end

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
dataStruct.label_roi = label_roi ;
dataStruct.roi_names = roinames' ;

