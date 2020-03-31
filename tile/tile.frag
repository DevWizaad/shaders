/**
 *  \file tile.frag
 *
 *  The job of the fragment shader is to take the interpolated texture
 *  coordinates calculated in the geometry shader and get the fragment
 *  color from the tilesheet.
 */
#version 330 core
in vec2 texCoor;
layout (location = 0) out vec4 fragColor;

uniform sampler2D tilesheet;

void main()
{
  fragColor = texture(tilesheet, texCoor);
}
