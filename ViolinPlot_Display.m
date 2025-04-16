clear all; close all; 
folder = 'T:\Imaging\Multimodal\MRF\Jack\Voxel_wise_MRF';
% folder = '/Volumes/eegrvw/Imaging/Multimodal/MRF/Jack/Voxel_wise_MRF';
HC_folder = 'T:\Imaging\Multimodal\MRF\Jack\Voxel_wise_MRF\T1';
% HC_folder = '/Volumes/eegrvw/Imaging/Multimodal/MRF/Jack/Voxel_wise_MRF/T1';
Set_name = 'rfMRINeg_T1_VBM+';
addpath T:\Imaging\Multimodal\MRF\Jack\NIfTI_20140122
%% Extract value
HC_T1 = dir(fullfile(HC_folder, 'CON*'));
PT_T1 = dir(fullfile(folder, Set_name, 'PAT*'));

WM_co_bw_nii = load_untouch_nii(fullfile(folder, Set_name, 'WM_TFCE_co', 'WM_co_vol_bw_s1mm_cluster.nii'));
WM_co_vol_bw_s1mm_cluster_slt = WM_co_bw_nii.img;
GM_co_bw_nii = load_untouch_nii(fullfile(folder, Set_name, 'GM_TFCE_co', 'GM_co_vol_bw_s1mm_cluster.nii'));
GM_co_vol_bw_s1mm_cluster_slt = GM_co_bw_nii.img;

% WM
cluster_num = max(WM_co_vol_bw_s1mm_cluster_slt(:));
for cluster = 1:cluster_num
    WM_cluster_size(cluster, 1) = length(find(WM_co_vol_bw_s1mm_cluster_slt == cluster));
    for order = 1:length(HC_T1)
        disp(['WM; HC; ' num2str(order) '; '  num2str(length(HC_T1))])
        vol_nii = load_untouch_nii(fullfile(HC_T1(order).folder, HC_T1(order).name));
        vol = vol_nii.img;
        WM_label{order, 1} = 'HC';
        WM_HC_cluster_mean(order, cluster) = mean(vol(find(WM_co_vol_bw_s1mm_cluster_slt == cluster)));
        clear vol_info vol
    end
end

buffer = length(WM_label);
for cluster = 1:cluster_num
        for order = 1:length(PT_T1)
            disp(['WM; PT; ' num2str(order) '; '  num2str(length(PT_T1))])
            vol_nii = load_untouch_nii(fullfile(PT_T1(order).folder, PT_T1(order).name));
            vol = double(vol_nii.img);
            WM_label{buffer + order, 1} = 'PT';
            WM_PT_cluster_mean(order, cluster) = mean(vol(find(WM_co_vol_bw_s1mm_cluster_slt == cluster)));
            clear vol_info vol
        end
end
WM_cluster_mean = [WM_HC_cluster_mean; WM_PT_cluster_mean];

% ttest2
for cluster = 1:size(WM_cluster_mean, 2)
    [~,p] = ttest2(WM_HC_cluster_mean(:, cluster), WM_PT_cluster_mean(:, cluster));
    [h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(p);
    WM_cluster_fdr_bh(cluster, 1) = adj_p;
    WM_cluster_mafdr(cluster, 1) = mafdr(p, 'BHFDR', true);
    WM_cluster_p(cluster, 1) = p;
    
    WM_cluster_HC_T1avg_mean(cluster, 1) = mean(WM_HC_cluster_mean(:, cluster));
    WM_cluster_PT_T1avg_mean(cluster, 1) = mean(WM_PT_cluster_mean(:, cluster));
    WM_cluster_HC_T1avg_std(cluster, 1) = std(WM_HC_cluster_mean(:, cluster));
    WM_cluster_PT_T1avg_std(cluster, 1) = std(WM_PT_cluster_mean(:, cluster));
    clear adj_p h crit_p adj_ci_cvrg p
end
WM_list = [WM_cluster_mafdr, WM_cluster_HC_T1avg_mean, WM_cluster_PT_T1avg_mean, WM_cluster_HC_T1avg_std, WM_cluster_PT_T1avg_std];

% vcol = [1 0 0; 0.8 0.4 .2; 0 0.9 0 ; 0 0 0.9];
% for cluster = 1:size(WM_cluster_mean, 2)
%     figure, 
%     vs = violinplot2(WM_cluster_mean(:, cluster), cellstr(WM_label));
%     vs(1).ViolinColor = vcol(1,:);
%     vs(2).ViolinColor = vcol(3,:);
%     title(['WM cluster ' num2str(cluster) ' average']);
%     saveas(gcf, fullfile(folder, 'WM_TFCE_co', ['WM_cluster_' num2str(cluster) '_average_clusterSZ_' num2str(WM_cluster_size(cluster)) '.png']))
%     close all;
% end

% GM
cluster_num = max(GM_co_vol_bw_s1mm_cluster_slt(:));
for cluster = 1:cluster_num
    GM_cluster_size(cluster, 1) = length(find(GM_co_vol_bw_s1mm_cluster_slt == cluster));
    for order = 1:length(HC_T1)
        disp(['GM; HC; ' num2str(order) '; '  num2str(length(HC_T1))])
        vol_nii = load_untouch_nii(fullfile(HC_T1(order).folder, HC_T1(order).name));
        vol = double(vol_nii.img);
        GM_label{order, 1} = 'HC';
        GM_HC_cluster_mean(order, cluster) = mean(vol(find(GM_co_vol_bw_s1mm_cluster_slt == cluster)));
        clear vol_info vol
    end
end

buffer = length(GM_label);
for cluster = 1:cluster_num
    for order = 1:length(PT_T1)
        disp(['GM; PT; ' num2str(order) '; '  num2str(length(PT_T1))])
        vol_nii = load_untouch_nii(fullfile(PT_T1(order).folder, PT_T1(order).name));
        vol = double(vol_nii.img);
        GM_label{buffer + order, 1} = 'PT';
        GM_PT_cluster_mean(order, cluster) = mean(vol(find(GM_co_vol_bw_s1mm_cluster_slt == cluster)));
        clear vol_info vol
    end
end
GM_cluster_mean = [GM_HC_cluster_mean; GM_PT_cluster_mean];

% ttest2
for cluster = 1:size(GM_cluster_mean, 2)
    [~,p] = ttest2(GM_HC_cluster_mean(:, cluster), GM_PT_cluster_mean(:, cluster));
    [h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(p);
    GM_cluster_fdr_bh(cluster, 1) = adj_p;
    GM_cluster_mafdr(cluster, 1) = mafdr(p, 'BHFDR', true);
    
    GM_cluster_HC_T1avg_mean(cluster, 1) = mean(GM_HC_cluster_mean(:, cluster));
    GM_cluster_PT_T1avg_mean(cluster, 1) = mean(GM_PT_cluster_mean(:, cluster));
    GM_cluster_HC_T1avg_std(cluster, 1) = std(GM_HC_cluster_mean(:, cluster));
    GM_cluster_PT_T1avg_std(cluster, 1) = std(GM_PT_cluster_mean(:, cluster));
    clear adj_p h crit_p adj_ci_cvrg p
end
GM_list = [GM_cluster_mafdr, GM_cluster_HC_T1avg_mean, GM_cluster_PT_T1avg_mean, GM_cluster_HC_T1avg_std, GM_cluster_PT_T1avg_std];

save('tmp.mat', 'WM_list', 'GM_list')
% for cluster = 1:size(GM_cluster_mean, 2)
%     figure, 
%     vcol = [1 0 0; 0.8 0.4 .2; 0 0.9 0 ; 0 0 0.9];
%     vs = violinplot2(GM_cluster_mean(:, cluster), cellstr(GM_label));
%     vs(1).ViolinColor = vcol(1,:);
%     vs(2).ViolinColor = vcol(3,:);
%     title(['GM cluster ' num2str(cluster) ' average']);
%     saveas(gcf, fullfile(folder, 'GM_TFCE_co', ['GM_cluster_' num2str(cluster) '_average_clusterSZ_' num2str(GM_cluster_size(cluster)) '.png']))
%     close all;
% end
%%

% niftiwrite(bwlabeln(imgaussfilt(GM_co_vol, 2) > 0, 26), fullfile(folder, 'GM_TFCE_co', 'GM_co_vol_bw_L.nii'))
% for order = 37:182
% subplot(121); imshow(vol(:, :, order), []); title(num2str(order));subplot(122); imshow(WM_co_vol_bw(:, :, order), [])
% pause()
% end
