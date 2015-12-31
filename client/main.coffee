Vue = require 'vue'

if process.env.NODE_ENV isnt 'production'
  Vue.config.debug = true
new Vue
  el: 'body'
  components:
    app: require './app.vue'
