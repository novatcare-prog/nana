"""
Remove white background and crop Patient app logo
Creates a transparent, tightly cropped version for larger icons
"""

from PIL import Image
import os

def remove_white_and_crop(input_path, output_path, threshold=240, padding=20):
    """
    Remove white background and crop to content
    """
    print(f"Processing: {input_path}")
    
    # Open image and convert to RGBA
    img = Image.open(input_path).convert('RGBA')
    
    # Get pixel data and remove white background
    data = img.getdata()
    new_data = []
    
    for item in data:
        if item[0] > threshold and item[1] > threshold and item[2] > threshold:
            new_data.append((255, 255, 255, 0))  # Transparent
        else:
            new_data.append(item)
    
    img.putdata(new_data)
    
    # Crop to content
    bbox = img.getbbox()
    if bbox:
        # Add minimal padding and make square
        left = max(0, bbox[0] - padding)
        top = max(0, bbox[1] - padding)
        right = min(img.width, bbox[2] + padding)
        bottom = min(img.height, bbox[3] + padding)
        
        # Make it square
        width = right - left
        height = bottom - top
        size = max(width, height)
        
        center_x = (left + right) // 2
        center_y = (top + bottom) // 2
        
        new_left = max(0, center_x - size // 2)
        new_top = max(0, center_y - size // 2)
        new_right = min(img.width, new_left + size)
        new_bottom = min(img.height, new_top + size)
        
        cropped = img.crop((new_left, new_top, new_right, new_bottom))
        
        print(f"  Original: {img.width}x{img.height}")
        print(f"  Cropped: {cropped.width}x{cropped.height}")
        
        cropped.save(output_path, 'PNG')
        print(f"  Saved: {output_path}")
        return True
    
    return False


def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    
    # Patient App logo - use patient_logo.png as source
    input_path = os.path.join(
        project_root,
        "apps", "mch_patient", "assets", "images",
        "patient_logo.png"
    )
    
    output_path = os.path.join(
        project_root,
        "apps", "mch_patient", "assets", "images",
        "logo_cropped.png"
    )
    
    print("=" * 50)
    print("Processing Patient App Logo")
    print("=" * 50)
    
    if os.path.exists(input_path):
        remove_white_and_crop(input_path, output_path, padding=10)  # Tight crop
    else:
        # Try iOS icon as fallback
        input_path = os.path.join(
            project_root,
            "apps", "mch_patient", "ios", "Runner",
            "Assets.xcassets", "AppIcon.appiconset",
            "Icon-App-1024x1024@1x.png"
        )
        if os.path.exists(input_path):
            remove_white_and_crop(input_path, output_path, padding=10)
        else:
            print(f"No source image found!")


if __name__ == "__main__":
    main()
