// simple image display with a texture.

uniform mediump mat4 mvp;
attribute vec2 pos;
varying mediump vec2 tex_coord;

void main(void) {
  gl_Position = mvp * vec4(pos, 0., 1.);
  tex_coord = pos;
}
