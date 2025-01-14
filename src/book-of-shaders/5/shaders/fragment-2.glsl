#version 300 es

precision mediump float;

uniform vec2 uResolution;
uniform float uTime;

out vec4 fragColor;

const float PI = 3.14159265359;

float scale = 0.0013;
float gridWidth = 2.7;
float lineJitter = 0.2;
float lineWidth = 3.0;
float zoom = 2.5;
vec2 offset = vec2(0.5);

float rand (vec2 co) {
  return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
}

// Multiply x by PI before computing the sin. Note how the two phases shrink so each cycle repeats every 2 integers.
float testFn(float x) {
  return sin(PI * x);
}

vec3 plot2D(in vec2 position, in float width ) {
  float samples = 3.0;

  vec2 steping = width * vec2(scale) / samples;
  
  float count = 0.0;
  float mySamples = 0.0;

  for (float i = 0.0; i < samples; i++) {
    for (float j = 0.0; j < samples; j++) {
      if (i * i + j * j > samples * samples) 
        continue;

      mySamples++;

      float ii = i + lineJitter * rand(vec2(position.x + i * steping.x, position.y + j * steping.y));
      float jj = j + lineJitter * rand(vec2(position.y + i * steping.x, position.x + j * steping.y));

      float f = testFn(position.x + ii * steping.x) - (position.y + jj * steping.y);
      count += (f > 0.) ? 1.0 : -1.0;
    }
  }
  vec3 color = vec3(1.0);

  if (abs(count) != mySamples)
    color = vec3(abs(float(count)) / float(mySamples));
  return color;
}


vec3 grid2D(in vec2 position, in float width) {
  float axisDetail = width * scale;
  if (abs(position.x) < axisDetail || abs(position.y) < axisDetail) 
    return 1.0 - vec3(0.65, 0.65, 1.0);
  if (abs(mod(position.x, 1.0)) < axisDetail || abs(mod(position.y, 1.0)) < axisDetail) 
    return 1.0 - vec3(0.80, 0.80, 1.0);
  if (abs(mod(position.x, 0.25)) < axisDetail || abs(mod(position.y, 0.25)) < axisDetail) 
    return 1.0 - vec3(0.95,0.95,1.0);
  return vec3(0.0);
}


void main() {
  // create a normalized, aspect-corrected coordinate system
  vec2 step = gl_FragCoord.xy/uResolution.xy; // normalize coordinates between (0,0) and (1,1)
  step -= offset;
  step.x *= uResolution.x/uResolution.y; // adjust the x coordinate to maintain the correct aspect ratio

  scale *= zoom;
  step *= zoom;

  vec3 color = plot2D(step,lineWidth) - grid2D(step, gridWidth);

  fragColor = vec4(color, 1.0);
}
