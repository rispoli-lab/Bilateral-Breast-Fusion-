# Bilateral-Breast-Fusion- User manual

This code uses mirroring, one-dimensional extrusion and the level-set method to create modified bilateral breast models from a single breast model. One-dimensional extrusion method mimic of supine postion breat models, because gravity makes breast traight down. The bilateral breast models and whole body human models are seemlessley fused by the mean-curvature driven level set function. The integrated models can be used for the study of Specific Absorption Rate (SAR) and thermal analysis in radio-frequency(RF) exposure. The following methology have potentials to be applied on any patient-based whole-body models and breast models.

### Example models:
#### Breast models:
- UWM breast models download from http://uwcem.ece.wisc.edu/phantomRepository.html 
- DUKE U breast models can inqure from Dr.Lo at http://railabs.duhs.duke.edu/~jyl/

#### Human models: 
- Hanako female model download from http://emc.nict.go.jp/bio/data/index_e.html.
- Ella female model download from https://www.itis.ethz.ch/virtual-population/virtual-population/overview/

## 1. Software Set-up.
Download the package and upacked to desired folder.Add-to-Path all functions in folders "Morph functions" and "Kernel".

## 2. Pre-locate breast position.
 Users can define rotational angles 
 Ratio of breast defined
 Origin locations of breast model and human models
 The origion locations will be helpful for positioning the human models and breast models in EM simulation softeare.
 
## 3. Breast extrution to pectoral muscle.
The pectoral muscle and bone boundary are first smoothed by Morphological filtering

Before morphological filtering    |  After morphological filtering
:-------------------------:|:-------------------------:
<img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/Volume_Viewer_unsmoothed2.png" width= "30%" height = "30%"> | <img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/Volume_Viewer_soomthed2.png" width= "30%" height = "30%">

Run "CreatBreastPectHanako.m" to generate modified left and right breast data "RmBreast" and "LmBreast".

## 4. Apply level-set method to smooth joint.
Change the saving path at the last row in  "LevelsetL.m" or  "LevelsetR.m" to save the .vox file to the desired folder path.
Run "LevelsetL.m" on "LmBreast", and "LevelsetR.m" on "RmBreast".


![](https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/joint2.png)

Before Level_set             |  After Level_set
:-------------------------:|:-------------------------:
<img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/Before_level_set%20(Axial).png" width= "60%" height = "60%"> | <img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/After_level_set%20(Axial).png" width= "60%" height = "60%">
<img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/Before_level_set%20(Saggital).png" width= "60%" height = "60%"> | <img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/After_level_set%20(Saggital).png" width= "60%" height = "60%">

## 5. Export data.
Modified bilateral breast models in .vox format are generatedm, and assocaited .mmf files are also generated. Users can also generate .raw fromate files. (Note: the .vox format models incorporated with .mmf files can be imported into Xfdtd (Remcom, State College, PA USA). In addition, these models can also be saved in .raw files and be imported into Sim4Life (ZMT, Switzerland). The 'Additional' folder contains MATLAB functions to facilitate conversions between .raw files and .vox files)
