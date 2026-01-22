"""
Crop transparent PNG to remove excess whitespace
Makes the icon appear larger in taskbar/title bar
"""

from PIL import Image
import os

def crop_to_content(input_path, output_path, padding=10):
    """
    Crop image to its non-transparent content with optional padding
    """
    print(f"Processing: {input_path}")
    
    img = Image.open(input_path).convert('RGBA')
    
    # Get the bounding box of non-transparent pixels
    bbox = img.getbbox()
    
    if bbox:
        # Add padding
        left = max(0, bbox[0] - padding)
        top = max(0, bbox[1] - padding)
        right = min(img.width, bbox[2] + padding)
        bottom = min(img.height, bbox[3] + padding)
        
        # Make it square (use the larger dimension)
        width = right - left
        height = bottom - top
        size = max(width, height)
        
        # Center the content in a square
        center_x = (left + right) // 2
        center_y = (top + bottom) // 2
        
        new_left = max(0, center_x - size // 2)
        new_top = max(0, center_y - size // 2)
        new_right = min(img.width, new_left + size)
        new_bottom = min(img.height, new_top + size)
        
        # Crop
        cropped = img.crop((new_left, new_top, new_right, new_bottom))
        
        print(f"  Original: {img.width}x{img.height}")
        print(f"  Cropped: {cropped.width}x{cropped.height}")
        
        # Save
        cropped.save(output_path, 'PNG')
        print(f"  Saved: {output_path}")
        
        return True
    else:
        print("  No content found!")
        return False


def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    
    input_path = os.path.join(
        project_root,
        "apps", "mch_health_worker", "assets", "images",
        "logo_transparent.png"
    )
    
    output_path = os.path.join(
        project_root,
        "apps", "mch_health_worker", "assets", "images",
        "logo_cropped.png"
    )
    
    print("=" * 50)
    print("Cropping logo to remove whitespace")
    print("=" * 50)
    
    if os.path.exists(input_path):
        crop_to_content(input_path, output_path, padding=50)
    else:
        print(f"File not found: {input_path}")
    
    print("\nDone!")


if __name__ == "__main__":
    main()
