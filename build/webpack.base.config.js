var path = require('path')

module.exports = {
  entry: './client/main.coffee',
  output: {
    path: './public',
    publicPath: 'public/',
    filename: 'bundle.js',
  },
  module: {
    loaders: [{
      test: /\.coffee$/,
      include: [
        path.resolve(__dirname, '../client')
      ],
      loader: 'coffee'
    }, {
      test: /\.vue$/,
      loader: 'vue'
    }]
  },
  resolve: {
    extensions: ['', '.js', '.coffee']
  },
}
