uniform sampler2D image;
varying mediump vec2 tex_coord;

void main(void) {
  gl_FragColor = texture2D(image, tex_coord);
}
