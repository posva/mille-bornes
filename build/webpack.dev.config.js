var config = require('./webpack.base.config')

config.devtool = '#source-map'
config.output.filename = 'bundle.js'

module.exports = config
