console.log('[STARTING SERVER]')
import express from 'express'
import webpack from 'webpack'
import history from 'connect-history-api-fallback'
import webpackMiddleware from 'webpack-dev-middleware'
import webpackHotMiddleware from 'webpack-hot-middleware'
import config from '../webpack.config.js'
import Game from './game'

const isDeveloping = process.env.NODE_ENV !== 'production'
const app = express()

if (isDeveloping) {
    const compiler = webpack(config)
    const middleware = webpackMiddleware(compiler, {
        publicPath: config.output.publicPath,
        contentBase: 'src',
        stats: {
            colors: true,
            hash: false,
            timings: true,
            chunks: false,
            chunkModules: false,
            modules: false
        }
    })

    app.use(history())
    app.use(middleware)
    app.use(webpackHotMiddleware(compiler))
}

import Http from 'http'

const http = (Http).Server(app)

Game.start(() => {
})

// Don't touch, IP configurations.
const ipaddress = process.env.OPENSHIFT_NODEJS_IP || process.env.IP || '127.0.0.1'
const serverport = process.env.OPENSHIFT_NODEJS_PORT || process.env.PORT || 3000
if (process.env.OPENSHIFT_NODEJS_IP !== undefined) {
    http.listen(serverport, ipaddress, () => {
        console.log(`[DEBUG] Listening on *:${serverport}`)
    })
} else {
    http.listen(serverport, () => {
        console.log(`[DEBUG] Listening on *:${3000}`)
    })
}
