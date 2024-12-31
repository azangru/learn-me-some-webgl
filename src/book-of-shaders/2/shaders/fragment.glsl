#version 300 es

precision mediump float;

uniform vec2 uResolution;
uniform float uTime;

out vec4 fragColor;

void main() {
  // create a normalized, aspect-corrected coordinate system
  vec2 st = gl_FragCoord.xy/uResolution.xy; // normalize coordinates between (0,0) and (1,1)
  st.x *= uResolution.x/uResolution.y; // adjust the x coordinate to maintain the correct aspect ratio

  vec3 color = vec3(st.x, st.y, abs(sin(uTime)));

  fragColor = vec4(color, 1.0);
  // fragColor = vec4(st.x, st.y, 0.0, 1.0);
}
