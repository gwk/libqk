attribute vec2 pos;


void main(void) {
  gl_PointSize = 1.0;
  gl_Position = viewport2(pos, 0.);
}
