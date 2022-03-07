import './style.css'

declare var URLPattern: any; // typescript doesn't yet know of URLPattern

const app = document.querySelector<HTMLDivElement>('#app')!;

const main = () => {
  const urlPattern = new URLPattern({
    pathname: '/:lesson',
  });
  const lesson = urlPattern.exec(window.location.href)?.pathname?.groups?.lesson;

  if (lesson) {
    import(`./lessons/${lesson}/index`).then(({ default: renderLesson }) => {
      renderLesson = renderLesson(app);
    })
  } else {
    app.innerHTML = renderIndex();
  }
};

const renderIndex = () => {
  return `
    <h1>Lessons</h1>
    <ul>
      <li>
        <a href="/1">Lesson 1</a>
      </li>
    </ul>
  `;  
};

main();
