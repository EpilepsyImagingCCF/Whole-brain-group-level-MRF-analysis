Set_name=${1}
modality=${2}

mkdir ${Set_name}/GM_TFCE_sm
mkdir ${Set_name}/GM_TFCE_co_sm
mkdir ${Set_name}/WM_TFCE_sm
mkdir ${Set_name}/WM_TFCE_co_sm

randomise -i ${Set_name}/sMRINeg_${modality}_4D_input.nii.gz \
	-o ${Set_name}/WM_TFCE_sm/MRINeg_${Set_name} \
	--uncorrp \
        -d ${Set_name}/design.mat \
        -t ${Set_name}/design.con \
        -m MNI152_WM_mask_final.nii.gz \
        -n 1000 \
        -T

randomise -i ${Set_name}/sMRINeg_${modality}_4D_input.nii.gz \
        -o ${Set_name}/GM_TFCE_sm/MRINeg_${Set_name} \
	--uncorrp \
        -d ${Set_name}/design.mat \
        -t ${Set_name}/design.con \
        -m MNI152_GM_mask_final.nii.gz \
        -n 1000 \
        -T

randomise -i ${Set_name}/sMRINeg_${modality}_4D_input.nii.gz \
        -o ${Set_name}/WM_TFCE_co_sm/MRINeg_${Set_name} \
	--uncorrp \
        -d ${Set_name}/design_co.mat \
        -t ${Set_name}/design_co.con \
        -m MNI152_WM_mask_final.nii.gz \
        -n 1000 \
        -T

randomise -i ${Set_name}/sMRINeg_${modality}_4D_input.nii.gz \
        -o ${Set_name}/GM_TFCE_co_sm/MRINeg_${Set_name} \
	--uncorrp \
        -d ${Set_name}/design_co.mat \
        -t ${Set_name}/design_co.con \
        -m MNI152_GM_mask_final.nii.gz \
        -n 1000 \
        -T
