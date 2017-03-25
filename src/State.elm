module State exposing (..)

import Array exposing (Array)
import Types exposing (..)
import Navigation
import Routing exposing (urlChange)
import Ships exposing (getBothBattlefields)
import Player.State
import Actions exposing (..)
import Set
import Task


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

        GameOver winner ->
            let
                _ = Debug.log "The winner is " winner
            in
                (model, Cmd.none)

        Attack cmdr (x, y) ->
            let
                (victim, attacker) =
                    case cmdr of
                        Me -> (model.yourState, model.myState)
                        Opponent -> (model.myState, model.yourState)

                updatedVictim =
                    victim.ships
                        |> List.concatMap .positions
                        |> List.filter (\( x1, y1 ) -> x == x1 && y == y1)
                        |> List.head
                        |> Maybe.map
                            (\hit -> { victim | hits = Set.insert hit victim.hits } )
                        |> Maybe.withDefault { victim | misses = Set.insert (x, y) victim.misses }

                updatedModel =
                    case cmdr of
                        Me -> {model | yourState = updatedVictim}
                        Opponent -> {model | myState = updatedVictim}
            in
                ( updatedModel
                , case Set.size updatedVictim.hits of
                    17 -> Task.perform GameOver (Task.succeed attacker.commander)
                    _ -> Cmd.none
                )
