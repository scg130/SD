#@markdown ■■■■■■■■■■■■■■■■■■

#@markdown 初始化openpose

#@markdown ■■■■■■■■■■■■■■■■■■

#设置版本为1.x
# %tensorflow_version 1.x

#安装 cmake

#https://drive.google.com/file/d/1lAXs5X7qMnKQE48I0JqSob4FX1t6-mED/view?usp=sharing
 
file_id = "1lAXs5X7qMnKQE48I0JqSob4FX1t6-mED"
file_name = "cmake-3.13.4.zip"
cd  ./ && curl -sc ./cookie "https://drive.google.com/uc?export=download&id=$file_id" > /dev/null
code = "$(awk '/_warning_/ {print $NF}' ./cookie)"  
cd  ./ && curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=$code&id=$file_id" -o "$file_name"
cd  ./ && unzip cmake-3.13.4.zip
 
cd cmake-3.13.4 && ./configure && make && sudo make install


# 依赖库安装 

sudo apt install caffe-cuda

sudo apt-get --assume-yes update
sudo apt-get --assume-yes install build-essential
# OpenCV
sudo apt-get --assume-yes install libopencv-dev
# General dependencies
sudo apt-get --assume-yes install libatlas-base-dev libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler
sudo apt-get --assume-yes install --no-install-recommends libboost-all-dev
# Remaining dependencies, 14.04
sudo apt-get --assume-yes install libgflags-dev libgoogle-glog-dev liblmdb-dev
# Python3 libs
sudo apt-get --assume-yes install python3-setuptools python3-dev build-essential
sudo apt-get --assume-yes install python3-pip
sudo -H pip3 install --upgrade numpy protobuf opencv-python
# OpenCL Generic
sudo apt-get --assume-yes install opencl-headers ocl-icd-opencl-dev
sudo apt-get --assume-yes install libviennacl-dev


 # Openpose安装
ver_openpose = "v1.5.1"
 
#  Openpose の clone
git clone  --depth 1 -b "$ver_openpose" https://github.com/CMU-Perceptual-Computing-Lab/openpose.git 
# git clone  --depth 1 -b v1.5.1 https://github.com/CMU-Perceptual-Computing-Lab/openpose.git     
 
#  Openpose の モデルデータDL
cd openpose/models && ./getModels.sh

#编译Openpose
cd openpose && rm -r build || true && mkdir build && cd build && cmake .. && make -j`nproc` # example demo usage

# 执行示例确认
cd /content/openpose && ./build/examples/openpose/openpose.bin --video examples/media/video.avi --write_json ./output/ --display 0  --write_video ./output/openpose.avi






#@markdown ■■■■■■■■■■■■■■■■■■

#@markdown 其他工具初始化

#@markdown ■■■■■■■■■■■■■■■■■■

import time

init_start_time = time.time()



ver_tag = "ver1.03.02"

# mannequinchallenge-vmd の clone
git clone  --depth 1 -b "$ver_tag" https://github.com/miu200521358/mannequinchallenge-vmd.git

# FCRN-DepthPrediction-vmd 识别深度模型下载

# mannequinchallenge-vmd の モデルデータDL

# モデルデータのダウンロード
cd  ./mannequinchallenge-vmd && ./fetch_checkpoints.sh


# 3d-pose-baseline-vmd  clone
git clone  --depth 1 -b "$ver_tag" https://github.com/miu200521358/3d-pose-baseline-vmd.git

# 3d-pose-baseline-vmd Human3.6M 模型数据DL

# 建立Human3.6M模型数据文件夹
mkdir -p ./3d-pose-baseline-vmd/data/h36m

# 下载Human3.6M模型数据并解压
file_id = "1W5WoWpCcJvGm4CHoUhfIB0dgXBDCEHHq"
file_name = "h36m.zip"
cd  ./ && curl -sc ./cookie "https://drive.google.com/uc?export=download&id=$file_id" > /dev/null
code = "$(awk '/_warning_/ {print $NF}' ./cookie)"  
cd  ./ && curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=$code&id=$file_id" -o "$file_name"
cd  ./ && unzip h36m.zip
mv ./h36m ./3d-pose-baseline-vmd/data/

# 3d-pose-baseline-vmd 训练数据

# 3d-pose-baseline学习数据文件夹
mkdir -p ./3d-pose-baseline-vmd/experiments

# 下载3d-pose-baseline训练后的数据
file_id = "1v7ccpms3ZR8ExWWwVfcSpjMsGscDYH7_"
file_name = "experiments.zip"
cd  ./3d-pose-baseline-vmd && curl -sc ./cookie "https://drive.google.com/uc?export=download&id=$file_id" > /dev/null
code = "$(awk '/_warning_/ {print $NF}' ./cookie)"  
cd  ./3d-pose-baseline-vmd && curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=$code&id=$file_id" -o "$file_name"
cd  ./3d-pose-baseline-vmd && unzip experiments.zip


# VMD-3d-pose-baseline-multi  clone

git clone  --depth 1 -b "$ver_tag" https://github.com/miu200521358/VMD-3d-pose-baseline-multi.git

# 安装VMD-3d-pose-baseline-multi 依赖库

sudo apt-get install python3-pyqt5  
sudo apt-get install pyqt5-dev-tools
sudo apt-get install qttools5-dev-tools




init_elapsed_time = (time.time() - init_start_time) / 60

echo "■■■■■■■■■■■■■■■■■■■■■■■■"
echo "■■所有初始化均已完成"
echo "■■"
echo "■■处理时间：" "$init_elapsed_time" "分"
echo "■■■■■■■■■■■■■■■■■■■■■■■■"

echo "Openpose执行结果"

ls -l /content/openpose/output








#@markdown ■■■■■■■■■■■■■■■■■■

#@markdown 执行函数初始化

#@markdown ■■■■■■■■■■■■■■■■■■

import os
import cv2
import datetime


import time
import datetime
import cv2
import shutil
import glob

from google.colab import files

static_number_people_max = 1  
static_frame_first = 0 
static_end_frame_no = -1  
static_reverse_specific = "" 
static_order_specific = "" 
static_born_model_csv = "born/animasa_miku_born.csv"
static_is_ik = 1 
static_heel_position = 0.0 
static_center_z_scale =   1
static_smooth_times =   1
static_threshold_pos = 0.5 
static_threshold_rot = 3  
static_depth_smooth_times = 4

static_src_input_video = ""
static_input_video = ""

#执行文件夹
openpose_path = "/content/openpose"

#输出文件夹
base_path = "/content/output"
output_json = "/content/output/json"
output_openpose_avi = "/content/output/openpose.avi"



now_str = ""
depth_dir_path = ""
drive_dir_path = ""

def video_hander(  input_video):
  global base_path
  print("视频名称: ", os.path.basename(input_video))
  print("视频大小: ", os.path.getsize(input_video))


  video = cv2.VideoCapture(input_video)
  # 宽
  W = video.get(cv2.CAP_PROP_FRAME_WIDTH)
  # 高
  H = video.get(cv2.CAP_PROP_FRAME_HEIGHT)
  # 总帧数
  count = video.get(cv2.CAP_PROP_FRAME_COUNT)
  # fps
  fps = video.get(cv2.CAP_PROP_FPS)

  print("宽: {0}, 高: {1}, 总帧数: {2}, fps: {3}".format(W, H, count, fps))



  width = 1280
  height = 720

  if W != 1280 or (fps != 30 and fps != 60):
      print("重新编码，因为大小或fps不在范围: "+ input_video)
      
      # 縮尺
      scale = width / W
      
      # 高さ
      height = int(H * scale)

      # 出力ファイルパス
      out_name = 'recode_{0}.mp4'.format("{0:%Y%m%d_%H%M%S}".format(datetime.datetime.now()))
      out_path = '{0}/{1}'.format(base_path, out_name)
      
      # try:
      #     fourcc = cv2.VideoWriter_fourcc(*"MP4V")
      #     out = cv2.VideoWriter(out_path, fourcc, 30.0, (width, height), True)
      #     # 入力ファイル
      #     cap = cv2.VideoCapture(input_video)

      #     while(cap.isOpened()):
      #         # 動画から1枚キャプチャして読み込む
      #         flag, frame = cap.read()  # Capture frame-by-frame

      #         # 動画が終わっていたら終了
      #         if flag == False:
      #             break

      #         # 縮小
      #         output_frame = cv2.resize(frame, (width, height))

      #         # 出力
      #         out.write(output_frame)

      #     # 終わったら開放
      #     out.release()
      # except Exception as e:
      #     print("重新编码失败", e)

      # cap.release()
      # cv2.destroyAllWindows()

      # mkvmerge --default-duration 0:30fps --fix-bitstream-timing-information 0 "$input_video" -o temp-video.mkv
      # ffmpeg -i temp-video.mkv -c:v copy  side_video.mkv
      # ffmpeg -i side_video.mkv -vf scale=1280:720 "$out_path"

      ffmpeg -i "$input_video" -qscale 0 -r 30 -y -vf scale=1280:720 "$out_path"
      
      print('MMD重新生成MP4文件成功', out_path)
      input_video_name = out_name

      # 入力動画ファイル再設定
      input_video = base_path + "/"+ input_video_name
      
      video = cv2.VideoCapture(input_video)
      # 幅
      W = video.get(cv2.CAP_PROP_FRAME_WIDTH)
      # 高さ
      H = video.get(cv2.CAP_PROP_FRAME_HEIGHT)
      # 総フレーム数
      count = video.get(cv2.CAP_PROP_FRAME_COUNT)
      # fps
      fps = video.get(cv2.CAP_PROP_FPS)

      print("【重新生成】宽: {0}, 高: {1}, 总帧数: {2}, fps: {3}, 名字: {4}".format(W, H, count, fps,input_video_name))
  return input_video


def run_openpose(input_video,number_people_max,frame_first):
  #建立临时文件夹

  mkdir -p "$output_json"
  #开始执行
  cd "$openpose_path" && ./build/examples/openpose/openpose.bin --video "$input_video" --display 0 --model_pose COCO --write_json "$output_json" --write_video "$output_openpose_avi" --frame_first "$frame_first" --number_people_max "$number_people_max"

def run_mannequinchallenge_depth(input_video,end_frame_no,reverse_specific,order_specific):
  global now_str,depth_dir_path,drive_dir_path
  now_str = "{0:%Y%m%d_%H%M%S}".format(datetime.datetime.now())

  cd mannequinchallenge-vmd && python predict_video.py --video_path "$input_video" --json_path "$output_json" --interval 20 --reverse_specific "$reverse_specific" --order_specific "$order_specific" --verbose 1 --now "$now_str" --avi_output "yes"  --number_people_max "$number_people_max" --end_frame_no "$end_frame_no" --input single_view --batchSize 1


  # 深度結果コピー
  depth_dir_path =  output_json + "_" + now_str + "_depth"
  drive_dir_path = base_path + "/" + now_str 

  mkdir -p "$drive_dir_path"

  if os.path.exists( depth_dir_path + "/error.txt"):
    
    # 发生错误
    cp "$depth_dir_path"/error.txt "$drive_dir_path"

    echo "■■■■■■■■■■■■■■■■■■■■■■■■"
    echo "■■由于发生错误，处理被中断。"
    echo "■■"
    echo "■■■■■■■■■■■■■■■■■■■■■■■■"

    echo "$drive_dir_path" "请检查 error.txt 的内容。"
  else:
      
      cp "$depth_dir_path"/*.avi "$drive_dir_path"
      cp "$depth_dir_path"/message.log "$drive_dir_path"
      cp "$depth_dir_path"/reverse_specific.txt "$drive_dir_path"
      cp "$depth_dir_path"/order_specific.txt "$drive_dir_path"

      for i in range(1, number_people_max+1):
          echo ------------------------------------------
          echo 3d-pose-baseline-vmd ["$i"]
          echo ------------------------------------------

          target_name = "_" + now_str + "_idx0" + str(i)
          target_dir = output_json + target_name

          !cd ./3d-pose-baseline-vmd && python src/openpose_3dpose_sandbox_vmd.py --camera_frame --residual --batch_norm --dropout 0.5 --max_norm --evaluateActionWise --use_sh --epochs 200 --load 4874200 --gif_fps 30 --verbose 1 --openpose "$target_dir" --person_idx 1    

def run_3d_to_vmd(number_people_max,born_model_csv,is_ik,heel_position,center_z_scale,smooth_times,threshold_pos,threshold_rot,depth_smooth_times):
  global now_str,depth_dir_path,drive_dir_path
  for i in range(1, number_people_max+1):
    target_name = "_" + now_str + "_idx0" + str(i)
    target_dir = output_json + target_name
    for f in glob.glob(target_dir +"/*.vmd"):
      rm "$f"
    cd ./VMD-3d-pose-baseline-multi && python main.py -v 2 -t "$target_dir" -b "$born_model_csv" -c 30 -z "$center_z_scale" -s "$smooth_times" -p "$threshold_pos" -r "$threshold_rot" -k "$is_ik" -e "$heel_position" -d "$depth_smooth_times"

    # INDEX別結果コピー
    idx_dir_path = drive_dir_path + "/idx0" + str(i)
    mkdir -p "$idx_dir_path"
    
    # 日本語対策でpythonコピー
    for f in glob.glob(target_dir +"/*.vmd"):
        shutil.copy(f, idx_dir_path)
        print(f)
        files.download(f)
    
    cp "$target_dir"/pos.txt "$idx_dir_path"
    cp "$target_dir"/start_frame.txt "$idx_dir_path"



def run_mmd(input_video,number_people_max,frame_first,end_frame_no,reverse_specific,order_specific,born_model_csv,is_ik,heel_position,center_z_scale,smooth_times,threshold_pos,threshold_rot,depth_smooth_times):

  global static_input_video,static_number_people_max ,static_frame_first ,static_end_frame_no,static_reverse_specific ,static_order_specific,static_born_model_csv 
  global static_is_ik,static_heel_position ,static_center_z_scale ,static_smooth_times ,static_threshold_pos ,static_threshold_rot 
  global base_path,static_src_input_video,static_depth_smooth_times

  start_time = time.time()

  video_check= False
  openpose_check = False
  Fcrn_depth_check = False
  pose_to_vmd_check = False

#源文件对比
  if static_src_input_video != input_video:
    video_check = True
    openpose_check = True
    Fcrn_depth_check = True
    pose_to_vmd_check = True

  if (static_number_people_max != number_people_max) or (static_frame_first != frame_first):
    openpose_check = True
    Fcrn_depth_check = True
    pose_to_vmd_check = True

  if (static_end_frame_no != end_frame_no) or (static_reverse_specific != reverse_specific) or (static_order_specific != order_specific):
    Fcrn_depth_check = True
    pose_to_vmd_check = True

  if (static_born_model_csv != born_model_csv) or (static_is_ik != is_ik) or (static_heel_position != heel_position) or (static_center_z_scale != center_z_scale) or \
    (static_smooth_times != smooth_times) or (static_threshold_pos != threshold_pos) or (static_threshold_rot != threshold_rot) or (static_depth_smooth_times != depth_smooth_times ):
    pose_to_vmd_check = True

  #因为视频源文件重置，所以如果无修改需要重命名文件
  if video_check:
    rm -rf "$base_path"
    mkdir -p "$base_path"
    static_src_input_video = input_video
    input_video = video_hander(input_video)
    static_input_video = input_video
  else:
    input_video = static_input_video

  if openpose_check:
    run_openpose(input_video,number_people_max,frame_first)
    static_number_people_max = number_people_max
    static_frame_first = frame_first

  if Fcrn_depth_check:
    run_mannequinchallenge_depth(input_video,end_frame_no,reverse_specific,order_specific)
    static_end_frame_no =   end_frame_no
    static_reverse_specific = reverse_specific
    static_order_specific =  order_specific

  if pose_to_vmd_check:
    run_3d_to_vmd(number_people_max,born_model_csv,is_ik,heel_position,center_z_scale,smooth_times,threshold_pos,threshold_rot,depth_smooth_times)
    static_born_model_csv = born_model_csv 
    static_is_ik = is_ik
    static_heel_position = heel_position
    static_center_z_scale = center_z_scale
    static_smooth_times = smooth_times
    static_threshold_pos = threshold_pos
    static_threshold_rot = threshold_rot
    static_depth_smooth_times = depth_smooth_times


  elapsed_time = (time.time() - start_time) / 60
  print( "■■■■■■■■■■■■■■■■■■■■■■■■")
  print( "■■所有处理完成")
  print( "■■")
  print( "■■处理時間：" + str(elapsed_time)+ "分")
  print( "■■■■■■■■■■■■■■■■■■■■■■■■")
  print( "")
  print( "MMD自动跟踪执行结果")
  print( base_path)
  ls -l "$base_path"

