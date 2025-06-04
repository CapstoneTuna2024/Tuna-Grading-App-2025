import os
import cv2

# Define the data directory containing your original images
data_dir = "C:/Users/naren/OneDrive/Desktop/Capstone Tuna/datasets/shades-of-gray-augmented-dataset/Grade C/zoom 70_shear 20"

# Define output directories for each rotation angle
rotations = [90, 180, 270,]
output_dirs = {}  # Initialize output_dirs as a dictionary
for angle in rotations:
    output_dir = os.path.join('C:/Users/naren/OneDrive/Desktop/Capstone Tuna/datasets/shades-of-gray-augmented-dataset/Grade C', f"Zoom70__shear 20_Rotated_{angle}")
    os.makedirs(output_dir, exist_ok=True)
    output_dirs[angle] = output_dir

# Function to perform rotation at a specified angle
def rotate_image(image_path, angle):
    # Load the image
    img = cv2.imread(image_path)

    # Get image dimensions and calculate the center
    (h, w) = img.shape[:2]
    center = (w // 2, h // 2)

    # Compute the rotation matrix for the given angle
    rotation_matrix = cv2.getRotationMatrix2D(center, angle, 1.0)

    # Determine the bounding box size for the rotated image
    abs_cos = abs(rotation_matrix[0, 0])
    abs_sin = abs(rotation_matrix[0, 1])
    new_w = int(h * abs_sin + w * abs_cos)
    new_h = int(h * abs_cos + w * abs_sin)

    # Adjust the rotation matrix to account for translation
    rotation_matrix[0, 2] += new_w / 2 - center[0]
    rotation_matrix[1, 2] += new_h / 2 - center[1]

    # Rotate the image with the new bounding box
    rotated_img = cv2.warpAffine(img, rotation_matrix, (new_w, new_h))

    # Get filename without extension
    filename, ext = os.path.splitext(os.path.basename(image_path))

    # Create the output filename with "_rotated" suffix
    output_filename = os.path.join(output_dirs[angle], f"{filename}_rotated{angle}{ext}")

    # Save the rotated image in the appropriate directory
    cv2.imwrite(output_filename, rotated_img)

# Loop through the original images and apply each rotation
for filename in os.listdir(data_dir):
    # Skip non-image files (adjust if needed)
    if not filename.lower().endswith(('.png', '.jpg', '.jpeg')):
        continue

    # Get the full image path
    image_path = os.path.join(data_dir, filename)

    # Perform each specified rotation
    for angle in rotations:
        rotate_image(image_path, angle)
