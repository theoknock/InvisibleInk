// Compute kernel that converts color pixels to grayscale

#include <metal_stdlib>
using namespace metal;

// Rec. 709 luma values for grayscale image conversion
constant half3 kRec709Luma = half3(0.2126, 0.7152, 0.0722);

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
    
    half min_new = 0.0;
    half max_new = 0.1;
    half min_old = 0.0;
    half max_old = 1.0;
    
    inColor.r = min_new + ((((inColor.r - min_old) * (max_new - min_new))) / (max_old - min_old));
    inColor.g = min_new + ((((inColor.g - min_old) * (max_new - min_new))) / (max_old - min_old));
    inColor.b = min_new + ((((inColor.b - min_old) * (max_new - min_new))) / (max_old - min_old));
    
    half r = inColor.r;
    half g = inColor.g;
    half b = inColor.b;
    outTexture.write(half4(r, g, b, 1.0), gid);
}
