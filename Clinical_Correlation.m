clear all; close all;

% input parameters
%%%%%%%%%%%%%%%%%%%
% folder = 'T:\Imaging\Multimodal\MRF\Jack\Voxel_wise_MRF';
folder = '/Volumes/eegrvw/Imaging/Multimodal/MRF/Jack/Voxel_wise_MRF';

Set_name = 'rfMRINeg_T1_VBM+';
out_folder_corrFig = fullfile(folder, Set_name, 'correlation_Fig');
if ~exist(out_folder_corrFig)
    mkdir(out_folder_corrFig)
end
%%%%%%%%%%%%%%%%%%%
WM_co_bw_info = niftiinfo(fullfile(folder, Set_name, 'WM_TFCE_co', 'WM_co_vol_bw_s1mm_cluster.nii'));
WM_co_vol_bw = double(niftiread(WM_co_bw_info));
GM_co_bw_info = niftiinfo(fullfile(folder, Set_name, 'GM_TFCE_co', 'GM_co_vol_bw_s1mm_cluster.nii'));
GM_co_vol_bw = double(niftiread(GM_co_bw_info));

% WM_co_vol_bw = bwlabeln(WM_co_vol > 0, 26);
% GM_co_vol_bw =  bwlabeln(GM_co_vol > 0, 26);

filename = 'For_Jack_MRI_neg_VBM+.xlsx';
pts_table = readtable(fullfile(folder, filename), 'ReadVariableNames', 1);
pts_cell = table2cell(pts_table);
Header_name = pts_table.Properties.VariableNames;

idx_studyNum = find(strcmp(Header_name, 'study_number'));
idx_age = find(strcmp(Header_name, 'age'));
idx_ED = find(strcmp(Header_name, 'ED_y_'));
idx_SeizureFreq = find(strcmp(Header_name, 'SeizureFrequencyPerYear'));

for order = 1:size(pts_cell, 1)
    if ~isnan(pts_cell{order, idx_studyNum})
        List_studyNum{order, 1} = num2str(pts_cell{order, idx_studyNum});
        List_age(order, 1) = pts_cell{order, idx_age};
        List_ED(order, 1) = pts_cell{order, idx_ED};
        List_SeizureFreq(order, 1) = pts_cell{order, idx_SeizureFreq};
        List_OnsetAge(order, 1) = pts_cell{order, idx_age} - pts_cell{order, idx_ED};
    end
end

%% Pearson correlation
PT_T1 = dir(fullfile(folder, Set_name, 'PAT*'));

% WM
cluster_num = max(WM_co_vol_bw(:));
for cluster = 1:cluster_num
        for order = 1:length(PT_T1)
            strcmpt = strsplit(PT_T1(order).name, {'_', '.'});
            List_idx = find(strcmp(List_studyNum, strcmpt{2}));
            age(order, cluster) = List_age(List_idx);
            ED(order, cluster) = List_ED(List_idx);
            SeizureFreq(order, cluster) = List_SeizureFreq(List_idx);
            OnsetAge(order, cluster) = List_OnsetAge(List_idx);
            clear List_idx strcmpt
            
            vol_info = niftiinfo(fullfile(PT_T1(order).folder, PT_T1(order).name));
            vol = double(niftiread(vol_info));
            WM_PT_cluster_mean(order, cluster) = mean(vol(find(WM_co_vol_bw == cluster)));
            clear vol_info vol
        end
end

for cluster = 1:cluster_num
    [rho, pval] = corr(age(:, cluster), WM_PT_cluster_mean(:, cluster), 'Type', 'Pearson'); %Spearman
    GenCorrFig(age(:, cluster), WM_PT_cluster_mean(:, cluster), 'Age', rho, pval, fullfile(out_folder_corrFig, ['WM_' 'cluster' num2str(cluster) '_' 'Age.png']))
    WM_cluster_age_rho(cluster, 1) = rho;
    WM_cluster_age_pval(cluster, 1) = pval;
    clear rho  pval
    
    [rho, pval] = corr(ED(:, cluster), WM_PT_cluster_mean(:, cluster), 'Type', 'Pearson');
    GenCorrFig(ED(:, cluster), WM_PT_cluster_mean(:, cluster), 'Epilepsy Duration', rho, pval, fullfile(out_folder_corrFig, ['WM_' 'cluster' num2str(cluster) '_' 'ED.png']))
    WM_cluster_ED_rho(cluster, 1) = rho;
    WM_cluster_ED_pval(cluster, 1) = pval;
    clear rho  pval
    
    [rho, pval] = corr(SeizureFreq(:, cluster), WM_PT_cluster_mean(:, cluster), 'Type', 'Spearman');
    GenCorrFig(SeizureFreq(:, cluster), WM_PT_cluster_mean(:, cluster), 'Seizure Frequency', rho, pval, fullfile(out_folder_corrFig, ['WM_' 'cluster' num2str(cluster) '_' 'SeizureFreq.png']))
    WM_cluster_SeizureFreq_rho(cluster, 1) = rho;
    WM_cluster_SeizureFreq_pval(cluster, 1) = pval;
    clear rho  pval
    
    [rho, pval] = corr(OnsetAge(:, cluster), WM_PT_cluster_mean(:, cluster), 'Type', 'Pearson');
    GenCorrFig(OnsetAge(:, cluster), WM_PT_cluster_mean(:, cluster), 'Onset Age', rho, pval, fullfile(out_folder_corrFig, ['WM_' 'cluster' num2str(cluster) '_' 'OnsetAge.png']))
    WM_cluster_OnsetAge_rho(cluster, 1) = rho;
    WM_cluster_OnsetAge_pval(cluster, 1) = pval;
    clear rho  pval
end
WM_corr_T = [WM_cluster_age_rho, WM_cluster_age_pval, WM_cluster_ED_rho, WM_cluster_ED_pval, ...
        WM_cluster_SeizureFreq_rho, WM_cluster_SeizureFreq_pval, WM_cluster_OnsetAge_rho, WM_cluster_OnsetAge_pval];

% GM
cluster_num = max(GM_co_vol_bw(:));
for cluster = 1:cluster_num
        for order = 1:length(PT_T1)
            strcmpt = strsplit(PT_T1(order).name, {'_', '.'});
            List_idx = find(strcmp(List_studyNum, strcmpt{2}));
            age(order, cluster) = List_age(List_idx);
            ED(order, cluster) = List_ED(List_idx);
            SeizureFreq(order, cluster) = List_SeizureFreq(List_idx);
            OnsetAge(order, cluster) = List_OnsetAge(List_idx);
            clear List_idx strcmpt
            
            vol_info = niftiinfo(fullfile(PT_T1(order).folder, PT_T1(order).name));
            vol = double(niftiread(vol_info));
            GM_PT_cluster_mean(order, cluster) = mean(vol(find(GM_co_vol_bw == cluster)));
            clear vol_info vol
        end
end

for cluster = 1:cluster_num
    [rho, pval] = corr(age(:, cluster), GM_PT_cluster_mean(:, cluster), 'Type', 'Pearson');
    GenCorrFig(age(:, cluster), GM_PT_cluster_mean(:, cluster), 'Age', rho, pval, fullfile(out_folder_corrFig, ['GM_' 'cluster' num2str(cluster) '_' 'Age.png']))
    GM_cluster_age_rho(cluster, 1) = rho;
    GM_cluster_age_pval(cluster, 1) = pval;
    clear rho  pval
    
    [rho, pval] = corr(ED(:, cluster), GM_PT_cluster_mean(:, cluster), 'Type', 'Pearson');
    GenCorrFig(ED(:, cluster), GM_PT_cluster_mean(:, cluster), 'Epilepsy Duration', rho, pval, fullfile(out_folder_corrFig, ['GM_' 'cluster' num2str(cluster) '_' 'ED.png']))
    GM_cluster_ED_rho(cluster, 1) = rho;
    GM_cluster_ED_pval(cluster, 1) = pval;
    clear rho  pval
    
    [rho, pval] = corr(SeizureFreq(:, cluster), GM_PT_cluster_mean(:, cluster), 'Type', 'Spearman');
    GenCorrFig(SeizureFreq(:, cluster), GM_PT_cluster_mean(:, cluster), 'Seizure Frequency', rho, pval, fullfile(out_folder_corrFig, ['GM_' 'cluster' num2str(cluster) '_' 'SeizureFreq.png']))
    GM_cluster_SeizureFreq_rho(cluster, 1) = rho;
    GM_cluster_SeizureFreq_pval(cluster, 1) = pval;
    clear rho  pval
    
    [rho, pval] = corr(OnsetAge(:, cluster), GM_PT_cluster_mean(:, cluster), 'Type', 'Pearson');
    GenCorrFig(OnsetAge(:, cluster), GM_PT_cluster_mean(:, cluster), 'Onset Age', rho, pval, fullfile(out_folder_corrFig, ['GM_' 'cluster' num2str(cluster) '_' 'OnsetAge.png']))
    GM_cluster_OnsetAge_rho(cluster, 1) = rho;
    GM_cluster_OnsetAge_pval(cluster, 1) = pval;
    clear rho  pval
end

GM_corr_T = [GM_cluster_age_rho, GM_cluster_age_pval, GM_cluster_ED_rho, GM_cluster_ED_pval, ...
        GM_cluster_SeizureFreq_rho, GM_cluster_SeizureFreq_pval, GM_cluster_OnsetAge_rho, GM_cluster_OnsetAge_pval];

save('GM_WM_corr_Tables.mat', 'WM_corr_T', 'GM_corr_T')