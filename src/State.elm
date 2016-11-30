module State exposing (..)

import Array exposing (Array)
import Types exposing (..)
import Navigation
import Routing exposing (urlChange)
import Ships exposing (getBothBattlefields)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavigateTo path ->
            ( model, Navigation.newUrl path )

        UrlChange location ->
            urlChange location model

        PositionShips (cmdr, ships) ->
            case cmdr of
                Me ->
                    ( { model | myShips = ships }, Cmd.none )
                Opponent ->
                    ( { model | yourShips = ships }, Cmd.none )

        Shuffle ->
            ( model, getBothBattlefields )

        Attack (x, y) ->
            ( model, Cmd.none )
