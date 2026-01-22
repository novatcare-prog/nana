"""
Windows ICO Generator for Nana MCH Kenya Apps
Generates multi-size ICO files from source PNG images
"""

from PIL import Image
import os

# Define paths relative to this script
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)

# Windows ICO sizes (in order from smallest to largest)
ICO_SIZES = [16, 24, 32, 48, 64, 128, 256]

def generate_ico(source_png: str, output_ico: str, app_name: str):
    """Generate a multi-size ICO file from a source PNG"""
    
    print(f"\n📱 {app_name}")
    print(f"   Source: {source_png}")
    print(f"   Output: {output_ico}")
    
    if not os.path.exists(source_png):
        print(f"   ❌ Source file not found!")
        return False
    
    try:
        # Open the source image
        img = Image.open(source_png)
        
        # Convert to RGBA if needed
        if img.mode != 'RGBA':
            img = img.convert('RGBA')
        
        print(f"   Original size: {img.size[0]}x{img.size[1]}")
        
        # Generate all sizes as a list of tuples
        icon_sizes = [(size, size) for size in ICO_SIZES]
        
        # Create resized images
        images = []
        for size in ICO_SIZES:
            resized = img.resize((size, size), Image.Resampling.LANCZOS)
            images.append(resized)
            print(f"   ✓ Generated {size}x{size}")
        
        # Save as ICO - use the largest as base and include all sizes
        # Pillow's ICO save requires sizes parameter
        img.save(
            output_ico,
            format='ICO',
            sizes=icon_sizes
        )
        
        # Verify file size
        file_size = os.path.getsize(output_ico)
        print(f"   ✅ Saved: {output_ico} ({file_size:,} bytes)")
        
        if file_size < 10000:
            print(f"   ⚠️  Warning: File seems too small, may only have 1 size")
        
        return True
        
    except Exception as e:
        print(f"   ❌ Error: {e}")
        import traceback
        traceback.print_exc()
        return False


def main():
    print("=" * 50)
    print("Windows ICO Generator for Nana Apps")
    print("=" * 50)
    
    # Health Worker App - use cropped transparent logo
    hw_source = os.path.join(
        PROJECT_ROOT,
        "apps", "mch_health_worker", "assets", "images",
        "logo_cropped.png"
    )
    hw_output = os.path.join(
        PROJECT_ROOT,
        "apps", "mch_health_worker", "windows", "runner", "resources",
        "app_icon.ico"
    )
    
    generate_ico(hw_source, hw_output, "Health Worker App")
    
    # Patient App
    pt_source = os.path.join(
        PROJECT_ROOT,
        "apps", "mch_patient", "ios", "Runner",
        "Assets.xcassets", "AppIcon.appiconset",
        "Icon-App-1024x1024@1x.png"
    )
    pt_output = os.path.join(
        PROJECT_ROOT,
        "apps", "mch_patient", "windows", "runner", "resources",
        "app_icon.ico"
    )
    
    generate_ico(pt_source, pt_output, "Patient App")
    
    print("\n" + "=" * 50)
    print("Complete! Rebuild the apps to apply new icons:")
    print("  cd apps\\mch_health_worker && flutter clean && flutter build windows")
    print("  cd apps\\mch_patient && flutter clean && flutter build windows")
    print("=" * 50)


if __name__ == "__main__":
    main()
