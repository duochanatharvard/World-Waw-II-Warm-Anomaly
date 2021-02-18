# Correcting observational biases in sea-surface temperature observations removes anomalous warmth during World War II

![GitHub last commit](https://img.shields.io/github/last-commit/duochanatharvard/World-Waw-II-Warm-Anomaly)
![GitHub repo size](https://img.shields.io/github/repo-size/duochanatharvard/World-Waw-II-Warm-Anomaly)

<br>

[Matlab](https://www.mathworks.com/products/matlab.html) and shell scripts associated with the paper "Correcting observational biases in sea-surface temperature observations removes anomalous warmth during World War II" by Duo Chan and Peter Huybers.

If you have issues implementing these scripts or identify any deficiencies, please contact Duo Chan (duochan@g.harvard.edu).

<br>

## Associated SST Estimates
Monthly SST estimates (R1--R5) at 5x5 degree resolution from 1850--2014 are provided in a single .netcdf file, **WWIIWA_monthly_SST_5x5_R1-R5_Chan_and_Huyber_2021_JC.nc**, in [this](https://doi.org/10.7910/DVN/RJLBOQ) Harvard Dataverse repository.  Please note that these estimates contain uncorrected SSTs (R1--R3) or only account for internal heterogeneity between different subsets of observations (R4--R5), whereas we have not yet adjusted for biases common to all SST measurements.  As a result, these estimates are suitable not for understanding long-term SST evolution.   

<br>

## Quick reproduction of Figures and Tables

We provide a script [WWIIWA_main.m](WWIIWA_main.m) for fast reproduction of Figures and Tables in the main text and supplements.  After downloading key results (about 1GB) from [here](https://doi.org/10.7910/DVN/RJLBOQ) and informing [WWIIWA_IO.m](WWIIWA_IO.m) of the data directory, the entire reproduction process is as simple as running the [WWIIWA_IO.m](WWIIWA_IO.m) script in Matlab's command window, which takes less than one minute to run on a 2019 MacBook-Pro.  All codes called in this step are in the folder ```3-Figures_and_Table```, with dependent functions placed in the ```Function``` folder.  
External dependency is the Matlab [m_map](https://www.eoas.ubc.ca/~rich/map.html) toolbox.

Data downloaded in this step are,

* **WWIIWA_statistics_for_[data source].mat**: key statistics, including monthly global mean SSTs, global mean SST variance from 1936-1950 at 5x5 degree resolution, and maps of SST anomalies during WWII and peace years around the war, for raw and groupwise adjusted ICOADS SSTs (R1-R5), existing SST estimates from other studies, CMIP5 and CMIP6 historical simulations, and CMIP5 pi-Control experiments.  These files are used in Figures 1, 5, 6, 7, 8, and S4.

* **Stats_All_ships_groupwise_global_analysis_[all/day].mat** and **statistics_N_of_pairs_for_Fig_2b.mat**: numbers of measurements from individual groups and numbers of pairs between groups.  These files are used in Figure 2.

* **DATA_Plot_DA&LME_[time].mat**: LME offsets and estimates of diurnal amplitude for individual groups averaged over periods before, during, and after the war.  These files are used in Figure 4.

* **Corr_idv_[method]\_en_0_Ship_vs_Ship_[day/night]_\*\*\*.mat**: gridded raw and groupwise adjusted ICOADS SSTs for all ship-based measurements (ship), bucket-only (method 0), and ERI-only (method 1) SSTs, and for estimates using both day and nighttime (all), daytime-only (day), and nighttime-only measurements (night).  These files are used in Figures 6 and S2.

* **LME_\*\*\*.mat**: statistics of LME offsets, which are used in Table 1 and Figure S3.

* **SUM_all_ships_DA_signals_1935_1949_Annual_relative_to_mean_SST.mat**: Diurnal SST anomalies for estimating diurnal cycle for deck 195, used in Figure S1.

* **HadSST.4.0.0.0_median.nc**: HadSST4 median estimates, used to generate a least common mask (**common_minimum_mask.mat**) for calculating global mean SSTs.  This file is used in Figure S2.

* **hybrid_36m.temp**: Cowtan SST estimates -- only the global mean time series is available.  This file is used in Figures 1 and 7 and Table 1.


<br>

## Full Analysis

The full analysis, which starts from downloading and processing the ICOADS dataset, takes more computational resources and time.  Below, we provide step-by-step instruction.   

#### Overview and Dependency
The full analysis consists of three steps.  The first is downloading and processing the ICOADS dataset.  The second is the LME analysis, and the last is computing trends and other statistics for different SST estimates.

__Dependency__: [CD-Computation](https://github.com/duochanatharvard/CD_Computation), [CD-Figures](https://github.com/duochanatharvard/CDF_Figures), and [colormap-CD](https://github.com/duochanatharvard/colormap_CD).

#### 0. Downloading and Processing ICOADS

Scripts for this step are in the [ICOADS pre-process](https://github.com/duochanatharvard/ICOADS_preprocess) repository, which also provides step-by-step instruction instruction of usage.

Note that pre-processing scripts in [ICOADS pre-process](https://github.com/duochanatharvard/ICOADS_preprocess) infer SST methods following [Kennedy et al. (2012)](https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2010JD015220) when method metadata is not available.  In Chan and Huybers (2021), we do not infer SST methods but leave these methods missing and group these measurements separately.  Thus, we provide an updated script, i.e., [ICOADS_Step_02_pre_QC_not_infer_SST_methods.m](ICOADS_Step_02_pre_QC_not_infer_SST_methods.m), in folder ```0-Preprocess-ICOADS```.  Please replace **ICOADS_Step_02_pre_QC.m** with this updated script.

__[System requirement]__ The raw ICOADS takes approximately 28GB of disk space, and the processed dataset takes about 48GB of disk space.  Intermediate steps may take another 100GB.  We highly recommend submitting multiple jobs to run this step in parallel.  We used 120 CPUs on the Harvard [Odyssey Cluster](https://www.rc.fas.harvard.edu/odyssey/), and it took about one day to finish this step.

#### 1. Linear-Mixed-Effect Intercomparison

Scripts of the LME analysis are in folder ```1-LME_analysis```, which contains three sub-steps, (1) pairing, (2) running LME analysis, and (3) adjusting data and generating gridded SST estimates.  We provide the scripts, i.e., [R1_R4_Pipeline_SST](R1_R4_Pipeline_SST) and [R5_Pipeline_day_night_SST](R5_Pipeline_day_night_SST), that we used to these codes using the [SLURM workload manager](https://slurm.schedmd.com/documentation.html) on Harvard [Odyssey Cluster](https://www.rc.fas.harvard.edu/odyssey/).  If you are using different machinery, please make the necessary changes.

Before running this code, you need to specify the data directory in [LME_directories.mat](LME_directories.mat) and set up folders in the data directory.  Please refer to [this](https://github.com/duochanatharvard/Homogeneous_early_20th_century_warming) repository for the structure of data folders and detailed explanations of analysis procedures.  Note that LME scripts in this current repository permit running the analysis for successive three months to resolve seasonal cycles in biases and offsets; so please use the codes provided here.

__[System requirement]__ This step takes a large amount of memory (~250GB) to run because estimating the covariance structure of random effects involves inverting gigantic matrices.  For one pipeline, in our implementation using the Harvard [Odyssey Cluster](https://www.rc.fas.harvard.edu/odyssey/), it takes about one day for the pairing process using 120 CPUs, 10 hours for the LME analysis using 12 CPUs with large memory, and another half of a day for adjustment and gridding a 1000-member SST ensemble using 50 CPUs.


#### 2. Post-processing and Computing Statistics

Scripts for post-processing are in folder ```2-Postprocessing```, which have names **WWIIWA_analysis_Step_0\*\_calculate_statistics_for_[data source].m**. Note that you need to modify input and output directories accordingly.

SST estimates from other studies can be downloaded as follow, [HadSST2](https://www.metoffice.gov.uk/hadobs/hadsst2/data/download.html), HadSST3.1.1.0 [median](https://www.metoffice.gov.uk/hadobs/hadsst3/data/download.html) and its [100-member ensemble](https://www.metoffice.gov.uk/hadobs/hadsst3/data/download.html), HadSST4.0.0.0 [median](https://www.metoffice.gov.uk/hadobs/hadsst4/data/download.html) and its [200-member ensemble](https://www.metoffice.gov.uk/hadobs/hadsst4/data/download.html), ERSST4 [median](https://psl.noaa.gov/data/gridded/data.noaa.ersst.v4.html) and its [1000-member ensemble](ftp://ftp.ncei.noaa.gov/pub/data/cmb/ersst/v4/ensemble), and ERSST5 [median](https://www.esrl.noaa.gov/psd/data/gridded/data.noaa.ersst.v5.html) and its [1000-member ensemble](ftp://ftp.ncei.noaa.gov/pub/data/cmb/ersst/v5/ensemble.1854-2017).  We provide a script, [LME_analysis_Step_03_preprocess_other_SST_datasets.m](LME_analysis_Step_03_preprocess_other_SST_datasets.m), to re-grid SST estimates in .netcdf files, such as for HadSST2/3/4 (median and ensemble) and ERSST4/5 (median), into .mat files having a common 5-degree resolution .  The 1000-member ensembles of ERSST estimates are saved in binary files and are processed using a separate script, i.e., [Processing_ERSST_ensembles.m](Processing_ERSST_ensembles.m).

CMIP5 outputs are from the ETH repository, which provides re-gridded SST (tos) outputs at 2.5-degree resolution.  Please contact [Jan.Sedlacek@env.ethz.ch](Jan.Sedlacek@env.ethz.ch) or [cmip5-archive@env.ethz.ch](cmip5-archive@env.ethz.ch) for data access.  CMIP6 outputs are from the [ESGF portal](https://esgf-node.llnl.gov/search/cmip6/).

__[System requirement]__ Any recent laptop with 8-16 GB memory should be sufficient to run this step in less than an hour.

Maintained by __Duo Chan__ (duochan@g.harvard.edu)
