# Bilateral-Breast-Fusion-
This code uses affine transformation and the level-set method to create modified bilateral breast models that can be seamlessly fused with whole body human models. The integrated models can be used for the study of Specific Absorption Rate (SAR) and thermal analysis in radio-frequency(RF) exposure. 

Example models:
Breast models download from:
UWM breast models http://uwcem.ece.wisc.edu/phantomRepository.html with
DUKE U breast models 

Human models download from: 
Hanako female model download from http://emc.nict.go.jp/bio/data/index_e.html.
Ella female model download from

##1.  Add-to-Path all functions in folders "Morph functions" and "Kernel".

##2.  Run "CreatBreastPectHanako.m" to generate modified left and right breast data "RmBreast" and "LmBreast".
 Users can define rotational angles 
 Ratio of breast defined
 Origin locations of breast model and human models
 The origion locations will be helpful for positioning the human models and breast models in EM simulation softeare
 
##3.  Change the saving path at the last row in  "LevelsetL.m" or  "LevelsetR.m" to save the .vox file to the desired folder path.
Run "LevelsetL.m" on "LmBreast", and "LevelsetR.m" on "RmBreast".


![](https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/joint2.png)

![](https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/Before_level_set%20(Axial).png) 
![](https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/Before_level_set%20(Saggital).png) 

![](https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/After_level_set%20(Axial).png) 
![](https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/After_level_set%20(Saggital).png) 


##5.  Modified bilateral breast models in .vox format are generatedm, and assocaited .mmf files are also generated. Users can also generate .raw fromate files. (Note: the .vox format models incorporated with .mmf files can be imported into Xfdtd (Remcom, State College, PA USA). In addition, these models can also be saved in .raw files and be imported into Sim4Life (ZMT, Switzerland). The 'Additional' folder contains MATLAB functions to facilitate conversions between .raw files and .vox files)
