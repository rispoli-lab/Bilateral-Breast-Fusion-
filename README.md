# Bilateral-Breast-Fusion-
This code uses affine transformation and the level-set method to fuse breast models with whole body human models.
Example:
To fuse breast models download from http://uwcem.ece.wisc.edu/phantomRepository.html with
Hanako female model download from http://emc.nict.go.jp/bio/data/index_e.html.
1.  Add-to-Path all functions in folders "Morph functions" and "Kernel".
2.  Run "CreatBreastPectHanako.m" to generate modified left and right breast data "RmBreast" and "LmBreast".
3.  Change the saving path at the last row in  "LevelsetL.m" or  "LevelsetR.m" to save the .vox file to the desired folder path.
4.  Run "LevelsetL.m" on "LmBreast", and "LevelsetR.m" on "RmBreast".
5.  Modified bilateral breast models in .vox format are generated.
