// Compute kernel that converts color pixels to grayscale

#include <metal_stdlib>
using namespace metal;

// Rec. 709 luma values for grayscale image conversion

// Grayscale compute kernel
kernel void
grayscaleKernel(texture2d<half, access::read>  inTexture  [[texture(0)]],
                texture2d<half, access::write> outTexture [[texture(1)]],
                ushort2                          gid         [[thread_position_in_grid]])
{
    // Check if the pixel is within the bounds of the output texture
    if((gid.x >= outTexture.get_width()) || (gid.y >= outTexture.get_height()))
    {
        // Return early if the pixel is out of bounds
        return;
    }
    
    half4 inColor  = inTexture.read(gid);
    
    // Contrast Reduction
    
    half min_new = 0.0;
    half max_new = 0.000001;
    half min_old = 0.0;
    half max_old = 1.0;
    
    inColor.r = min_new + ((((inColor.r - min_old) * (max_new - min_new))) / (max_old - min_old));
    inColor.g = min_new + ((((inColor.g - min_old) * (max_new - min_new))) / (max_old - min_old));
    inColor.b = min_new + ((((inColor.b - min_old) * (max_new - min_new))) / (max_old - min_old));
    
    half r = inColor.r;
    half g = inColor.g;
    half b = inColor.b;
    
    // Contrast Stretch
    half min_new_2 = 0.0;
    half max_new_2 = 1.0;
    half min_old_2 = 0.0;
    half max_old_2 = 0.000001;
    
    r = min_new_2 + ((((r - min_old_2) * (max_new_2 - min_new_2))) / (max_old_2 - min_old_2));
    g = min_new_2 + ((((g - min_old_2) * (max_new_2 - min_new_2))) / (max_old_2 - min_old_2));
    b = min_new_2 + ((((b - min_old_2) * (max_new_2 - min_new_2))) / (max_old_2 - min_old_2));
    
    outTexture.write(half4(r, g, b, 1.0), gid);
}
