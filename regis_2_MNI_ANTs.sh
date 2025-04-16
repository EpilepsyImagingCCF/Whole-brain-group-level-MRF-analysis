#!/bin/bash

output_folder=${1}
transform_type=s

MNI_template=path/to/MNI152_T1_1mm_brain.nii

antsRegistrationSyN.sh -d 3 \
	-m path/to/input.nii \
        -f ${MNI_template} \
	-t ${transform_type} \
	-n 3 \
        -o ${output_folder}/Reg_MRF_2_MNI_${transform_type}_

antsApplyTransforms -d 3 -i path/to/input.nii \
	-o ${output_folder}/output.nii \
	-r ${MNI_template} \
        -t ${output_folder}/Reg_MRF_2_MNI_${transform_type}_1Warp.nii.gz \
        -t ${output_folder}/Reg_MRF_2_MNI_${transform_type}_0GenericAffine.mat
