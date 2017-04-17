module State exposing (..)

import Array exposing (Array)
import Types exposing (..)
import Navigation
import Routing exposing (urlChange)
import Ships exposing (getBothBattlefields, getRandomShips)
import Player.State
import Actions exposing (..)
import Set
import Task
import Time
import Random exposing (Generator)
import Dict
import Ports exposing (requestMove, startTraining)

surroundingCells (x, y) =
    [ (x, y-1)
    , (x-1, y)
    , (x+1, y)
    , (x, y+1)
    ]

nextToAHit hits p =
    surroundingCells p
        |> List.any (\p -> Set.member p hits)

scorePoint state p =
    case nextToAHit state.hits p of
        True -> (1, p)
        False -> (0, p)

optimalCoordinate handler victimState =
    let
        rng =
            List.range 1 10

        allPoints =
            List.concatMap (\x -> List.map (\y -> (x, y)) rng) rng
                |> Set.fromList

        (good, bad) =
            Set.union victimState.hits victimState.misses
                |> (Set.diff allPoints)
                |> Set.toList
                |> List.partition (nextToAHit (Debug.log "Hits" victimState.hits))

        available =
            (case List.isEmpty (Debug.log "Good" good) of
                False -> good
                True -> bad)
                |> Array.fromList

        size =
            Array.length available
    in
         Time.now
            |> Task.map
                (\t ->
                    let
                        index =
                            (round t)
                                |> Random.initialSeed
                                |> Random.step (Random.int 0 (size - 1))
                                |> Tuple.first
                    in
                        Array.get index available
                            |> Maybe.withDefault (0,0)
                )
            |> Task.perform handler


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavigateTo path ->
            ( model, Navigation.newUrl path )

        UrlChange location ->
            urlChange location model

        PlayerMsg sub ->
            let
                trainingState = Player.State.update sub model.trainingState
            in
                ( { model | yourState = Player.State.update sub model.yourState
                , myState = Player.State.update sub model.myState
                , trainingState = trainingState }
                , case model.gameState of
                    InitialisingTraining ->
                        Cmd.batch
                            [ Task.perform (\_ -> StartTraining) (Task.succeed ())
                            , startTraining ()
                            ]
                    _ -> Cmd.none
                )

        Shuffle ->
            ( model, getBothBattlefields )

        StartGame ->
            ( { model | gameState = Playing Me }, Navigation.newUrl "game" )

        InitialiseTraining () ->
            ( { model | gameState = InitialisingTraining
            , trainingState = (PlayerState [] Set.empty Set.empty Trainee)}
            , Cmd.map PlayerMsg (getRandomShips Trainee 0)
            )

        StartTraining ->
            ( {model | gameState = Training }
            , requestMove (toTrainingState model.trainingState)
            )

        StopTraining  ->
            ( { model | gameState = NotStarted }
            , Cmd.none
            )

        GameOver winner ->
            ({ model | gameState = Finished winner }, Cmd.none)

        Think _ ->
            let
                thinking = model.thinking - 1

                fx =
                    case thinking of
                        0 ->
                            case model.gameState of
                                Playing Opponent ->
                                    optimalCoordinate (Attack Opponent) model.myState
                                _ -> Cmd.none
                        _ -> Cmd.none
            in
                ( { model | thinking =  thinking }
                , fx )

        Attack cmdr (x, y) ->
            let
                _ = Debug.log "Attack!" (x, y)

                (victim, attacker) =
                    case cmdr of
                        Me -> (model.yourState, model.myState)
                        Opponent -> (model.myState, model.yourState)
                        _ -> (model.trainingState, model.trainingState)

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
                        _ -> {model | trainingState = updatedVictim }

                gameState =
                    case model.gameState of
                        Training -> Training
                        _ -> Playing <| otherPlayer cmdr
            in
                ( { updatedModel | gameState = gameState, thinking = 1}
                , case Set.size updatedVictim.hits of
                    17 ->
                        case model.gameState of
                            Training ->
                                Task.perform InitialiseTraining (Task.succeed ())
                            _ ->
                                Task.perform GameOver (Task.succeed attacker.commander)
                    _ ->
                        case model.gameState of
                            Training ->
                                requestMove (toTrainingState updatedModel.trainingState)
                            _ -> Cmd.none
                )


otherPlayer cmdr =
    case cmdr of
        Me -> Opponent
        Opponent -> Me
        Trainee -> Trainee
