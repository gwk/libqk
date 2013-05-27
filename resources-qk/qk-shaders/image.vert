attribute vec2 pos;
varying mediump vec2 tex_coord;


void main(void) {
  gl_Position = viewport2(pos, 0.);
  tex_coord = pos;
}
