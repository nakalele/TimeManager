<template>
  <div id="app">
    <b-navbar toggleable="sm" type="light" variant="light">
        <b-navbar-toggle target="nav-text-collapse"></b-navbar-toggle>
        <b-navbar-brand class="tm-title">Time Manager</b-navbar-brand>
        <b-collapse id="nav-text-collapse" is-nav>
          <b-navbar-nav class="ml-auto">
            <b-nav-item class="app-button" to="/register">Sign Up</b-nav-item>
            <b-nav-item class="app-button" to="/login">Sign In</b-nav-item>
          </b-navbar-nav>
        </b-collapse>
      </b-navbar>
    <div class="container">
      
        <!-- <h2>
          <router-link to="/user">User</router-link>
          <router-link to="/workingtimes">WorkingTimes</router-link>
          <router-link to="/workingtime">WorkingTime</router-link>
          <router-link to="/clockmanager">ClockManager</router-link>
          <router-link to="/chartmanager">ChartManager</router-link>
        </h2> -->
        <router-view></router-view>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import BootstrapVue from 'bootstrap-vue';
import 'bootstrap/dist/css/bootstrap.css';
import 'bootstrap-vue/dist/bootstrap-vue.css';

Vue.use(BootstrapVue)

export default {
  name: 'app',
}
</script>

<style>

.app-button {
  font-size: 2rem !important;
}

.tm-title {
  font-size: 2.5rem !important;
}

</style>
