import Vue from 'vue'
import App from './App.vue'
import Register from './components/Register.vue'
import Login from './components/Login.vue'
import User from './components/User.vue'
import WorkingTimes from './components/WorkingTimes.vue'
import WorkingTime from './components/WorkingTime.vue'
import ClockManager from './components/ClockManager.vue'
import ChartManager from './components/ChartManager.vue'
import VueRouter from 'vue-router'
import axios from 'axios'

Vue.use(axios)
Vue.use(VueRouter)
window.axios = require('axios');
const routes = [
  { path: '/register', component: Register },
  { path: '/login', component: Login },
  { path: '/user', component: User },
  { path: '/workingtimes', component: WorkingTimes },
  { path: '/workingtime', component: WorkingTime },
  { path: '/clockmanager', component: ClockManager },
  { path: '/chartmanager', component: ChartManager },
]

const router = new VueRouter({
  routes
})

new Vue({
  el: '#app',
  router,
  render: h => h(App)
})
