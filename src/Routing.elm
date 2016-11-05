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
            -- First generate the URL using your config (`outputFromPath`).
            -- Then generate a command using Navigation.newUrl.
            Hop.outputFromPath hopConfig path
                |> Navigation.newUrl
    in
        ( model, command )

setQuery: Model -> Query -> (Model, Cmd Msg)
setQuery model query =
    let
        command =
            -- First modify the current stored address record (setting the query)
            -- Then generate a URL using Hop.output
            -- Finally, create a command using Navigation.newUrl
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
        , UrlParser.format ShareRoute (UrlParser.s "share")
        , UrlParser.format GameRoute (UrlParser.s "game")
        ]


urlParser : Navigation.Parser ( Route, Address )
urlParser =
    let
        -- A parse function takes the normalised path from Hop after taking
        -- in consideration the basePath and the hash.
        -- This function then returns a result.
        parse path =
            -- First we parse using UrlParser.parse.
            -- Then we return the parsed route or NotFoundRoute if the parsed failed.
            -- You can choose to return the parse return directly.
            path
                |> UrlParser.parse identity routes
                |> Result.withDefault NotFoundRoute

        resolver =
            -- Create a function that parses and formats the URL
            -- This function takes 2 arguments: The Hop Config and the parse function.
            Hop.makeResolver hopConfig parse
    in
        -- Create a Navigation URL parser
        Navigation.makeParser (.href >> resolver)


urlUpdate : ( Route, Address ) -> Model -> ( Model, Cmd Msg )
urlUpdate ( route, address ) model =
    ( { model | route = route, address = address }, Cmd.none )

