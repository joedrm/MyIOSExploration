import React from 'react'; // 引入第三方模块
import ReactDOM from 'react-dom';
import App from './component/App'; // 引入自定义模块
import registerServiceWorker from './registerServiceWorker';
import './index.css'; // 引入样式模块

ReactDOM.render(<App />, document.getElementById('root'));
registerServiceWorker();
