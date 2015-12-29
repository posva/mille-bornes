Vue = require 'vue'

if process.env isnt 'production'
  Vue.config.debug = true
new Vue
  el: 'body'
  components:
    app: require './app.vue'
