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
  half  gray     = dot(inColor.rgb, kRec709Luma);
  outTexture.write(half4(gray, gray, gray, 1.0), gid);
}
