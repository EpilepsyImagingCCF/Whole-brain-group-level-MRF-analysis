clear all; close all;
addpath T:\Imaging\Multimodal\MRF\Jack\NIfTI_20140122

% input parameters
%%%%%%%%%%%%%%%%%%%
folder = 'T:\Imaging\Multimodal\MRF\Jack\Voxel_wise_MRF';
Set_name = 'rfMRINeg_T1_VBM+';
out_folder_corrFig = fullfile(folder, Set_name, 'correlation_Fig');
if ~exist(out_folder_corrFig)
    mkdir(out_folder_corrFig)
end
%%%%%%%%%%%%%%%%%%%

WM_nii = load_untouch_nii(fullfile(folder, Set_name, 'WM_TFCE_co', 'MRINeg_T1_tstat2_thr.nii'));
WM_vol = WM_nii.img;
WM_vol_bw = zeros(size(WM_vol));
WM_vol_bw(find(WM_vol)) = 1;
WM_vol_bw_dil = imgaussfilt(WM_vol_bw, 1) > 0;
% imdilate(WM_vol_bw, strel("sphere",2));

GM_nii = load_untouch_nii(fullfile(folder, Set_name, 'GM_TFCE_co', 'MRINeg_T1_tstat2_thr.nii'));
GM_vol = GM_nii.img;
GM_vol_bw = zeros(size(GM_vol));
GM_vol_bw(find(GM_vol)) = 1;
GM_vol_bw_dil = imgaussfilt(GM_vol_bw, 1) > 0;
% imdilate(GM_vol_bw, strel("sphere",2));

WM_nii.img = WM_vol_bw;
GM_nii.img = GM_vol_bw;

save_untouch_nii(GM_nii, fullfile(folder, Set_name, 'GM_TFCE_co', 'MRINeg_T1_tstat2_thr_bin.nii'))
save_untouch_nii(WM_nii, fullfile(folder, Set_name, 'WM_TFCE_co', 'MRINeg_T1_tstat2_thr_bin.nii'))

% WM_vol_bw_L = bwlabeln(WM_vol_bw);
WM_vol_bw_dil_L = bwlabeln(WM_vol_bw_dil);
% [max(WM_vol_bw_L(:)), max(WM_vol_bw_dil_L(:))]

% GM_vol_bw_L = bwlabeln(GM_vol_bw);
GM_vol_bw_dil_L = bwlabeln(GM_vol_bw_dil);
% [max(GM_vol_bw_L(:)), max(GM_vol_bw_dil_L(:))]

WM_vol_bw_dil_L_proc = zeros(size(WM_vol_bw_dil_L));
GM_vol_bw_dil_L_proc = zeros(size(GM_vol_bw_dil_L));
for order = 1:max(WM_vol_bw_dil_L(:))
    tmp = zeros(size(WM_vol_bw_dil_L));
    tmp(find(WM_vol_bw_dil_L == order)) = 1;
    WM_vol_bw_dil_L_proc = WM_vol_bw_dil_L_proc + (WM_vol_bw.*tmp) * order;
    clear tmp
end
for order = 1:max(GM_vol_bw_dil_L(:))
    tmp = zeros(size(GM_vol_bw_dil_L));
    tmp(find(GM_vol_bw_dil_L == order)) = 1;
    GM_vol_bw_dil_L_proc = GM_vol_bw_dil_L_proc + (GM_vol_bw.*tmp) * order;
    clear tmp
end
WM_nii.img = WM_vol_bw_dil_L_proc;
GM_nii.img = GM_vol_bw_dil_L_proc;

save_untouch_nii(GM_nii, fullfile(folder, Set_name, 'GM_TFCE_co', 'GM_co_vol_bw_s1mm_cluster.nii'))
save_untouch_nii(WM_nii, fullfile(folder, Set_name, 'WM_TFCE_co', 'WM_co_vol_bw_s1mm_cluster.nii'))