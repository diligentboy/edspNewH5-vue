import { createApp } from 'vue';
import App from './App.vue';
import { NavBar, Area, Popup, Picker } from 'vant';

const app = createApp(App);

// 注册 Vant 组件
app.use(NavBar);
app.use(Area);
app.use(Popup);
app.use(Picker);

app.mount('#app');