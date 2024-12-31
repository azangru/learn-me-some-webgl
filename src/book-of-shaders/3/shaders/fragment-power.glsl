#version 300 es

precision mediump float;

uniform vec2 uResolution;

out vec4 fragColor;

/**
  The return value from the plot function is between 0.0 and 1.0.
  The function smoothstep(y - 0.02, y, position.y) evaluates to 0.0 at y - 0.02 and below,
  and to 1.0 at anything above y.
  The function smoothstep(y, y + 0.02, position.y) evaluates to 0.0 at y and below,
  and to 1.0 at anything above y + 0.02.
*/
float plot(vec2 position, float y){
  return  smoothstep(y - 0.02, y, position.y) -
          smoothstep(y, y + 0.02, position.y);
}

void main() {
  // create a normalized, aspect-corrected coordinate system
  vec2 st = gl_FragCoord.xy / uResolution.xy; // normalize coordinates between (0,0) and (1,1)

  // plot a function y = x ^ 5
  float y = pow(st.x, 5.0);

  vec3 color = vec3(y);

  float proximity = plot(st, y);

  color = (1.0 - proximity) * color + proximity * vec3(0.0, 1.0, 0.0);

  fragColor = vec4(color, 1.0);
}
