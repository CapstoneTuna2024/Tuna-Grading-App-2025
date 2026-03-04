# Tuna-Grading-App-2025
This project focuses on automating tuna loin quality grading using computer vision and deep learning. The goal is to develop an objective, consistent, and scalable system that classifies tuna loin into three quality grades based on color and texture characteristics.

📌 Background
Tuna loin grading in the industry is typically performed manually by human experts. This process is:
- Subjective
- Dependent on lighting conditions
- Inconsistent between graders
- Difficult to scale

To address these challenges, this project leverages deep learning to build a model capable of classifying tuna loin images into:
- Grade A → Bright red color, fine and smooth texture
- Grade B → Slight loss of color and clarity
- Grade C → Pale pink color, rough texture

🧠 Model Architecture
This project uses:
- EfficientNetV2-M as the backbone model
- Transfer learning from pretrained weights
- Fine-tuning for 3-class classification

EfficientNetV2-M was chosen due to its:
- Strong performance-to-parameter efficiency
- Scalability
- Suitability for deployment in mobile/cloud environments

⚠️ Real-World Challenge
One of the main difficulties in this project is inconsistent lighting conditions during image capture.
Several preprocessing techniques were explored:
- Shades of Gray (SOG)
- Self-Adaptive Illumination Correction (SAIC)
- Contrast Limited Adaptive Histogram Equalization (CLAHE)

However, these methods altered important color characteristics critical for grading accuracy. Therefore, preprocessing strategies were carefully evaluated to preserve color fidelity while improving robustness.

🔬 Research Focus
This project emphasizes:
- Robust classification under varying lighting conditions
- Preservation of critical color features
- Model generalization in real-world industrial environments
- Deployment-ready deep learning architecture

📱 Deployment Plan
This model is designed for real-world usability.
Mobile Application
- Built using Flutter
- Users can:
  - Capture tuna loin images directly
  - Upload images from storage
- Cloud Inference
  - Model exported to ONNX
  - Planned deployment on Google Cloud Platform (GCP)
  - Backend processes image and returns predicted grade
This enables scalable grading without requiring high-compute devices on-site.

🚀 Future Improvements
- Advanced color constancy algorithms
- Domain adaptation for lighting variability
- Model optimization for edge deployment
- Industrial integration for seafood processing plants

🎯 Objective
To create an objective, efficient, and scalable tuna loin grading system that reduces subjectivity, improves consistency, and supports decision-making in seafood quality control.
