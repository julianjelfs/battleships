module State exposing(..)

import Hop
import Types exposing (..)
import Debug exposing (log)
import Navigation
import Routing exposing (navigateTo, setQuery)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (log "msg: " msg) of
        NavigateTo path ->
            navigateTo model path

        SetQuery query ->
            setQuery model query

        None ->
            (model, Cmd.none)
