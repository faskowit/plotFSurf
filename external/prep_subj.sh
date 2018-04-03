#!/bin/sh

# orig: https://github.com/andersonwinkler/toolbox/blob/master/bin/subj2ascii
# edited by josh faskowitz

# Print usage if no argument is given
if [ -z "$1" ]; then
cat <<EOU
Batch convert surface to ascii. Also convert
annot files to individual labels.

Usage: $(echo ${0}) subjectsDir subjID ouputDir atlasBaseName(opt)

EOU
exit
fi

SUB_DIR=$1
export SUBJECTS_DIR=${SUB_DIR}

# Subject ID
SUBJ=$2

# Hemispheres
HEMI="lh rh"

# Surfaces to convert
SURF="inflated orig pial smoothwm white"

# Simplify a bit with a shorter variable
SDIR=${SUBJECTS_DIR}/${SUBJ}/

# Where to store the outputs
if [[ -z $3 ]]
then
    { oDIR=${SDIR}/plotFSurf_prep/ ; mkdir -p ${SDIR}/plotFSurf_prep/ ; } || \
        { oDir=${PWD}/plotFSurf_prep/ ; echo "couldnt write in $SDIR. writing to PWD" ; mkdir -p ${PWD}/plotFSurf_prep/ ; }
else
    oDir=$3
fi

if [[ -z $4 ]]
then
    ATLAS=''
else
    ATLAS="${4}"
fi

# For each hemisphere
for h in ${HEMI} ; do

    # For each surface file
    for s in ${SURF} ; do
        if [[ -e ${sDir}/surf/${h}.${s} ]] ; then
            echo "${sDir}/surf/${h}.${s} -> ${oDir}/${h}.${s}.srf"
            ${FREESURFER_HOME}/bin/mris_convert ${sDir}/surf/${h}.${s} ${oDir}/${h}.${s}.asc
            # rename to make more understandable
            mv ${oDir}/${h}.${s}.asc ${oDir}/${h}.${s}.srf
        fi
    done

    for a in ${ATLAS} ; do
        
        if [[ -e ${sDir}/label/${h}.${a}.annot ]] ; then
            mri_annotation2label --subject ${SUBJ} --hemi ${h} --annotation ${a} --outdir ${oDir} > ${oDir}/tmp_note.txt
            # create list of labels
            cat ${oDir}/tmp_note.txt | grep "${oDir}.*label" | sed s,.*${oDir}.*${h}.,, | sed s,.label,, > ${oDir}/${h}.label_list.txt
            rm ${oDir}/tmp_note.txt
        else
            echo "could not read atlas: ${sDir}/label/${h}.${a}.annot Please check"
        fi
    done
done









