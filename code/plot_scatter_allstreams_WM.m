function [] = plot_scatter_allstreams_WM(hemis)
% This code calculates scatter plots of mean  R1 for white matter tissue for dorsal, lateral, and ventral visual processing streams, 
% it also generates Linear mixed models per ROIs/streams, and estimates intercepts and slopes per ROI/stream.
% hemis = 'lh' or hemis= 'rh'

%% Set working directory to where all R1 data is stored (update this path)
cd('/oak/stanford/groups/kalanit/biac2/kgs/projects/VisualStreamsDevelopment/results');

%% Load R1 data matricies for gray matter (GM) and white matter (WM)
str(1)= load(['All_R1_ventral_WM_',hemis,'.mat']);
str(2)= load(['All_R1_dorsal_WM_',hemis,'.mat']);
str(3)= load(['All_R1_lateral_WM_',hemis,'.mat']);
str(4)= load(['All_R1_earlyvisual_WM_',hemis,'.mat']);

%% STEP 1: Generate Linear Mixed Model per ROI
age = log10([str(1).age_I]);
forgroup=[]; group=[];
 for i=1:length(str(1).FSsessions)
   a= extractBetween(str(1).FSsessions{i},'bb','_mri');
   forgroup=[forgroup str2num(a{1})];  
 end
[c1 c2 group] =unique(forgroup);

streamcolor{1} = [[250 81 104]/255; [249 31 61]/255; [224 6 35]/255; [174 5 28]/255; [124 3 20]/255] % ventral {red} color scheme
streamcolor{2} = [[105 181 99]/255; [79 156 74]/255; [62 121 57]/255; [44 86 41]/255; [26 52 25]/255] % dorsal (green) color scheme
streamcolor{3} = [[85 161 247]/255; [36 134 244]/255; [11 108 219]/255; [8 84 170]/255; [6 60 122]/255] % lateral (blue) color scheme
streamcolor{4} = [[80 80 80]/255;[120 120 120]/255; [160 160 160]/255]; % eva color scheme

streamname{1} = 'ventral'
streamname{2} = 'dorsal'
streamname{3} = 'lateral'
streamname{4} = 'earlyvisual'

%treamcolor{1} = [[136 8 8] /255; [136 8 8] /255; [136 8 8] /255;[136 8 8] /255; [136 8 8] /255 ] % ventral color scheme
%streamcolor{2} = [[79 121 66] /255; [79 121 66] /255; [79 121 66] /255;[79 121 66] /255;[79 121 66] /255;] % lateral color scheme
%streamcolor{3} = [[0 0 255]/255; [0 0 255]/255;[0 0 255]/255;[0 0 255]/255;[0 0 255]/255;] % dorsal color scheme
%streamcolor{4} = [[52 58 64]/255; [73 80 87]/255; [108 108 108]/255]; % eva color scheme

inC1=[]; slP1=[];  inCSE1=[]; slPSE1=[];
   
for stream=1:3
    figure; set(gcf,'color','white'); hold;
    %% build a table/model per roi per stream 
    FULVAL=str(4).All_R1;
    for roi=1:length(str(4).roi_list)
        VAL= FULVAL(:,roi);
        
        tbl= table(age', double(VAL), group,'VariableNames',{'Age','meanR1','Baby'});
        lme1= fitlme(tbl,'meanR1 ~ Age + (1|Baby)'); %% fitlme :  this is a matlab function to run LMM
        
        %% y (mean R1) = m (slope) x (age) + c (intercept) [1|Baby]
        
        subplot(1,8,roi); hold;
        %  x = 1:0.02:3;
        x = 9:1:420;
        y = lme1.Coefficients.Estimate(1) + (lme1.Coefficients.Estimate(2))*((log10(x)));
        inC1{4}(roi) = lme1.Coefficients.Estimate(1);
        slP1{4}(roi) = lme1.Coefficients.Estimate(2);
        
        inCSE1{4}(roi) = lme1.Coefficients.SE(1);
        slPSE1{4}(roi) = lme1.Coefficients.SE(2);
        
        %% this plots the corr line
        plot((x),y, 'color', streamcolor{4}(roi,:), 'linewidth', 2);
        axis([0 500 .3 .8]);
        
        set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'white' 'white'}); grid on;
        h1=scatter([(10.^age)],[VAL], 30, [(age)],'linewidth',2, 'MarkerEdgecolor', streamcolor{4}(roi,:)); %colormap([streamcolor{stream}(roi,:); streamcolor{stream}(roi,:)]); % colorbar('eastoutside');
        title([' roi: ',str(4).roi_list{roi}], 'FontSize', 6,'Fontweight', 'bold', 'Color', [0 0 0]);
        ylabel({'R1 [1/s]'});  xlabel({'Age in days'});
        hold off;
        
    end
    
   
    count=3;  FULVAL=str(stream).All_R1;
  
    for roi =1:length(str(stream).roi_list) %% running a linear mixed model per roi
        VAL= FULVAL(:,roi);
        tbl= table(age', double(VAL), group,'VariableNames',{'Age','meanR1','Baby'});
        lme1= fitlme(tbl,'meanR1 ~ Age + (1|Baby)'); %% fitlme :  this is a matlab function to run LMM
        
        %% y (mean R1) = m (slope) x (age) + c (intercept) [1|Baby]
        
        subplot(1,8,roi+count); hold;
        %  x = 1:0.02:3;
        x = 9:1:420;
        y = lme1.Coefficients.Estimate(1) + (lme1.Coefficients.Estimate(2))*((log10(x)));
        inC1{stream}(roi) = lme1.Coefficients.Estimate(1);
        slP1{stream}(roi) = lme1.Coefficients.Estimate(2);
        
        inCSE1{stream}(roi) = lme1.Coefficients.SE(1);
        slPSE1{stream}(roi) = lme1.Coefficients.SE(2);
        
        %% this plots the corr line
        plot((x),y, 'color', streamcolor{stream}(roi,:), 'linewidth', 2);
        axis([0 500 .3 .8]);
        xticks([0 200 400]);

        set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'white' 'white'});grid on;
        h1=scatter([(10.^age)],[VAL], 30, [(age)], 'linewidth',2,'MarkerEdgecolor', streamcolor{stream}(roi,:)); %colormap([streamcolor{stream}(roi,:); streamcolor{stream}(roi,:)]); % colorbar('eastoutside');
        title([' roi: ',str(stream).roi_list{roi}], 'FontSize', 6,'Fontweight', 'bold', 'Color', [0 0 0]);
       % model1{roi} = lme1;
        ylabel({'R1 [1/s]'});  xlabel({'Age in days'});
        hold off;
       
    end
    count=count+1;
end

%% STEP 2: generate LMM slope 
figure;
set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'k' 'k'});
set(gcf,'color','white'); 

for stream=1:3
    subplot(1,3,stream); hold;
    axis([0 8 0.08 .22]); 
    title('Slope');

    for roi=1:length(str(4).roi_list)
        scatter([roi],[slP1{4}(roi)], 150, [roi], 'linewidth',3, 'MarkerEdgecolor', streamcolor{4}(roi,:));
        errorbar([roi], slP1{4}(roi), slPSE1{4}(roi), 'color', streamcolor{4}(roi,:), 'Linewidth',3);
    end
    
    for roi=1:length(str(stream).roi_list)
        scatter([3+roi],[slP1{stream}(roi)], 150, [roi],  'linewidth',3,  'MarkerEdgecolor', streamcolor{stream}(roi,:));
        errorbar([3+roi], slP1{stream}(roi), slPSE1{stream}(roi), 'color', streamcolor{stream}(roi,:), 'Linewidth',3);
    end
     yticklabels('off')
    hold off;
end

%% STEP 3: generate LMM intercept
figure;
set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'k' 'k'});

for stream=1:3
subplot(1,3,stream); hold;
axis([0 8 0.1 .4]); 
title('Intercept');
xticks([0 200 400])
for roi=1:length(str(4).roi_list)
    scatter([roi],[inC1{4}(roi)], 150, [roi],'linewidth',3, 'MarkerEdgecolor', streamcolor{4}(roi,:));
    errorbar([roi], inC1{4}(roi), inCSE1{4}(roi), 'color', streamcolor{4}(roi,:), 'Linewidth',3);
end
    
    for roi=1:length(str(stream).roi_list)
        scatter([3+roi],[inC1{stream}(roi)], 150, [roi],'linewidth',3,  'MarkerEdgecolor', streamcolor{stream}(roi,:));
        errorbar([3+roi], inC1{stream}(roi), inCSE1{stream}(roi), 'color', streamcolor{stream}(roi,:), 'Linewidth',3);

    end
    yticklabels('off')

end






