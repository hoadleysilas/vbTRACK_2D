ReadMe.txt
This file contains instructions for running the Github Matlab repository vbTRACK_2D. It is assumed that the user is familiar with Matlab and does not require a GUI.. 
1. Download repository to a single folder named, for example, D:\vbTRACK_2D_GitHub. There should be several subfolders and sub-sub-folders:
Bronson code
       src and src_ext
              src
              src_ext
inputData   
2. Open Matlab
Change working directory to top-level folder, e.g.          D:\vbTRACK_2D_GitHub
Change path to this directory and its subfolders.
3. Open file run_vbTRACK_2D
4. Run this file. 
5. The program should run on one dataset, the track of an RSP particle for VSV in a live mammalian cell.  Only the machine-learning part of our code is used here. The code generates 5 figures:
     Fig 1 is an xy plot of the raw data before ML.
Fig 3 is a plot of state vs time after ML. ML shows that   2 states are most probable.  The plot shows that there is a single jump from State 1 to State 2.
Fig 4 is a plot of ML in progress.   Six models, with 1 Gaussian, 2 Gaussians,…,6 Gaussians  are tested. Each is optimized independently with 50 iterations.  Note that the log of the probability L is a maximum for 2 states.  This is an objective result of ML.  
Fig 5 is a plot of the maximum log L for 1 Gaussian, 2 Gaussians, …… ,6 Gaussians.  Note that model with 2 Gaussians has the largest value of log L for this dataset.  Other datasets would give different results.
Fig 6 is an xy plot of the data following machine learning, which shows that there are only 2 states. All xy points in State 1 are colored red; all xy points in State 2 are colored green.  Note that the center of state 2 is shifted significantly with respect to the center of State1.  The particle jumps from one cage to a neighboring cage.       
