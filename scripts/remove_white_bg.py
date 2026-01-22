"""
Remove white background from logo PNG
Creates a transparent version
"""

from PIL import Image
import os

def remove_white_background(input_path, output_path, threshold=240):
    """
    Remove white/near-white background from an image
    threshold: pixels with R,G,B all above this value are made transparent
    """
    print(f"Processing: {input_path}")
    
    # Open image and convert to RGBA
    img = Image.open(input_path).convert('RGBA')
    
    # Get pixel data
    data = img.getdata()
    
    new_data = []
    white_pixels_removed = 0
    
    for item in data:
        # Check if pixel is white/near-white
        if item[0] > threshold and item[1] > threshold and item[2] > threshold:
            # Make it transparent
            new_data.append((255, 255, 255, 0))
            white_pixels_removed += 1
        else:
            new_data.append(item)
    
    # Update image with new data
    img.putdata(new_data)
    
    # Save
    img.save(output_path, 'PNG')
    
    print(f"  Removed {white_pixels_removed:,} white pixels")
    print(f"  Saved: {output_path}")
    print(f"  Size: {os.path.getsize(output_path):,} bytes")
    
    return True

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    
    # Health Worker App logo
    hw_input = os.path.join(
        project_root, 
        "apps", "mch_health_worker", "assets", "images",
        "BLUE_app_launcher_ICON-01.png"
    )
    hw_output = os.path.join(
        project_root,
        "apps", "mch_health_worker", "assets", "images",
        "logo_transparent.png"
    )
    
    print("=" * 50)
    print("Removing white background from logos")
    print("=" * 50)
    
    if os.path.exists(hw_input):
        remove_white_background(hw_input, hw_output)
    else:
        print(f"File not found: {hw_input}")
    
    print("\nDone! Update login_screen.dart to use 'logo_transparent.png'")

if __name__ == "__main__":
    main()
