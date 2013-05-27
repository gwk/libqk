uniform mediump vec2 origin;
uniform mediump vec2 scale;

vec4 viewport2(vec2 pos, float depth) {
  return vec4((pos - origin) * scale * 2. - 1., depth, 1.);
}
