/**
 *  \file tile.geom
 *
 *  The job of the geometry shader is to translate the given tile into texture
 *  coordinates, and translate a 1x1 square into the screen-space coordinates of
 *  the given world-space Transform data.
 */
#version 330 core
layout(points) in;
layout(triangle_strip, max_vertices = 4) out;

in vec2 vertTile[];
in vec2 vertPosition[];
in vec2 vertScale[];
in int vertRotation[];
out vec2 texCoor;

uniform ivec2 tilesheetSize;
uniform mat3 worldToScreen;

float u16ToRadians(int rotation)
{
  // Maps [0, 65536) -> [0, 2*PI).
  const float PI = 3.1415926535f;
  const float MAX_U16 = 0xffff + 1;
  return rotation * ((2 * PI) / MAX_U16);
}

mat2 rotate2d(int rotation)
{
  float radian = u16ToRadians(rotation);
  float s = sin(radian);
  float c = cos(radian);
  return mat2(c, s, -s, c);
}

void main()
{
  // Square verticies.
  const vec2 square[4] = vec2[4](
    vec2(-0.5f,  0.5f), // Top-left.
    vec2(-0.5f, -0.5f), // Bottom-left.
    vec2( 0.5f,  0.5f), // Top-right.
    vec2( 0.5f, -0.5f)  // Bottom-right.
  );

  // Create texture coordinates for each vertex.
  // Maps [0, tilesheet.widthTiles] -> [0, 1].
  float texLeft   = vertTile[0].x / tilesheetSize.x;
  float texRight  = (vertTile[0].x + 1) / tilesheetSize.x;
  float texTop    = vertTile[0].y / tilesheetSize.y;
  float texBottom = (vertTile[0].y + 1) / tilesheetSize.y;
  vec2 textureCoords[4] = vec2[4](
    vec2(texLeft,  texTop),
    vec2(texLeft,  texBottom),
    vec2(texRight, texTop),
    vec2(texRight, texBottom)
  );

  // Build the object-space to screen-space affine.
  mat2 scale = mat2(vertScale[0].x, 0, 0, vertScale[0].y);
  mat2 scale_rotate = rotate2d(vertRotation[0]) * scale;
  mat3 objectToWorld = mat3(scale_rotate[0], 0,
                            scale_rotate[1], 0,
                            vertPosition[0], 1);
  mat3 objectToScreen = worldToScreen * objectToWorld;

  for(int i = 0; i < 4; ++i)
  {
    vec3 screenVert = objectToScreen * vec3(square[i], 1);
    gl_Position = vec4(screenVert.xy, 0, 1);

	  // Send texture coordinates to be interpolated for the fragment shader.
    texCoor = textureCoords[i];
    EmitVertex();
  }
  EndPrimitive();
}
