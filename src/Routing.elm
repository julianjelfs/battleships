module Routing exposing (..)

import Navigation
import UrlParser

type Route
    = StartRoute
    | ShareRoute
    | SetUp
    | GameRoute

routes =
    UrlParser.oneOf
        [ UrlParser.map StartRoute (UrlParser.s "")
        , UrlParser.map SetUp (UrlParser.s "setup")
        , UrlParser.map ShareRoute (UrlParser.s "share")
        , UrlParser.map GameRoute (UrlParser.s "game")
        ]

