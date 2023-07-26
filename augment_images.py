# offline augmentation 방식으로, 약간의 변형을 준 이미지들을 추가했습니다. 1:1의 비율로 학습시킬 수 있도록 1배수만큼 생성합니다.
# 해당 forder_path 하위 outputs 폴더에 생성됩니다. 생성된 변형 이미지와 오리지널 이미지를 합쳐서, 적절한 비율로 나눠 datasets 폴더 안에
# 넣어주면 됩니다. (저는 train:valid:test = 8:1:1 정도로 했습니다.)
import Augmentor
import os

folder_path = './original images'  # Specify the path to your folder
file_names = os.listdir(folder_path)
num=len(file_names)
p = Augmentor.Pipeline(folder_path)
p.rotate(probability=0.3, max_left_rotation=20, max_right_rotation=20)
p.zoom(probability=0.3, min_factor=1.05, max_factor=1.3)
p.skew(probability=0.3)
p.random_distortion(probability=0.3, grid_width=4, grid_height=4, magnitude=2)


p.sample(int(num))