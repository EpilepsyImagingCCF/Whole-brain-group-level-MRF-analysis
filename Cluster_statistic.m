clear all; close all; 
folder = 'T:\Imaging\Multimodal\MRF\Jack\Voxel_wise_MRF';
Set_name = 'rfMRINeg_T1_VBM+';

WM_co_bw_nii = load_untouch_nii(fullfile(folder, Set_name, 'WM_TFCE_co', 'WM_co_vol_bw_s1mm_cluster.nii'));
WM_co_bw_vol = double(WM_co_bw_nii.img);
GM_co_bw_nii = load_untouch_nii(fullfile(folder, Set_name, 'GM_TFCE_co', 'GM_co_vol_bw_s1mm_cluster.nii'));
GM_co_bw_vol = double(GM_co_bw_nii.img);

WM_co_T_nii = load_untouch_nii(fullfile(folder, Set_name, 'WM_TFCE_co', 'MRINeg_T1_tstat2.nii'));
WM_co_T_vol = double(WM_co_T_nii.img);
GM_co_T_nii = load_untouch_nii(fullfile(folder, Set_name, 'GM_TFCE_co', 'MRINeg_T1_tstat2.nii'));
GM_co_T_vol = double(GM_co_T_nii.img);

WM_co_P_nii = load_untouch_nii(fullfile(folder, Set_name, 'WM_TFCE_co', 'MRINeg_T1_tfce_corrp_tstat2_inv_thr005.nii'));
WM_co_P_vol = double(WM_co_P_nii.img);
GM_co_P_nii = load_untouch_nii(fullfile(folder, Set_name, 'GM_TFCE_co', 'MRINeg_T1_tfce_corrp_tstat2_inv_thr005.nii'));
GM_co_P_vol = double(GM_co_P_nii.img);

% for order = 47:182
% subplot(121); imshow(WM_co_bw_vol(:, :, order), []); title(num2str(order));subplot(122); imshow(WM_co_T_vol(:, :, order), [])
% pause()
% end

% WM
cluster_num = max(WM_co_bw_vol(:));
for order = 1:cluster_num
    cluster = zeros(size(WM_co_bw_vol));
    cluster(find(WM_co_bw_vol == order)) = 1;
    % cluster size
    WM_cluster_sz(order, 1) = length(find(cluster));
    
    WM_co_T_vol_buffer = cluster.*WM_co_T_vol;
    [x, y, z] = ind2sub(size(WM_co_T_vol_buffer), find(WM_co_T_vol_buffer == max(WM_co_T_vol_buffer(:))));
    % maximum t value
    WM_cluster_Tmax(order, 1) = WM_co_T_vol(x, y, z);
    % MNI coordinate
    WM_cluster_MNIcoor(order, 1) = x;
    WM_cluster_MNIcoor(order, 2) = y;
    WM_cluster_MNIcoor(order, 3) = z;
    % corresponding p value
    WM_cluster_Ppeak(order, 1) = WM_co_P_vol(x, y, z);
    clear x y z WM_co_T_vol_buffer cluster
end

WM_statistic_T = [WM_cluster_sz, WM_cluster_Tmax, WM_cluster_Ppeak, WM_cluster_MNIcoor];

% GM
cluster_num = max(GM_co_bw_vol(:));
for order = 1:cluster_num
    cluster = zeros(size(GM_co_bw_vol));
    cluster(find(GM_co_bw_vol == order)) = 1;
    % cluster size
    GM_cluster_sz(order, 1) = length(find(cluster));
    
    GM_co_T_vol_buffer = cluster.*GM_co_T_vol;
    [x, y, z] = ind2sub(size(GM_co_T_vol_buffer), find(GM_co_T_vol_buffer == max(GM_co_T_vol_buffer(:))));
    % maximum t value
    GM_cluster_Tmax(order, 1) = GM_co_T_vol(x, y, z);
    % MNI coordinate
    GM_cluster_MNIcoor(order, 1) = x;
    GM_cluster_MNIcoor(order, 2) = y;
    GM_cluster_MNIcoor(order, 3) = z;
    % corresponding p value
    GM_cluster_Ppeak(order, 1) = GM_co_P_vol(x, y, z);
    clear x y z WM_co_T_vol_buffer cluster
end

GM_statistic_T = [GM_cluster_sz, GM_cluster_Tmax, GM_cluster_Ppeak, GM_cluster_MNIcoor];
