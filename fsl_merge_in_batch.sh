in_folder=${1}

group1_prefix=${in_folder}/"CON"
group2_prefix=${out_folder}"/PAT"

################################################ For T1
out_filename='sMRINeg_T1_4D_input.nii.gz'

buffer=""
for file in ${group1_prefix}*.nii.gz; do
	echo ${file}
	buffer="${buffer} ${file}"
done

for file in ${group2_prefix}*.nii.gz; do
        echo ${file}
	buffer="${buffer} ${file}"
done

fslmerge -t ${in_folder}/${out_filename} ${buffer}

################################################ For T2
out_filename='sMRINeg_T2_4D_input.nii.gz'

buffer=""
for file in ${group1_prefix}*.nii.gz; do
	echo ${file}
	buffer="${buffer} ${file}"
done

for file in ${group2_prefix}*.nii.gz; do
        echo ${file}
	buffer="${buffer} ${file}"
done

fslmerge -t ${in_folder}/${out_filename} ${buffer}