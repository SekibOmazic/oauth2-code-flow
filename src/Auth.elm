module Auth exposing (parseUrlParams, exchangeCode)

import Dict
import Http
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Models exposing (AccessToken, Token, Msg(..))


dummy : String -> Http.Request AccessToken
dummy code =
    Http.get ("/authenticate/" ++ code) accessTokenDecoder


exchangeCode : String -> Cmd Msg
exchangeCode code =
    let
        x =
            Debug.log "CODE TO EXCHANGE" code
    in
        Http.get ("/authenticate/" ++ code) accessTokenDecoder
            |> Http.send OAuthTokenMsg


parseUrlParams : String -> Dict.Dict String String
parseUrlParams s =
    s
        |> String.dropLeft 1
        |> String.split "&"
        |> List.map parseSingleParam
        |> Dict.fromList



{- Helpers -}


accessTokenDecoder : Decoder AccessToken
accessTokenDecoder =
    decode AccessToken
        |> required "access_token" string
        |> required "token_type" string
        |> optional "expires_in" (nullable int) Nothing


parseSingleParam : String -> ( String, String )
parseSingleParam p =
    let
        s =
            String.split "=" p
    in
        case s of
            [ key, val ] ->
                ( key, val )

            _ ->
                ( "", "" )
