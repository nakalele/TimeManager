import Vue from 'vue'
import App from './App.vue'
import Register from './components/Register.vue'
import Login from './components/Login.vue'
import User from './components/User.vue'
import VueRouter from 'vue-router'
import axios from 'axios'

Vue.use(axios)
Vue.use(VueRouter)
window.axios = require('axios');
const routes = [
  { path: '/register', component: Register },
  { path: '/login', component: Login },
  { path: '/user', component: User },
]

const router = new VueRouter({
  routes
})

new Vue({
  el: '#app',
  router,
  render: h => h(App)
})
