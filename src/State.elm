module State exposing (..)

import Array exposing (Array)
import Types exposing (..)
import Navigation
import Routing exposing (urlChange)
import Ships exposing (getBothBattlefields)
import Player.State


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavigateTo path ->
            ( model, Navigation.newUrl path )

        UrlChange location ->
            urlChange location model

        PlayerMsg sub ->
            ( { model | yourState = Player.State.update sub model.yourState
            , myState = Player.State.update sub model.myState }, Cmd.none )

        Shuffle ->
            ( model, getBothBattlefields )

        Attack (x, y) ->
            let
                --work out whether this coord is part of an opponent's ship
                match =
                    model.yourShips
                        |> List.filter (\( x1, y1, _ ) -> x == x1 && y == y1)
                        |> List.head
            in
                ( model, Cmd.none )
