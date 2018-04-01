function [F,V] = plotFSurf_load_surf(ascfile)
% utility function to load ascii surface file
%
% M.Fukushima
% Indiana University
% Computational Cognitive Neurosciene Lab
% See LICENSE file for license

fid = fopen(ascfile,'r');
fgetl(fid);
tmp = fscanf(fid,'%d %d',2);
NV = tmp(1);
NF = tmp(2);
tmp = fscanf(fid,'%e %e %e %e',inf);
V = reshape(tmp(1:NV*4),[4 NV])';
F = reshape(tmp(NV*4+1:end),[4 NF])';
V = V(:,1:3);
F = F(:,1:3)+1;
fclose(fid);