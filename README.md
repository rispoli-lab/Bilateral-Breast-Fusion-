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


![alt text](https://purdue0-my.sharepoint.com/personal/li2543_purdue_edu/_layouts/15/guestaccess.aspx?docid=187ded46ea43241ed9d984f378ecd536b&authkey=AfRDgvFTTQeOO23o7rRflVQ&e=b19b591ff59546e68569f70a067c9eab)
![alt text](https://purdue0-my.sharepoint.com/personal/li2543_purdue_edu/_layouts/15/guestaccess.aspx?docid=1e3b2df734412482fb0e45cfe4a69dfac&authkey=AULNV_oFBOBH4dGaaQzeqJY&e=9bb97c4f45f04579918c247bf2182e92)
![alt text](https://purdue0-my.sharepoint.com/personal/li2543_purdue_edu/_layouts/15/guestaccess.aspx?docid=1327c47542023418e94a2b0afa0187e23&authkey=AUHFePMOqA76NBcgyDVOeS8&e=dcc03b2805ec45988b099828bbbdd846) 

4.  Run "LevelsetL.m" on "LmBreast", and "LevelsetR.m" on "RmBreast".



5.  Modified bilateral breast models in .vox format are generated.

Note: the .vox format models can be imported into Xfdtd (Remcom, State College, PA USA). In addition, these models can also be saved in .raw files and be imported into Sim4Life (ZMT, Switzerland). The 'Additional' folder contains MATLAB functions to facilitate conversions between .raw files and .vox files. 
