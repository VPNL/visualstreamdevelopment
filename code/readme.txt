This directory contains all the code required to generate figures for the manuscript.
All code is written in MATLAB (version 2020b). Each code contains information regarding the figures it will generate. 

%%% Figure 1 and Figure 2 %%%
Both figures were generated using FreeSurfer's Freeview functionality to visualize R1 maps on an individual subject's cortical surface. 
We used the Wang (Wang et al., 2015) and Rosenke (Rosenke et al., 2021) atlases and cortex-based alignment to project individual dorsal, ventral, and lateral ROIs on the infant brain for Fig. 1b. 

ROIs list per stream is as follows: 
Ventral: (V1 V2 V3) + hV4 V01 V02 PHC1 PHC2
Dorsal:   (V1 V2 V3) +  V3a V3b IPS0 IPS1 IPS2
Lateral: (V1 V2 V3) + LO1 LO2 TO1 TO2 MTG

%%% For Figures 3-5 and Supplementary Figure 2 %%% 
These codes generate linear mixed models (LMM) to study the development of dorsal, lateral, and ventral streams, per tissue type (gray and white matter), and hemisphere (left/right), respectively. 
LMMs are based on mean R1 as the dependent measure and age (continuous variable) and ROIs (8 per stream) as independent factors. Codes also provide the estimates and standard errors of intercepts and slopes per model. 

%%% CODE REQUIRED for GRAY MATTER %%%%%%%%
function []=plot_scatter_allstreams_GM(hemis)
hemis = 'rh' or hemis = 'lh'
Data matrices required:
'All_R1_earlyvisual_GM_lh' or 'All_R1_earlyvisual_GM_rh' %% depending on the hemisphere. 
'All_R1_dorsal_GM_lh' or 'All_R1_dorsal_GM_rh' 
'All_R1_lateral_GM_lh' or 'All_R1_lateral_GM_rh' 
'All_R1_ventral_GM_lh' or 'All_R1_ventral_GM_rh' 

%%% CODE REQUIRED for WHITE MATTER %%%%%%%%
function []=plot_scatter_allstreams_WM(hemis)
hemis = 'rh' or hemis = 'lh'
Data matrices required:
'All_R1_earlyvisual_WM_lh' or 'All_R1_earlyvisual_WM_rh' %%depending on the hemisphere. 
'All_R1_dorsal_WM_lh' or 'All_R1_dorsal_WM_rh' 
'All_R1_lateral_WM_lh' or 'All_R1_lateral_WM_rh' 
'All_R1_ventral_WM_lh' or 'All_R1_ventral_WM_rh' 

%%% For Supplementary Figure 3 %%% 
function []=crossoverpoint_dorsal_GMWM(hemis)
hemis = 'rh' or hemis = 'lh'
Data matrices required:
'All_R1_earlyvisual_WM_lh' or 'All_R1_earlyvisual_WM_rh' for WM data, depending on the hemisphere. 
'All_R1_dorsal_WM_lh' or 'All_R1_dorsal_WM_rh' 

'All_R1_earlyvisual_GM_lh' or 'All_R1_earlyvisual_GM_rh' for GM data, depending on the hemisphere. 
'All_R1_dorsal_GM_lh' or 'All_R1_dordal_GM_rh' 

function []=crossoverpoint_lateral_GMWM(hemis)
hemis = 'rh' or hemis = 'lh'
Data matrices required:
'All_R1_earlyvisual_WM_lh' or 'All_R1_earlyvisual_WM_rh' for WM data, depending on the hemisphere. 
'All_R1_lateral_WM_lh' or 'All_R1_lateral_WM_rh' 

'All_R1_earlyvisual_GM_lh' or 'All_R1_earlyvisual_GM_rh' for GM data, depending on the hemisphere. 
'All_R1_lateral_GM_lh' or 'All_R1_lateral_GM_rh' 


function []=crossoverpoint_ventral_GMWM(hemis)
hemis = 'rh' or hemis = 'lh'
Data matrices required:
'All_R1_earlyvisual_WM_lh' or 'All_R1_earlyvisual_WM_rh' for WM data, depending on the hemisphere. 
'All_R1_ventral_WM_lh' or 'All_R1_ventral_WM_rh' 

'All_R1_earlyvisual_GM_lh' or 'All_R1_earlyvisual_GM_rh' for GM data, depending on the hemisphere. 
'All_R1_ventral_GM_lh' or 'All_R1_ventral_GM_rh' 




