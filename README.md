# MRI-Negative Focal Epilepsy Analysis Pipeline Using MR Fingerprinting
This repository accompanies the research paper:

Su TY, Tang Y, Choi JY, Hu S, Sakaie K, Murakami H, Jones S, Blümcke I, Najm I, Ma D, Wang ZI.
Evaluating whole-brain tissue-property changes in MRI-negative pharmacoresistant focal epilepsies using MR fingerprinting.
Epilepsia. 2023 Feb;64(2):430–442. doi: 10.1111/epi.17488

## Pipeline Overview
This pipeline outlines the preprocessing and group-level analysis steps used in our study.  

**1. Threshold MRF T2 Map**  
Apply a threshold (e.g., 400) to the MRF T2 image. This value can be adjusted depending on the modality.  
Example command:  
fslmaths input.nii -uthr 400 output.nii  
Reference: https://open.win.ox.ac.uk/pages/fslcourse/practicals/intro3/index.html  

**2. Skull Stripping with FSL BET**  
Perform brain extraction using FSL's BET tool.  
Reference: https://web.mit.edu/fsl_v5.0.10/fsl/doc/wiki/BET(2f)UserGuide.html

**3. Registration to MNI Space (ANTs)**  
Register all patient images to MNI space using ANTs.  
Script: regis_2_MNI_ANTs.sh  
Reference: https://github.com/ANTsX/ANTs

**4. Flip Right-Hemisphere Cases to Left**  
For patients with right-sided epilepsy, flip the brain to left to align lesion lateralization.  
Example command:  
fslswapdim Patient.nii -x y z Patient_flipped.nii  
Reference: https://johnmuschelli.com/fslr/reference/fslswapdim.html  

**5. Linear Registration After Flipping**  
Register the flipped brain to the original using FSL FLIRT.  
Example command:  
flirt -in Patient_flipped.nii -ref Patient.nii -out Patient_flipped_regis.nii -omat Patient_flipped_regis.mat -dof 6  
Reference: https://web.mit.edu/fsl_v5.0.10/fsl/doc/wiki/FLIRT(2f)UserGuide.html  

**6. Data Organization**  
Organize your data in the following structure:  
Data/  
  T1/  
    Patient01.nii  
    Patient02.nii  
    ...  
    HCs01.nii  
    HCs02.nii  
    ...  
  T2/  
    Patient01.nii  
    Patient02.nii  
    ...  
    HCs01.nii  
    HCs02.nii  
    ...  
    
**7. (Optional) Spatial Smoothing with SPM**  
Apply smoothing using a Gaussian kernel to improve signal-to-noise ratio.  
Reference: https://andysbrainbook.readthedocs.io/en/latest/SPM/SPM_Short_Course/SPM_04_Preprocessing/06_SPM_Smoothing.html  

**8. Save Smoothed Files**  
Place the smoothed images into the same directory structure as above.  

**9. Merge NIfTI Files**  
Use fsl_merge_in_batch.sh to combine images within the same modality into a 4D file.  

**10. Design Matrix and Contrast Files**  
Generate design.mat and design.con files based on study design and covariates (e.g., age, gender, handedness).  

**11. Run Group-Level Analysis**  
Use FSL’s randomise function for non-parametric permutation testing.  
Script: run_randomise.sh  
Reference: https://web.mit.edu/fsl_v5.0.10/fsl/doc/wiki/Randomise(2f)UserGuide.html  

**12. Post-Processing & Statistics**  
Cluster_definition.m: Smooth the output (Gaussian filter, sigma=1) and define clusters.  
Cluster_statistic.m: Extract cluster size, peak p-/t-values, and MNI coordinates.  
Clinical_Correlation.m: Load clinical variables from an Excel file and compute Pearson correlations with MRF values.  
ViolinPlot_Display.m: Create violin plots for clusters showing significant PT vs HC differences.  
