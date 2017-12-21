# Bilateral-Breast-Fusion-
This code uses affine transformation and the level-set method to create modified bilateral breast models that can be seamlessly fused with whole body human models. The integrated models can be used for the study of Specific Absorption Rate (SAR) and thermal analysis in radio-frequency(RF) exposure. 

Example:
To fuse breast models download from http://uwcem.ece.wisc.edu/phantomRepository.html with
Hanako female model download from http://emc.nict.go.jp/bio/data/index_e.html.
1.  Add-to-Path all functions in folders "Morph functions" and "Kernel".

2.  Run "CreatBreastPectHanako.m" to generate modified left and right breast data "RmBreast" and "LmBreast".
 With rotation angles defined
 Origin location defined
 Ratio of breast defined
 
3.  Change the saving path at the last row in  "LevelsetL.m" or  "LevelsetR.m" to save the .vox file to the desired folder path.


![](https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Additional/After_level_set2.png)

![](https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Additional/Before_level_set%202.tif)

![](https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Additional/before_levelset2.tif) 

4.  Run "LevelsetL.m" on "LmBreast", and "LevelsetR.m" on "RmBreast".



5.  Modified bilateral breast models in .vox format are generated.

Note: the .vox format models can be imported into Xfdtd (Remcom, State College, PA USA). In addition, these models can also be saved in .raw files and be imported into Sim4Life (ZMT, Switzerland). The 'Additional' folder contains MATLAB functions to facilitate conversions between .raw files and .vox files. 
