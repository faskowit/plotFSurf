#!/bin/sh

# orig: https://github.com/andersonwinkler/toolbox/blob/master/bin/subj2ascii
# edited by josh faskowitz

# Print usage if no argument is given
if [ -z "$1" ]; then
cat <<EOU
Batch convert surface and DPV (curvature) files from a given 
subject to ASCII format. FreeSurfer must be correctly
configured in the memory, with both \${FREESURFER_HOME}
and \${SUBJECTS_DIR} variables set.

Usage:
subj2ascii <subj_id> <(optinal oDir)>

_____________________________________
Anderson M. Winkler
Yale University / Institute of Living
Jan/2011 (original version)
Jul/2013 (this version)
http://brainder.org
EOU
exit
fi

# Subject ID
SUBJ=$1

# Hemispheres
HEMI="lh rh"

# Surfaces (up to v5.3.0; increase the list as needed for future versions)
# SURF="inflated inflated.nofix orig orig.nofix pial qsphere.nofix smoothwm smoothwm.nofix sphere sphere.reg white"
SURF="inflated orig pial smoothwm white"

# Curvatures (up to v5.3.0; increase the list as needed for future versions)
# CURV="area area.mid area.pial avg_curv curv curv.pial inflated.H inflated.K jacobian_white smoothwm.BE.crv smoothwm.C.crv smoothwm.FI.crv smoothwm.H.crv smoothwm.K1.crv smoothwm.K2.crv smoothwm.K.crv smoothwm.S.crv sulc thickness volume w-g.pct.mgh"
CURV=''

# "Nofix" curvatures (up to v5.3.0; increase the list as needed for future versions)
# CURV_NOFIX="defect_borders defect_chull defect_labels"
CURV_NOFIX=''

# Simplify a bit with a shorter variable
SDIR=${SUBJECTS_DIR}/${SUBJ}/

# Where to store the outputs
if [[ -z $2 ]]
then
    { oDIR=${SDIR}/ascii/ ; mkdir -p ${SDIR}/ascii/ ; } || \
        { oDir=${PWD}/ascii/ ; echo "couldnt write in $SDIR. writing to PWD" ; mkdir -p ${PWD}/ascii ; }
else
    oDir=$2
fi

# For each hemisphere
for h in ${HEMI} ; do

   # For each surface file
   for s in ${SURF} ; do
      if [ -e ${oDir}/surf/${h}.${s} ] ; then
         echo "${oDir}/surf/${h}.${s} -> ${oDir}/ascii/${h}.${s}.srf"
         ${FREESURFER_HOME}/bin/mris_convert ${oDir}/surf/${h}.${s} ${oDir}/ascii/${h}.${s}.asc
         mv ${oDir}/ascii/${h}.${s}.asc ${oDir}/ascii/${h}.${s}.srf
      fi
   done

   # For each curvature file
   for c in ${CURV} ; do
      if [ -e ${oDir}/surf/${h}.${c} ] ; then
         echo "${oDir}/surf/${h}.${c} -> ${oDir}/ascii/${h}.${c}.dpv"
         ${FREESURFER_HOME}/bin/mris_convert -c ${oDir}/surf/${h}.${c} ${oDir}/surf/${h}.white ${oDir}/ascii/${h}.${c}.asc
         mv ${oDir}/ascii/${h}.${c}.asc ${oDir}/ascii/${h}.${c}.dpv
      fi
   done
   
   # For each "nofix" curvature file
   for c in ${CURV_NOFIX} ; do
      if [ -e ${oDir}/surf/${h}.${c} ] ; then
         echo "${oDir}/surf/${h}.${c} -> ${oDir}/ascii/${h}.${c}.dpv"
         ${FREESURFER_HOME}/bin/mris_convert -c ${oDir}/surf/${h}.${c} ${oDir}/surf/${h}.orig.nofix ${oDir}/ascii/${h}.${c}.asc
         mv ${oDir}/ascii/${h}.${c}.asc ${oDir}/ascii/${h}.${c}.dpv
      fi
   done
done
