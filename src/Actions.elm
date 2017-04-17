module Actions exposing (..)

import Navigation
import Player.Actions as Player
import Time exposing (Time)
import Types exposing (..)

type Msg
    = UrlChange Navigation.Location
    | NavigateTo String
    | Shuffle
    | Attack Commander (Int, Int)
    | PlayerMsg Player.Msg
    | GameOver Commander
    | StartGame
    | Think Time
    | StartTraining
    | InitialiseTraining ()
    | StopTraining
