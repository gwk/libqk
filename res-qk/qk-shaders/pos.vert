uniform mediump mat4 mvp;
attribute vec2 pos;

void main(void) {
  gl_PointSize = 1.0;
  gl_Position = mvp * vec4(pos, 0., 1.);
}
