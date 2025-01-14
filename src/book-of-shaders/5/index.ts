import vertexShaderSource from './shaders/vertex.glsl';
import fragmentShaderSource from './shaders/fragment-15.glsl';

const main = () => {
  const root = document.querySelector<HTMLDivElement>('#root')!;
  const content = `
    <div class="canvas-container">
      <canvas></canvas>
    </div>
  `;

  root.innerHTML = content;

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

  // Vertices to draw a quad
  const vertices = [
    -1.0, 1.0, // 1st - 0
    -1.0, -1.0, // 2nd - 1
    1.0, -1.0, // 3rd - 2
    1.0, 1.0 // 4th - 3
  ];
  const vertexIndices = [3, 2, 1, 3, 1, 0];

  draw({
    gl,
    canvas,
    program,
    vertices,
    vertexIndices
  });
};

const startTime = performance.now();

const draw = ({
  gl,
  canvas,
  program,
  vertices,
  vertexIndices
}: {
  gl: WebGL2RenderingContext;
  canvas: HTMLCanvasElement;
  program: WebGLProgram;
  vertices: number[];
  vertexIndices: number[];
}) => {
  gl.clearColor(0.0, 0.0, 0.0, 1.0); // black, fully opaque
  gl.clear(gl.COLOR_BUFFER_BIT);

  const canvasWidth = canvas.width;
  const canvasHeight = canvas.height;

  const timeElapsed = (performance.now() - startTime) / 1000.0;

  const uResolutionLocation = gl.getUniformLocation(program, 'uResolution');
  gl.uniform2f(uResolutionLocation, canvasWidth, canvasHeight);

  const uTimeLocation = gl.getUniformLocation(program, 'uTime');
  gl.uniform1f(uTimeLocation, timeElapsed);

  const vertexBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);

  const vertexIndexBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, vertexIndexBuffer);
  gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(vertexIndices), gl.STATIC_DRAW); // Q: there is an error if I use Uint8Array — why?

  const aVertexPosition = gl.getAttribLocation(program, 'aVertexPosition');
  gl.enableVertexAttribArray(aVertexPosition);
  gl.vertexAttribPointer(
    aVertexPosition,
    2,
    gl.FLOAT,
    false,
    0,
    0,
  );

  gl.drawElements(gl.TRIANGLES, vertexIndices.length, gl.UNSIGNED_SHORT, 0);

  requestAnimationFrame(() => {
    draw({
      gl,
      canvas,
      program,
      vertices,
      vertexIndices
    })
  });
};

main();
