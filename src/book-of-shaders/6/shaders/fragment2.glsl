#version 300 es

precision mediump float;

uniform vec2 uResolution;
uniform float uTime;

out vec4 fragColor;

vec3 colorA = vec3(0.149, 0.141, 0.912);
vec3 colorB = vec3(1.000, 0.833, 0.224);

const float PI = 3.14159265359;

float plot (vec2 step, float fraction){
  return  smoothstep(fraction - 0.01, fraction, step.y) -
          smoothstep( fraction, fraction + 0.01, step.y);
}

void main() {
  vec2 step = gl_FragCoord.xy / uResolution.xy;
  vec3 color = vec3(0.0);

  vec3 fraction = vec3(step.x);

  fraction.r = smoothstep(0.0, 1.0, step.x);
  fraction.g = sin(step.x * PI);
  fraction.b = pow(step.x, 0.5);

  color = mix(colorA, colorB, fraction);

  // Plot transition lines for each channel
  color = mix(color, vec3(1.0, 0.0, 0.0), plot(step, fraction.r));
  color = mix(color, vec3(0.0, 1.0, 0.0), plot(step, fraction.g));
  color = mix(color, vec3(0.0, 0.0, 1.0), plot(step, fraction.b));

  fragColor = vec4(color, 1.0);
}
