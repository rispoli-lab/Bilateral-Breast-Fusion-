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

|Ella model breast model and breast coil prelocation|
|:-:|
|<img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/uwm2_wholebody_Ella.png" >| 


|Hanako model breast model and breast coil prelocation|
|:-:|
|<img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/uwm2_wholebody_Hanako.png" >| 



The cyan color line outlined the muscle porjection of the human models, and serves as a location landmark for breast models positionning. The two circular rings (black) represent the breast coils.The pink and right circles represent projection size of the breast model. The white semi-circle represent the hight effect of the right breast model. Users can define rotational angles, and breast size for the breast model.Best ratio of breast scalling depends on the ratio of breast model voxels size to human model voxel size.Origin locations of human models(white dot at the left bottom corner), bilateral breast models cordinates (yellow dots),pectoral muscle cordinates(white dots near the breasts) relative to the human models will be the saved.The origion locations will be helpful for positioning the human models and breast models in EM simulation software.


## 3. Breast extrution to pectoral muscle.
The pectoral muscle and bone boundary are first smoothed by Morphological filtering

Before morphological filtering    |  After morphological filtering
:-------------------------:|:-------------------------:
<img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/Chestdata2-2.PNG" width= "100%" height = "100%"> | <img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/ClosePec2-2.PNG" width= "100%" height = "100%">


Run "CreatBreastPectHanako.m" to generate modified left and right breast data "RmBreast" and "LmBreast". Results after execution of "CreatBreastPectHanako.m":


<img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/uwm1Combined_axial.png">

## 4. Apply level-set method to smooth joint.
Change the saving path at the last row in  "LevelsetL.m" or  "LevelsetR.m" to save the .vox file to the desired folder path.
Run "LevelsetL.m" on "LmBreast", and "LevelsetR.m" on "RmBreast".


![](https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/joint2.png)

Before Level_set             |  After Level_set
:-------------------------:|:-------------------------:
**Before level-set (Axial)** | **After level-set (Axial)**
<img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/uwm1LeftbreastBefore_level_set_Axial.png">  | <img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/uwm1LeftbreastAfter_level_set_Axial.png">
**Before level-set (Saggital)**|**After level-set (Saggital)**
<img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/uwm1LeftbreastBefore_levele_set_Saggital.png"> | <img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/uwm1LeftbreastAfter_level_set_Saggital.png">


## 5. Export data.
Modified bilateral breast models in .vox format are generatedm, and assocaited .mmf files are also generated. Users can also generate .raw fromate files. (Note: the .vox format models incorporated with .mmf files can be imported into Xfdtd (Remcom, State College, PA USA). In addition, these models can also be saved in .raw files and be imported into Sim4Life (ZMT, Switzerland). The 'Additional' folder contains MATLAB functions to facilitate conversions between .raw files and .vox files)
