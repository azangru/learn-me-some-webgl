import vertexShaderSource from './shaders/vertex.glsl';
import fragmentShaderSource from './shaders/fragment.glsl';

const main = (container: HTMLDivElement) => {
  const content = `
    <h1>Lesson 1!</h1>
    <div class="canvas-container">
      <canvas></canvas>
    </div>
  `;

  container.innerHTML = content;

  init();
};


const init = () => {
  const canvas = document.querySelector('canvas')!;
  setCanvasSize(canvas);
  runProgram(canvas);
};

const setCanvasSize = (canvas: HTMLCanvasElement) => {
  const { width, height } = canvas.getBoundingClientRect();
  canvas.width = Math.round(window.devicePixelRatio * width);
  canvas.height = Math.round(window.devicePixelRatio * height);
};

const runProgram = (canvas: HTMLCanvasElement) => {
  const gl = canvas.getContext('webgl2')!;

  const program = gl.createProgram()!;

  const vertexShader = gl.createShader(gl.VERTEX_SHADER)!;
  gl.shaderSource(vertexShader, vertexShaderSource);
  gl.compileShader(vertexShader);
  gl.attachShader(program, vertexShader);

  const fragmentShader = gl.createShader(gl.FRAGMENT_SHADER)!;
  gl.shaderSource(fragmentShader, fragmentShaderSource);
  gl.compileShader(fragmentShader);
  gl.attachShader(program, fragmentShader);

  gl.linkProgram(program);

  if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
    console.log('vertex shader complaints:', gl.getShaderInfoLog(vertexShader));
    console.log('fragment shader complaints:', gl.getShaderInfoLog(fragmentShader));
  }

  gl.useProgram(program);

  gl.drawArrays(gl.POINTS, 0, 1);
};

export default main;
