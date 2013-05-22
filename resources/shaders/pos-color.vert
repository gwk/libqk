attribute vec2 pos;
varying lowp vec4 frag_color;

void main(void) {
  gl_PointSize = 1.0;
  gl_Position = viewport2(pos, 0.);
  frag_color = vec4((pos - origin) * scale, 0, 1);
}
