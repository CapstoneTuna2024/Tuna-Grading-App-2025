import os
import cv2

# Define the data directory containing your images
data_dir = "C:/Users/naren/OneDrive/Desktop/Capstone Tuna/datasets/shades-of-gray-augmented-dataset/Grade C/zoom 70"
dest_dir = "C:/Users/naren/OneDrive/Desktop/Capstone Tuna/datasets/shades-of-gray-augmented-dataset/Grade C"

# Define the output directory for flipped images (create it if it doesn't exist)
flipped_dir = os.path.join("C:/Users/naren/OneDrive/Desktop/Capstone Tuna/datasets/shades-of-gray-augmented-dataset/Grade C", "Zoom70_flipped h")
os.makedirs(flipped_dir, exist_ok=True)

# Loop through the original images (avoid duplicates)
seen_filenames = set()
for filename in os.listdir(data_dir):
  # Skip non-image files (adjust if needed)
  if not filename.lower().endswith(('.png', '.jpg', '.jpeg')):
    continue

  # Check if already processed (skip duplicates)
  if filename in seen_filenames:
    continue
  seen_filenames.add(filename)

  # Get the full image path
  image_path = os.path.join(data_dir, filename)

  # Load the image
  img = cv2.imread(image_path)

  # Flip the image horizontally = 1/vertically = 0
  flipped_img = cv2.flip(img, 1)

  # Create the output filename in the flipped directory
  output_filename = os.path.join(flipped_dir, f"{filename}")  # Keep original filename

  # Save the flipped image
  cv2.imwrite(output_filename, flipped_img)

# Note: This code flips images horizontally and saves them in a new folder named "Flipped" within the data directory.
