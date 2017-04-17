port module Ports exposing (..)

import Types exposing (TrainingState)

port requestMove : TrainingState -> Cmd msg

port startTraining : () -> Cmd msg

port receiveMove : ((Int, Int) -> msg) -> Sub msg

port requestInitialState : (() -> msg) -> Sub msg

port sendInitialState : (List (Int, Int)) -> Cmd msg
