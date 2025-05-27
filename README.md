# Visual Stream Development
This repository contains the code and data for the paper titled; 
"Hierarchical microstructural tissue growth of the white and gray matter of human visual cortex during the first year of life (2025)"
Authors: Karla Perez, Ahmad Allen, Christina Tyagi, Sarah S. Tung, Bella Fascendini, Xiaoqian Yan, Juliet Horenziak, Danya Ortiz, Hua Wu, Kalanit Grill-Spector & Vaidehi S. Natu.

This project examines the development of microstructure in gray and white matter of three visual processing streams - the dorsal, lateral, and ventral streams - during the first year of human life. 

The repository is organized as follows:

code/: Contains analysis scripts for each figure in the paper (MATLAB scripts for all figures)

data/: Contains the necessary data files (in .mat format) to run each analysis
Data files are organized by figure number 

Tool Requirements
1. MATLAB (Code was written and tested using MATLAB R2020b, and it should be compatible with both older and more recent MATLAB versions).
2. Optional Tools: If you wish to process your raw data using the scripts (e.g., from NIfTI files), you can  install Vistasoft, a MATLAB toolbox for neuroimaging data analysis: https://github.com/vistalab/vistasoft
For infant brain surface reconstruction and analysis, we used a specialized version of FreeSurfer: freesurfer-linux-centos7_x86_64-infant-dev-4a14499-20210109.

Note that this is a developmental version specifically optimized for infant brains. More information about infant Freesurfer can be found at: https://surfer.nmr.mgh.harvard.edu/fswiki/infantFS
