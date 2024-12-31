#version 300 es

precision mediump float;

uniform vec2 uResolution;

out vec4 fragColor;

/**
  Plot a line where y equals to x.
  The return value from the plot function will be between 0.0
  where the difference between position y and position x is greater than 0.02,
  and 1.0 where the y and the x coordinates are the same.
*/
float plot(vec2 position) {    
  return smoothstep(0.02, 0.0, abs(position.y - position.x));
}

void main() {
  // create a normalized, aspect-corrected coordinate system
  vec2 st = gl_FragCoord.xy / uResolution.xy; // normalize coordinates between (0,0) and (1,1)
  // st.x *= uResolution.x/uResolution.y; // adjust the x coordinate to maintain the correct aspect ratio

  vec3 color = vec3(st.x);

  float proximity = plot(st);

  /**
    If a fragment is close to the point where fragment's x and y coordinates are the same,
    the proximity value will be close to 1; and thus the fragment will be colored in green.
    Else, the proximity value will be close to 0, and thus the fragment will be colored
    with the value of color (greyscale, between 0 and 1) 
  */
  color = (1.0 - proximity) * color + proximity * vec3(0.0, 1.0, 0.0);

  fragColor = vec4(color, 1.0);
}
