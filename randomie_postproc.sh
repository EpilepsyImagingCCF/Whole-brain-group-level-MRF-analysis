folder=${1}
modality=${2}
for subfolder in ${folder}/*/
do
	echo ${subfolder}

	corrp_tstat1=`echo ${subfolder}*tfce_corrp_tstat1.nii.gz | cut -d'.' -f1`
	corrp_tstat2=`echo ${subfolder}*tfce_corrp_tstat2.nii.gz | cut -d'.' -f1`
	p_tstat1=`echo ${subfolder}*tfce_p_tstat1.nii.gz | cut -d'.' -f1`
	p_tstat2=`echo ${subfolder}*tfce_p_tstat2.nii.gz | cut -d'.' -f1`
	tstat1=`echo ${subfolder}*${modality}_tstat1.nii.gz | cut -d'.' -f1`
        tstat2=`echo ${subfolder}*${modality}_tstat2.nii.gz | cut -d'.' -f1`

	fslmaths ${corrp_tstat1} -thr 0.95 -bin ${corrp_tstat1}_thr095_bin
	fslmaths ${corrp_tstat2} -thr 0.95 -bin ${corrp_tstat2}_thr095_bin
	fslmaths ${p_tstat1} -thr 0.95 -bin ${p_tstat1}_thr095_bin
	fslmaths ${p_tstat2} -thr 0.95 -bin ${p_tstat2}_thr095_bin

	fslmaths MNI152_T1_1mm_brain_mask -sub ${corrp_tstat1} ${corrp_tstat1}_inv
	fslmaths MNI152_T1_1mm_brain_mask -sub ${corrp_tstat2} ${corrp_tstat2}_inv
	fslmaths MNI152_T1_1mm_brain_mask -sub ${p_tstat1} ${p_tstat1}_inv
	fslmaths MNI152_T1_1mm_brain_mask -sub ${p_tstat2} ${p_tstat2}_inv

	fslmaths ${corrp_tstat1}_thr095_bin -mul ${corrp_tstat1}_inv ${corrp_tstat1}_inv_thr005
	fslmaths ${corrp_tstat2}_thr095_bin -mul ${corrp_tstat2}_inv ${corrp_tstat2}_inv_thr005
	fslmaths ${p_tstat1}_thr095_bin -mul ${p_tstat1}_inv ${p_tstat1}_inv_thr005
	fslmaths ${p_tstat2}_thr095_bin -mul ${p_tstat2}_inv ${p_tstat2}_inv_thr005

	fslmaths ${corrp_tstat1}_thr095_bin -mul ${tstat1} ${tstat1}_thr
        fslmaths ${corrp_tstat2}_thr095_bin -mul ${tstat2} ${tstat2}_thr

	gunzip -k ${corrp_tstat1}_inv_thr005.nii.gz
	gunzip -k ${corrp_tstat2}_inv_thr005.nii.gz
	gunzip -k ${p_tstat1}_inv_thr005.nii.gz
	gunzip -k ${p_tstat2}_inv_thr005.nii.gz

	gunzip -k -f ${tstat1}_thr.nii.gz
        gunzip -k -f ${tstat2}_thr.nii.gz
        gunzip -k -f ${tstat1}.nii.gz
        gunzip -k -f ${tstat2}.nii.gz		
done
