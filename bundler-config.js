const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')

const devConf = {
  entry: [
    'webpack-dev-server/client?http://localhost:8000',
    path.join(__dirname, 'index.js')
  ],
  output: {
    path: path.join(__dirname, 'build'),
    filename: 'app.js',
    publicPath: '/'
  },
  resolve: {
    extensions: ['.js', '.elm']
  },
  module: {
    noParse: [/.elm$/],
    rules: [
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader']
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: ['elm-hot-loader', 'elm-webpack-loader']
      },
      {
        exclude: [/\.html$/, /\.(js|jsx)$/, /\.css$/, /\.svg$/],
        use: [{loader: 'url-loader', options: {limit: 10000}}]
      }
    ]
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: './index.html',
      inject: true
    })
  ],
  devServer: {
    headers: { "Access-Control-Allow-Origin": "*" },
    proxy: {
      '/authenticate/': {
        target: 'http://localhost:9999',
        secure: false
      }
    },
    port: 8000,
    open: true,
    contentBase: './build'
  }
}

const prodConf = {
  entry: path.join(__dirname, 'index.js'),
  output: {
    path: path.join(__dirname, 'build'),
    filename: '[name].[hash].js',
    publicPath: '/'
  },
  resolve: {
    extensions: ['.js', '.elm']
  },
  module: {
    noParse: [/.elm$/],
    rules: [
      {
        test: /\.js$/,
        use: ['babel-loader']
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader']
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: ['elm-webpack-loader']
      },
      {
        exclude: [/\.html$/, /\.(js|jsx)$/, /\.css$/, /\.svg$/],
        use: [{loader: 'url-loader', options: {limit: 10000}}]
      }
    ]
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: './index.html',
      inject: true,
      minify: {
        removeComments: true,
        collapseWhitespace: true,
        removeRedundantAttributes: true,
        useShortDoctype: true,
        removeEmptyAttributes: true,
        removeStyleLinkTypeAttributes: true,
        keepClosingSlash: true,
        minifyJS: true,
        minifyCSS: true,
        minifyURLs: true
      }
    })
  ]
}

module.exports = process.env.NODE_ENV === 'production' ? prodConf : devConf
