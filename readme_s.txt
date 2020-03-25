参考
https://blog.csdn.net/KYJL888/article/details/90517569
https://blog.csdn.net/KYJL888/article/details/89956551

文件说明
├── camera.txt   //视觉轨迹数据
├── date_bak
├── evo_python.py  //python的EVO核心程序
├── lidar.txt  //雷达轨迹数据
├── myevo.m   //MATLAB的evo主程序,其中只求TR
├── myevo_rts.m  //MATLAB的evo主程序,其中只求TRS,结果同python的EVO 
├── python_evo.txt
├── readme_s.txt
├── umeyama.m //MATLAB的evo的核心函数,其中只求TR
└── umeyama_rts.m  //MATLAB的evo的核心函数,其中只求TRS,结果同python的EVO 



python的evo使用

evo_traj tum  fr2_desk_ORB.txt  --ref=fr2_desk_groundtruth.txt -p --plot_mode=xyz
evo_ape tum  camera.txt -asv --t_max_diff=100 --plot_mode xyz

evo_ape tum lidar.txt camera.txt -asv --t_max_diff=100 --plot_mode xyz
--------------------------------------------------------------------------------
Loaded 3 stamps and poses from: lidar.txt
Loaded 3 stamps and poses from: camera.txt
Synchronizing trajectories...
Found 3 of max. 3 possible matching timestamps between...
	lidar.txt
and:	camera.txt
..with max. time diff.: 100.0 (s) and time offset: 0.0 (s).
--------------------------------------------------------------------------------
Aligning using Umeyama's method... (with scale correction)
Rotation of alignment:
[[-0.99263834  0.02352895  0.11880875]
 [ 0.00303351 -0.97581099  0.21859487]
 [ 0.12107819  0.21734605  0.96855602]]
Translation of alignment:
[-0.44099301 -0.02595233 -0.3493164 ]
Scale correction: 11.842226620848617
--------------------------------------------------------------------------------
Compared 3 absolute pose pairs.
Calculating APE for translation part pose relation...
--------------------------------------------------------------------------------
APE w.r.t. translation part (m)
(with Sim(3) Umeyama alignment)

       max	1.495317
      mean	1.007357
    median	0.929225
       min	0.597528
      rmse	1.073386
       sse	3.456472
       std	0.370661

________________________________________________
MATLAB的evo使用摘要
mono = load('lidar.txt');
csv = load('camera.txt');

>> R
R =

   -0.9926    0.0030    0.1211
    0.0235   -0.9758    0.2173
    0.1188    0.2186    0.9686

>> t
t =

   13.6138
   -5.3659
  -22.4101


python的evo使用

evo_ape tum  camera.txt lidar.txt -asv --t_max_diff=100 --plot_mode xyz
evo_ape tum  camera.txt lidar.txt -asv --t_max_diff=100 --plot_mode xyz
--------------------------------------------------------------------------------
Loaded 3 stamps and poses from: camera.txt
Loaded 3 stamps and poses from: lidar.txt
Synchronizing trajectories...
Found 3 of max. 3 possible matching timestamps between...
	camera.txt
and:	lidar.txt
..with max. time diff.: 100.0 (s) and time offset: 0.0 (s).
--------------------------------------------------------------------------------
Aligning using Umeyama's method... (with scale correction)
Rotation of alignment:
[[-0.99263834  0.00303351  0.12107819]
 [ 0.02352895 -0.97581099  0.21734605]
 [ 0.11880875  0.21859487  0.96855602]]
Translation of alignment:
[-0.03617996  0.00624722  0.03806161]
Scale correction: 0.08425622029772863
--------------------------------------------------------------------------------
Compared 3 absolute pose pairs.
Calculating APE for translation part pose relation...
--------------------------------------------------------------------------------
APE w.r.t. translation part (m)
(with Sim(3) Umeyama alignment)

       max	0.126309
      mean	0.085462
    median	0.074482
       min	0.055596
      rmse	0.090540
       sse	0.024592
       std	0.029894


___________________
matlab 的evo使用摘要与分析
mono = load('camera.txt');
true = load('lidar.txt');

[[-0.99263834  0.02352895  0.11880875]
 [ 0.00303351 -0.97581099  0.21859487]
 [ 0.12107819  0.21734605  0.96855602]]
  VisibleDeprecationWarning)
('Scaling coefficient=', 11.842226620848621)
('Translation vector=', array([ -5.10966106e-01,  -4.81011428e-04,  -5.89010176e-01]))

ours =  A (python)  [mono原始数据转置]
    0.0024   -2.6424   -1.2369
    0.0038    0.8991    0.5977
    0.0225    3.7258    2.5559

gt =   B(python)   [[true原始数据归一初始原点后转置]]
         0   36.9621   16.3665
         0   -0.8698   -0.2915
         0   40.8038   28.0412


主要解决的问题  np.mean(np.sum(-->sum(mean(
Sx=X_demean.*X_demean; % sx = np.mean(np.sum(Xc*Xc, 0))
Sx=sum(mean(Sx));%     sx = np.mean(np.sum(Xc*Xc, 0))
