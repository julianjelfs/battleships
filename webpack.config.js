'use strict';

var path = require('path');
var webpack = require('webpack');
var HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
    port: 3000,
    devtool: 'eval-source-map',
    entry: [
        'webpack-hot-middleware/client?reload=true',
    path.join(__dirname, 'app/js/main.js')
        ],
    output: {
        path: path.join(__dirname, '/dist/'),
        filename: '[name].js',
        publicPath: '/'
    },
    plugins: [
        new HtmlWebpackPlugin({
            template: 'app/index.tpl.html',
        inject: 'body',
        filename: 'index.html'
        }),
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin(),
    new webpack.DefinePlugin({
        'process.env.NODE_ENV': JSON.stringify('development')
    })
    ],
    module: {
        loaders: [{
            test:    /\.elm$/,
            exclude: [/elm-stuff/, /node_modules/],
            loader:  'elm-webpack',
        }, {
            test: /\.js?$/,
            exclude: /node_modules/,
            loader: 'babel'
        }, {
            test: /\.json?$/,
            loader: 'json'
        }, {
            test: /\.scss$/,
            loader: 'style!css!sass'
        }, {
            test: /\.(jpe?g|png|mp3)$/,
            loader: 'file?name=[path][name].[ext]'
        }],
        noParse: [/.elm$/]
    }
};
