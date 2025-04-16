Set_name=${1}
modality=${2}

mkdir ${Set_name}/GM_TFCE
mkdir ${Set_name}/GM_TFCE_co
mkdir ${Set_name}/WM_TFCE
mkdir ${Set_name}/WM_TFCE_co

randomise -i ${Set_name}/MRINeg_${modality}_4D_input.nii.gz \
	-o ${Set_name}/WM_TFCE/MRINeg_${Set_name} \
	--uncorrp \
        -d ${Set_name}/design.mat \
        -t ${Set_name}/design.con \
        -m MNI152_WM_mask_final.nii.gz \
        -n 1000 \
        -T

randomise -i ${Set_name}/MRINeg_${modality}_4D_input.nii.gz \
        -o ${Set_name}/GM_TFCE/MRINeg_${Set_name} \
	--uncorrp \
        -d ${Set_name}/design.mat \
        -t ${Set_name}/design.con \
        -m MNI152_GM_mask_final.nii.gz \
        -n 1000 \
        -T

randomise -i ${Set_name}/MRINeg_${modality}_4D_input.nii.gz \
        -o ${Set_name}/WM_TFCE_co/MRINeg_${Set_name} \
	--uncorrp \
        -d ${Set_name}/design_co.mat \
        -t ${Set_name}/design_co.con \
        -m MNI152_WM_mask_final.nii.gz \
        -n 1000 \
        -T

randomise -i ${Set_name}/MRINeg_${modality}_4D_input.nii.gz \
        -o ${Set_name}/GM_TFCE_co/MRINeg_${Set_name} \
	--uncorrp \
        -d ${Set_name}/design_co.mat \
        -t ${Set_name}/design_co.con \
        -m MNI152_GM_mask_final.nii.gz \
        -n 1000 \
        -T
