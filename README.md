# Bilateral-Breast-Fusion- User manual

This code uses mirroring, 3D nearest neighbor interpolation, one-dimensional extrusion and the level-set method to create modified bilateral breast models from a single breast model. One-dimensional extrusion method mimic of supine postion breat models, because gravity makes breast traight down. The bilateral breast models and whole body human models are seemlessley fused by the mean-curvature driven level set function. The integrated models can be used for the study of Specific Absorption Rate (SAR) and thermal analysis in radio-frequency(RF) exposure. The following methology have potentials to be applied on any patient-based whole-body models and breast models.

### Example models:
#### Breast models:
- UWM breast models download from http://uwcem.ece.wisc.edu/phantomRepository.html 
- DUKE U breast models can inqure from Dr.Lo at http://railabs.duhs.duke.edu/~jyl/

#### Human models: 
- Hanako female model can be purchased from http://emc.nict.go.jp/bio/data/index_e.html
- Ella female model can be purchased from https://www.itis.ethz.ch/virtual-population/virtual-population/overview/

## 1. Software Set-up.
Download the package and upacked to desired folder. Add-to-Path all functions in folders "Morph functions" and "Kernel".

## 2. Pre-locate breast position.

|Ella model breast model and breast coil pre-locationing|
|:-:|
|<img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/uwm2_wholebody_Ella.png" >| 


|Hanako model breast model and breast coil prelocationing|
|:-:|
|<img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/uwm2_wholebody_Hanako.png" >| 



The cyan color line outlined the muscle porjection of the human models, and serves as a location landmark for breast models positionning. The two circular rings (black) represent the breast coils.The pink and red circles represent projection size of the breast model. The white semi-circle represent the hight effect of the right breast model. Users can define rotational angles, and breast size for the breast model.Best ratio of breast scalling depends on the ratio of breast model voxels size to human model voxel size. Origin locations of human models(white dot at the left bottom corner), bilateral breast models cordinates (yellow dots) and pectoral muscle cordinates(white dots near the breasts) relative to the human models will be the saved.The origion locations will be helpful for positioning the human models and breast models in EM simulation software.


## 3. Breast extrution to pectoral muscle.
The pectoral muscle and bone boundary are first smoothed by Morphological filtering

Before morphological filtering    |  After morphological filtering
:-------------------------:|:-------------------------:
<img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/Chestdata2-2.PNG" width= "100%" height = "100%"> | <img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/ClosePec2-2.PNG" width= "100%" height = "100%">


Run "CreatBreastPectHanako.m" to generate modified left and right breast data "BreastExtrusion_Left" and "BreastExtrusion_Right". Results after execution of "CreatBreastPectHanako.m":

|Axial slice of bilateral Ella breasts|
|:-:|
|<img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/uwm1Combined_axial.png">|

## 4. Apply level-set method to smooth joint.
In the "Morph functions" folder, change the saving path at the last row in  "Levelset.m" or  "Levelset_Hanako.m" to save the .vox file to the desired folder path. Run "Levelset.m" on Ella breast-extrusion models , and "Levelset_Hanako.m" on Hanako breast-extrusion models.


Before Level_set             |  After Level_set
:-------------------------:|:-------------------------:
**un-natural curvature** | **natural curvature**
<img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/joint%20with%20nun-atural%20curvature.png" height="30%" width="120%"> |<img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/joint%20with%20natural%20curvature.png" height="30%" width="120%"> 
**Before level-set (Axial)** | **After level-set (Axial)**
<img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/uwm1LeftbreastBefore_level_set_Axial.png">  | <img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/uwm1LeftbreastAfter_level_set_Axial.png">
**Before level-set (Saggital)**|**After level-set (Saggital)**
<img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/uwm1LeftbreastBefore_levele_set_Saggital.png"> | <img src = "https://github.com/rispoli-lab/Bilateral-Breast-Fusion-/blob/master/Pictures/uwm1LeftbreastAfter_level_set_Saggital.png">


## 5. Export data.
Modified bilateral breast models in .vox format and associated .mmf files are generated using the "WriteToVOX.m" and "WriteTommf.m" functions in the "Additional" folder. Users can also generate .raw fromate files. (Note: the .vox format models incorporated with .mmf files can be imported into Xfdtd (Remcom, State College, PA USA). In addition, these models can also be saved in .raw files and be imported into Sim4Life (ZMT, Switzerland). The 'Additional" folder contains MATLAB functions to facilitate conversions between .raw files and .vox files)
