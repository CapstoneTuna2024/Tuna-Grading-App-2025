import cv2
import os
import numpy as np

def zoom_image(image, zoom_factor):
    """
    Zooms into the image by the specified zoom factor.
    
    Args:
        image (numpy array): The input image.
        zoom_factor (float): The zoom factor; values >1 zoom in, values <1 zoom out.
    
    Returns:
        numpy array: The zoomed image.
    """
    height, width = image.shape[:2]
    
    # Calculate the cropping box
    crop_height = int(height / zoom_factor)
    crop_width = int(width / zoom_factor)
    start_y = (height - crop_height) // 2
    start_x = (width - crop_width) // 2
    
    # Crop and resize back to original dimensions
    cropped_image = image[start_y:start_y + crop_height, start_x:start_x + crop_width]
    zoomed_image = cv2.resize(cropped_image, (width, height), interpolation=cv2.INTER_LINEAR)
    
    return zoomed_image

def process_images(src_dir, dest_dir, zoom_factor):
    """
    Applies zoom augmentation to all images in the source directory and saves to destination directory.
    
    Args:
        src_dir (str): Path to the source directory containing images.
        dest_dir (str): Path to the destination directory to save zoomed images.
        zoom_factor (float): The zoom factor for augmentation.
    """
    # Ensure destination directory exists
    if not os.path.exists(dest_dir):
        os.makedirs(dest_dir)
    
    # Process each image in the source directory
    for filename in os.listdir(src_dir):
        if filename.lower().endswith(('.png', '.jpg', '.jpeg', '.bmp')):
            img_path = os.path.join(src_dir, filename)
            image = cv2.imread(img_path)
            
            if image is not None:
                zoomed_image = zoom_image(image, zoom_factor)
                
                # Save the zoomed image
                save_path = os.path.join(dest_dir, f"zoomed_{filename}")
                cv2.imwrite(save_path, zoomed_image)
                print(f"Saved zoomed image: {save_path}")
            else:
                print(f"Failed to load image: {img_path}")

# Example usage
source_directory = 'C:/Users/naren/OneDrive/Desktop/Capstone Tuna/datasets/shades-of-gray-augmented-dataset/Grade A'  # Replace with your source directory path
destination_directory = 'C:/Users/naren/OneDrive/Desktop/Capstone Tuna/datasets/shades-of-gray-augmented-dataset/Grade A/zoom 70'  # Replace with your destination directory path
zoom_factor = 1.7  # Set zoom factor (ex. 1.2 means 20% zoom in)

process_images(source_directory, destination_directory, zoom_factor)
