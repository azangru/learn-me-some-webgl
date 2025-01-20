From: Chapter 5, Algorithmic drawing, of The Book of Shaders

Purpose of the exercise:
Adapt (mostly through copy/pasting) the [graph plotter shader](https://github.com/patriciogonzalezvivo/thebookofshaders/blob/master/src/main.js) from The Book of Shaders, such that the behavior of mathematical functions can be more easily examined.


Note:

From Copilot: a simple fragment shader that draws a white sine wave against a black background:

```glsl
void main() {
  vec2 step = gl_FragCoord.xy / uResolution.xy; // normalize coordinates between (0,0) and (1,1)
  step.x *= uResolution.x / uResolution.y; // adjust the x coordinate to maintain the correct aspect ratio
  float x = step.x * 2.0 - 1.0; // Map x from 0-1 to -1 to 1
  float y = sin(x * 3.14159265); // Calculate sine wave
  
  fragColor = vec4(step.x, step.y, 0.5, 1.0);

  // If the y value of the coordinate is close to the sine of x, set the color to white
  if (abs(step.y * 2.0 - 1.0 - y) < 0.05) {
    fragColor = vec4(1.0, 1.0, 1.0, 1.0); // White color
  } else {
    fragColor = vec4(0.0, 0.0, 0.0, 1.0); // Black color
  }
}
```
