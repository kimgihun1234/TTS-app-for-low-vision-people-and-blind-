# 여러개의 이미지를 YOLO를 통해 테스트하여 인식이 제대로 됐는지 확인하기 위한 코드이다.
import os

image_folder = './datasets/test/images'  # Path to the folder containing the images

# Get a list of image file names in the folder
image_files = [file for file in os.listdir(image_folder) if file.endswith('.jpg')]

# Loop over the images and run the YOLO detection command for each image
for image_file in image_files:
    image_path = os.path.join(image_folder, image_file)

    # Run the YOLO detection command for each image
    command = f'yolo task=detect mode=predict model=best.pt conf=0.5 source={image_path}'
    os.system(command)