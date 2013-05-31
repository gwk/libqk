uniform mediump mat4 mvp;
attribute vec2 pos;
attribute vec4 color;
varying lowp vec4 frag_color;

void main(void) {
  gl_PointSize = 1.0;
  gl_Position = mvp * vec4(pos, 0., 1.);
  frag_color = color;
}
