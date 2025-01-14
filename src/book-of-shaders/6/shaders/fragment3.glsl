#version 300 es

precision mediump float;

uniform vec2 uResolution;
uniform float uTime;

out vec4 fragColor;


const int color1Hex = 0x65749f; // the blue of the sky
const int color2Hex = 0xdc5224; // the red of the setting sun
const int color3Hex = 0xe2dec1; // the white of the cloud

const float PI = 3.14159265359;

vec3 hexToRgb(int hexValue) {
  float r = float((hexValue >> 16) & 0xFF) / 255.0;
  float g = float((hexValue >> 8) & 0xFF) / 255.0;
  float b = float(hexValue & 0xFF) / 255.0;
  return vec3(r, g, b);
}


vec3 addSunToSky(vec3 color, vec2 step) {
  vec3 colorRed = hexToRgb(0xdc5224); // the red of the setting sun
  float verticalFract = 0.9/step.y;
  verticalFract -= 0.2 / verticalFract;

  if (step.x < 0.7) {
    verticalFract -= (0.7 - step.x) * 1.8;
  }
  if (step.y < 0.4) {
    verticalFract -= verticalFract;
  }

  color = mix(
    color,
    colorRed,
    smoothstep(
      0.0,
      1.4,
      verticalFract
    )
  );

  return color;
}

vec3 addSunToWater(vec3 color, vec2 step) {
  vec3 colorRed = hexToRgb(0xdc5224); // the red of the setting sun
  float fract = 0.0;

  if (step.y < 0.4) {
    fract = smoothstep(0.1, 0.7, step.x - step.y / 3.0)
      - smoothstep(0.2, 1.7, step.x / 1.5 + step.y)
      - smoothstep(0.2, 1.5, 1.0 - step.y * 9.0);
  }

  color = mix(
    color,
    colorRed,
    smoothstep(
      0.0,
      1.4,
      fract
    )
  );
  return color;
}

vec3 addCloudsToSky(vec3 color, vec2 step) {
  vec3 cloudColor = hexToRgb(0xe2dec1); // the white of the cloud
  float fract = 0.0;

  if (step.y > 0.4) {
    fract = smoothstep(0.6, 1.0, step.y * 1.4)
      - smoothstep(0.0, 1.2, step.x)
      - smoothstep(0.8, 1.2, step.y - step.x * 1.5 + 0.2);
  }

  color = mix(
    color,
    cloudColor,
    smoothstep(
      0.0,
      1.4,
      fract
    )
  );
  return color;
}


void main() {
  vec2 step = gl_FragCoord.xy / uResolution.xy;

  vec3 skyBlueColor = hexToRgb(0x554c83);

  vec3 color = skyBlueColor;
  color = addSunToSky(color, step);
  color = addSunToWater(color, step);
  color = addCloudsToSky(color, step);

  fragColor = vec4(color, 1.0);
}
