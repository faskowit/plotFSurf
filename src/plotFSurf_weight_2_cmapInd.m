function [dir_cmap_ind_LH , dir_cmap_ind_RH , cmap] = ...
    plotFSurf_weight_2_cmapInd(weights_LH,weights_RH,weights_unknown,unknown_color,weights_range,cmap)
% internal function for plotSurf
%
% clunky logic handling unknown values; TODO is to clean this up
%
% J.Faskowitz
% Indiana University
% Computational Cognitive Neurosciene Lab
% See LICENSE file for license

% put all weights in one vec
real_weights = [weights_LH ; weights_RH] ;
unkwn_ind = real_weights == weights_unknown ;

% get hemisphere index for this vec (to be used later)
lh_ind = zeros(length(weights_LH)+length(weights_RH),1);
lh_ind(1:length(weights_LH)) = 1 ;
lh_ind = ~~lh_ind ;
rh_ind = ~lh_ind ;

% trim data if requested
if isempty(weights_range)
    upper_lim = max(real_weights(~unkwn_ind)) ;
    lower_lim = min(real_weights(~unkwn_ind)) ;
else
    upper_lim = weights_range(2) ;
    lower_lim = weights_range(1) ;
end

% check if unknown_weights is in range... if so, alert user and quit so a
% better weight for unknown can be picked
if (weights_unknown <= upper_lim) && (weights_unknown >= lower_lim)
    error('weight for unknown value in normal values range. please change')
end

trim_weights = real_weights .* 1 ;
trim_weights(trim_weights > upper_lim) = upper_lim ;
trim_weights(trim_weights < lower_lim) = lower_lim ;

% get the edges of the bins, number of bins equal to how many cmap entries
% there are; this way, each bin represents one color
[~,hist_edges] = histcounts(trim_weights,length(cmap)) ;

% put unknown vals back in
% in trim process they were set to either upper or lower bound
trim_weights(unkwn_ind) = weights_unknown ;

% assign each vertex datapoint into a bin
dir_cmap_ind_LH = discretize(trim_weights(lh_ind),hist_edges) ;
dir_cmap_ind_RH = discretize(trim_weights(rh_ind),hist_edges);

% this sum will be greater than zero if there are values outside the edges
% given to the discretize func. by design (see conditional above) unknown 
% valus will be outside of this range
if sum(unkwn_ind) > 0
    % if there are unknown values... set them to a new color! outside of 
    % the cmap we already have
    dir_cmap_ind_LH(isnan(dir_cmap_ind_LH)) = length(cmap)+1 ;
    dir_cmap_ind_RH(isnan(dir_cmap_ind_RH)) = length(cmap)+1 ;
    cmap = [ cmap ; unknown_color ] ;
end
