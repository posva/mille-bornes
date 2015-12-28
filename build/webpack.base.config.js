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
  // vue-loader config:
  // lint all JavaScript inside *.vue files with ESLint
  // make sure to adjust your .eslintrc
  resolve: {
    extensions: ['', '.js', '.coffee']
  },
  vue: {
    preLoaders: {
      coffee: 'coffeelint'
    }
  },
  coffeelint: {
    emitErrors: true,
    failOnErrors: true
  },
}
