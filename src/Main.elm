module Main exposing (..)

import App exposing (..)
import Models exposing (Model, Msg(..))
import Navigation


main : Program String Model Msg
main =
    Navigation.programWithFlags UrlChange
        { view = view, init = init, update = update, subscriptions = subscriptions }
