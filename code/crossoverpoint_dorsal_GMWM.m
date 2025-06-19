 function [] = crossoverpoint_dorsal_GMWM(hemis)
% This code generates the cross-over ages when the white matter R1 values become larger than the gray matter values for the dorsal stream 
% hemis = 'lh' or hemis= 'rh'

%% Set working directory to where all R1 data is stored (update this path)
cd('/oak/stanford/groups/kalanit/biac2/kgs/projects/VisualStreamsDevelopment/results');

%% STEP 1: Load data and fit linear mixed models (LMMs) for gray matter (GM) and white matter (WM) in early visual and dorsal streams

%% Load R1 data matricies for gray matter (GM) and white matter (WM)
str_GM(1)= load(['All_R1_dorsal_GM_',hemis,'.mat']);
str_GM(2)= load(['All_R1_earlyvisual_GM_',hemis,'.mat']);
str_WM(1)= load(['All_R1_dorsal_WM_',hemis,'.mat']);
str_WM(2)= load(['All_R1_earlyvisual_WM_',hemis,'.mat']);

%% Convert age to log scale and assign group ID per baby for LMMs
age = log10([str_GM(1).age_I]);
forgroup=[]; group=[];
 for i=1:length(str_GM(1).FSsessions)
   a= extractBetween(str_GM(1).FSsessions{i},'bb','_mri');
   forgroup=[forgroup str2num(a{1})];  
 end
[c1 c2 group] =unique(forgroup); % Assign unique group ID per infant

%% Define colors schemes and stream names
streamcolor{1} = [[105 181 99]/255; [79 156 74]/255; [62 121 57]/255; [44 86 41]/255; [26 52 25]/255] % color scheme for dorsal stream (green tones)
streamcolor{2} = [[80 80 80]/255;[120 120 120]/255; [160 160 160]/255]; % color scheme for early visual areas (gray tones)

streamname{1} = 'dorsal'
streamname{2} = 'earlyvisual'

%% Initialize coefficent arrays
 inC2_gray=[];
 slP2_gray=[];
 inCSE2_gray=[];
 slPSE2_gray=[];
    
 inC2_white=[];
 slP2_white=[];
 inCSE2_white=[];
 slPSE2_white=[];

x=[]; y=[];
figure; set(gcf,'color','white'); hold;

%% Extract R1 values from early visual areas to build tables and fit models for each ROI
FULVAL_GM=str_GM(2).All_R1;
FULVAL_WM=str_WM(2).All_R1;

%% Early visual areas gray matter 
for roi=1:length(str_GM(2).roi_list)
    VAL= FULVAL_GM(:,roi);
    tbl= table(age', double(VAL), group,'VariableNames',{'Age','meanR1','Baby'});
    lme1= fitlme(tbl,'meanR1 ~ Age + (1|Baby)'); %% fitlme :  this is a matlab function to run LMM
 
    subplot(1,8,roi); hold;
    x1 = 9:1:420;
    y1 = lme1.Coefficients.Estimate(1) + (lme1.Coefficients.Estimate(2))*((log10(x1)));

    %% Save coefficients
    inC2_gray(roi) = lme1.Coefficients.Estimate(1);
    slP2_gray(roi) = lme1.Coefficients.Estimate(2);
    inCSE2_gray(roi) = lme1.Coefficients.SE(1);
    slPSE2_gray(roi) = lme1.Coefficients.SE(2);
   
    
    %% Plot the correlation line of early visual gray matter
    plot((x1),y1, 'color', streamcolor{2}(roi,:), 'linewidth', 2);
    axis([0 500 .3 .8]);
    set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'white' 'white'}); grid on;
    h1=scatter([(10.^age)],[VAL], 40, 'o', 'MarkerEdgecolor', streamcolor{2}(roi,:)); %colormap([streamcolor{stream}(roi,:); streamcolor{stream}(roi,:)]); % colorbar('eastoutside');
    title([' roi: ',str_GM(2).roi_list{roi}], 'FontSize', 6,'Fontweight', 'bold', 'Color', [0 0 0]);
    ylabel({'R1 [1/s]'});  xlabel({'Age in days'});

    
    %% Early visual areas white matter 
    VAL= FULVAL_WM(:,roi);
    tbl= table(age', double(VAL), group,'VariableNames',{'Age','meanR1','Baby'});
    lme1= fitlme(tbl,'meanR1 ~ Age + (1|Baby)'); %% fitlme :  this is a matlab function to run LMM
 
    x2 = 9:1:420;
    y2 = lme1.Coefficients.Estimate(1) + (lme1.Coefficients.Estimate(2))*((log10(x2)));
    
    inC2_white(roi) = lme1.Coefficients.Estimate(1);
    slP2_white(roi) = lme1.Coefficients.Estimate(2);
    inCSE2_white(roi) = lme1.Coefficients.SE(1);
    slPSE2_white(roi) = lme1.Coefficients.SE(2);
    
    %% Plot the correlation line of early visual white matter
    plot((x2),y2,'--', 'color', streamcolor{2}(roi,:), 'linewidth', 2);
    h1=scatter([(10.^age)],[VAL], 40, '^', 'MarkerEdgecolor', streamcolor{2}(roi,:)); 
    hold off;
end

%% Repeat the same model fitting and plotting for dorsal stream ROIs
count=3;  
FULVAL_GM=str_GM(1).All_R1;
FULVAL_WM=str_WM(1).All_R1;

for roi =1:length(str_GM(1).roi_list) %% running a linear mixed model per roi
%% Dorsal stream gray matter 
    VAL= FULVAL_GM(:,roi);
    tbl= table(age', double(VAL), group,'VariableNames',{'Age','meanR1','Baby'});
    lme1= fitlme(tbl,'meanR1 ~ Age + (1|Baby)'); %% fitlme :  this is a matlab function to run LMM
 
    subplot(1,8,count+roi); hold;
    x1 = 9:1:420;
    y1 = lme1.Coefficients.Estimate(1) + (lme1.Coefficients.Estimate(2))*((log10(x1)));

    inC2_gray(roi+count) = lme1.Coefficients.Estimate(1);
    slP2_gray(roi+count) = lme1.Coefficients.Estimate(2);
    inCSE2_gray(roi+count) = lme1.Coefficients.SE(1);
    slPSE2_gray(roi+count) = lme1.Coefficients.SE(2);
  
    %% Plot the correlation line for dorsal stream gray matter
    plot((x),y, 'color', streamcolor{1}(roi,:), 'linewidth', 2);
    axis([0 500 .3 .8]);
    set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'white' 'white'}); grid on;
    h1=scatter([(10.^age)],[VAL], 40, 'o', 'MarkerEdgecolor', streamcolor{1}(roi,:)); %colormap([streamcolor{stream}(roi,:); streamcolor{stream}(roi,:)]); % colorbar('eastoutside');
    title([' roi: ',str_GM(1).roi_list{roi}], 'FontSize', 6,'Fontweight', 'bold', 'Color', [0 0 0]);
    ylabel({'R1 [1/s]'});  xlabel({'Age in days'});
    
 %% Dorsal stream white matter
    VAL= FULVAL_WM(:,roi);
    tbl= table(age', double(VAL), group,'VariableNames',{'Age','meanR1','Baby'});
    lme1= fitlme(tbl,'meanR1 ~ Age + (1|Baby)'); %% fitlme :  this is a matlab function to run LMM
 
    x2 = 9:1:420;
    y2 = lme1.Coefficients.Estimate(1) + (lme1.Coefficients.Estimate(2))*((log10(x2)));

    inC2_white(roi+count) = lme1.Coefficients.Estimate(1);
    slP2_white(roi+count) = lme1.Coefficients.Estimate(2);
    inCSE2_white(roi+count) = lme1.Coefficients.SE(1);
    slPSE2_white(roi+count) = lme1.Coefficients.SE(2);
    
    %% Plot the correlation line for dorsal stream white matter
    plot((x),y,'--', 'color', streamcolor{1}(roi,:), 'linewidth', 2);
    h1=scatter([(10.^age)],[VAL], 40, '^', 'MarkerEdgecolor', streamcolor{1}(roi,:)); 
    hold off;
end

%% STEP 2: Calculate crossover ages where WM R1 surpasses GM R1 (intersection point)
age_range = min(age):0.01:max(age); 
intercepts_original = []; 
figure;

%% For early visual ROIs
for roi=1:length(str_GM(2).roi_list)
    subplot(1,8,roi); hold on;
    box off
    set(gca,'XTick',[])
    set(gca,'YTick',[])
    ylim([0.35 0.65])
    xlim([0.8 2.6])
    plot(age_range, slP2_gray(roi) * age_range + inC2_gray(roi), 'Color', streamcolor{2}(roi,:), 'LineWidth', 4);
    plot(age_range, slP2_white(roi) * age_range + inC2_white(roi), 'Color', streamcolor{2}(roi,:), 'LineWidth', 4, 'LineStyle', '--');

    if (slP2_gray(roi) - slP2_white(roi)) ~= 0 
        x_intercept_log = (inC2_white(roi) - inC2_gray(roi)) / (slP2_gray(roi) - slP2_white(roi));
        x_intercept_original = 10^x_intercept_log;
        intercepts_original = [intercepts_original, x_intercept_original];
        y_intercept = slP2_gray(roi) * x_intercept_log + inC2_gray(roi);

        if x_intercept_log >= min(age_range) && x_intercept_log <= max(age_range)
            plot(x_intercept_log, y_intercept, 'ko', 'MarkerFaceColor', [0.3 0.3 0.3]);
            
            fprintf('For %s, the lines intersect at age: %.2f\n', str_GM(2).roi_list{roi}, x_intercept_original);
        end
    else
        fprintf('For %s, the lines are parallel and do not intersect within the range.\n', roi_list{i});
    end
end 

%% For dorsal stream ROIs
count=3;  
for roi =1:length(str_GM(1).roi_list) %
    subplot(1,8, roi+count);
    hold on;
    box off
    set(gca,'XTick',[])
    set(gca,'YTick',[])
    ylim([0.35 0.65])
    xlim([0.8 2.6])
    plot(age_range, slP2_gray(roi+count) * age_range + inC2_gray(roi+count), 'Color', streamcolor{1}(roi,:), 'LineWidth', 4);
    plot(age_range, slP2_white(roi+count) * age_range + inC2_white(roi+count), 'Color', streamcolor{1}(roi,:), 'LineWidth', 4, 'LineStyle', '--');

    if (slP2_gray(roi+count) - slP2_white(roi+count)) ~= 0 
        x_intercept_log = (inC2_white(roi+count) - inC2_gray(roi+count)) / (slP2_gray(roi+count) - slP2_white(roi+count));
        x_intercept_original = 10^x_intercept_log;
        intercepts_original = [intercepts_original, x_intercept_original];
        y_intercept = slP2_gray(roi+count) * x_intercept_log + inC2_gray(roi+count);

        if x_intercept_log >= min(age_range) && x_intercept_log <= max(age_range)
            plot(x_intercept_log, y_intercept, 'ko', 'MarkerFaceColor', [0.3 0.3 0.3]);
            
            fprintf('For %s, the lines intersect at age: %.2f\n', str_GM(1).roi_list{roi}, x_intercept_original);
        end
    else
        fprintf('For %s, the lines are parallel and do not intersect within the range.\n', roi_list{i});
    end
    
end


%% STEP 3: Plot summary of crossover ages 
figure;
set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'k' 'k'});
set(gcf,'color','white'); hold;
axis([0 9 40 110]);
title('Intercept');

%% Plot early visual ROIs
for roi=1:length(str_GM(2).roi_list)
    bar([roi],[intercepts_original(roi)],'Facecolor', streamcolor{2}(roi,:),'Edgecolor', streamcolor{2}(roi,:));
end

%% Plot dorsal stream ROIs
for roi=1:length(str_GM(1).roi_list)
    bar([3+roi],[intercepts_original(3+roi)],'facecolor', streamcolor{1}(roi,:),'Edgecolor', streamcolor{1}(roi,:));
end

%% Display group statistics
mean(intercepts_original)
std(intercepts_original)

