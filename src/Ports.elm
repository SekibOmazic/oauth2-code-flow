port module Ports exposing (..)

{-| interface to Elm <--> Javascript
-}


{-| check if there is a token in the local storage
-}
port check : () -> Cmd msg


{-| send a token (or Nothing) to Elm app
-}
port tokenChecked : (Maybe String -> msg) -> Sub msg


{-| save token in the local storage after successful login
-}
port saveToken : String -> Cmd msg
