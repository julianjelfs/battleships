module State exposing (..)

import Array exposing (Array)
import Types exposing (..)
import Navigation
import Routing exposing (urlChange)
import Ships exposing (getRandomShips)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavigateTo path ->
            ( model, Navigation.newUrl path )

        UrlChange location ->
            urlChange location model

        PositionShips ships ->
            ( { model | myShips = ships }, Cmd.none )

        Shuffle ->
            ( model, getRandomShips )
