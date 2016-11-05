module Routing exposing (..)

import Hop
import Hop.Types exposing (Address, Query)
import Navigation
import Types exposing (..)
import UrlParser

navigateTo: Model -> String -> (Model, Cmd Msg)
navigateTo model path =
    let
        command =
            Hop.outputFromPath hopConfig path
                |> Navigation.newUrl
    in
        ( model, command )

setQuery: Model -> Query -> (Model, Cmd Msg)
setQuery model query =
    let
        command =
            model.address
                |> Hop.setQuery query
                |> Hop.output hopConfig
                |> Navigation.newUrl
    in
        ( model, command )

routes : UrlParser.Parser (Route -> a) a
routes =
    UrlParser.oneOf
        [ UrlParser.format StartRoute (UrlParser.s "")
        , UrlParser.format SetUp (UrlParser.s "setup")
        , UrlParser.format ShareRoute (UrlParser.s "share")
        , UrlParser.format GameRoute (UrlParser.s "game")
        ]


urlParser : Navigation.Parser ( Route, Address )
urlParser =
    let
        parse path =
            path
                |> UrlParser.parse identity routes
                |> Result.withDefault NotFoundRoute

        resolver =
            Hop.makeResolver hopConfig parse
    in
        Navigation.makeParser (.href >> resolver)


urlUpdate : ( Route, Address ) -> Model -> ( Model, Cmd Msg )
urlUpdate ( route, address ) model =
    ( { model | route = route, address = address }, Cmd.none )

