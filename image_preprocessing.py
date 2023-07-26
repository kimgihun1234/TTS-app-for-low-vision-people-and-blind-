# 촬영한 image set을 화소를 조금 낮춰서 저장 후, 순서를 섞어서 다시 저장.
# 제가 초기 데이터들은 화소 낮추는 작업을 안했습니다. image 이름에 add_1 붙은 애들부터는 화소가 낮습니다.
import random
from PIL import Image
import os


def resize_images_in_directory(dir_name, target_res):
    if not os.path.exists(dir_name):
        os.makedirs(dir_name)

    for filename in os.listdir(dir_name):
        input_path = os.path.join(dir_name, filename)
        output_path = os.path.join(dir_name, filename)

        # Check if the file is an image (you can add more image extensions if needed)
        if filename.lower().endswith(('.jpg')):
            try:
                with Image.open(input_path) as img:
                    img.thumbnail(target_res)
                    img.save(output_path)
                    print(f"Resized: {filename}")
            except Exception as e:
                print(f"Error processing {filename}: {e}")


folder_path = './original images' # 여기에 촬영한 사진이나 온라인에서 다운한 사진들을 넣어주면 됩니다.
target_resolution = (1200, 900)  # Width x Height in pixels
resize_images_in_directory(folder_path, target_resolution)


# Get a list of file names in the folder
file_names = os.listdir(folder_path)
random.shuffle(file_names)

for i, file_name in enumerate(file_names):
    # Construct the new file name
    new_file_name = f"image-{i}.jpg"  # Modify this to suit your naming pattern

    # Rename the file
    old_file_path = os.path.join(folder_path, file_name)
    new_file_path = os.path.join(folder_path, new_file_name)
    os.rename(old_file_path, new_file_path)
    print(f"Renamed {file_name} to {new_file_name}")

