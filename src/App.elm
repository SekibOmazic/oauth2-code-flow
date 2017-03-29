module App exposing (..)

import Html exposing (Html, text, div, img, a)
import Html.Attributes exposing (src, href)
import Ports exposing (..)
import Models exposing (..)
import Navigation exposing (Location)
import Http
import Auth exposing (parseUrlParams, exchangeCode)
import Dict


init : String -> Location -> ( Model, Cmd Msg )
init path location =
    let
        params =
            parseUrlParams location.search

        maybeCode =
            Dict.get "code" params

        maybeError =
            Dict.get "error" params

        initMsg =
            case maybeCode of
                Just code ->
                    "Got code, will excange it for an access token!"

                Nothing ->
                    case maybeError of
                        Just err ->
                            err

                        Nothing ->
                            "Please login"

        commands =
            initCmd maybeCode maybeError
    in
        { message = initMsg, logo = path, token = maybeCode, error = maybeError }
            ! commands


initCmd : Maybe String -> Maybe String -> List (Cmd Msg)
initCmd maybeCode maybeError =
    case maybeCode of
        Just code ->
            --  exchange code for token and cleanup url
            [ exchangeCode code, Navigation.modifyUrl "/" ]

        Nothing ->
            case maybeError of
                Just error ->
                    [ Cmd.none ]

                Nothing ->
                    [ check () ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CheckToken (Just token) ->
            ( { model | token = Just token, message = "You are logged in!" }, Cmd.none )

        CheckToken Nothing ->
            ( { model | message = "Please login" }, Cmd.none )

        UrlChange location ->
            ( model, Cmd.none )

        OAuthTokenMsg (Ok accessToken) ->
            ( { model
                | message = "You are logged in!"
                , token = Just accessToken.accessToken
                , error = Nothing
              }
            , saveToken accessToken.accessToken
            )

        OAuthTokenMsg (Err e) ->
            ( { model
                | message = "Couldn't exchange token"
                , token = Nothing
                , error = Just "Http Error"
              }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    div []
        [ img [ src model.logo ] []
        , div [] [ text model.message ]
        , showToken model
        ]


showToken : Model -> Html Msg
showToken model =
    case model.token of
        Just token ->
            div [] [ text ("Token:" ++ token) ]

        Nothing ->
            a [ href loginLink ] [ text "Login with GitHub" ]


loginLink : String
loginLink =
    config.url
        ++ "?response_type=token&immediate=true&approval_prompt=auto&client_id="
        ++ config.client
        ++ "&redirect_uri="
        ++ (Http.encodeUri config.redirect)


subscriptions : Model -> Sub Msg
subscriptions model =
    tokenChecked CheckToken
