module Models exposing (..)

import Navigation exposing (Location)
import Http


type alias Token =
    String


type alias Model =
    { message : String
    , logo :
        String
        --    , code : Maybe String
    , token : Maybe Token
    , error : Maybe String
    }


type alias AccessToken =
    { accessToken : String
    , tokenType : String
    , expiresIn : Maybe Int
    }


type Msg
    = CheckToken (Maybe Token)
    | OAuthTokenMsg (Result Http.Error AccessToken)
    | UrlChange Location


type alias OAuthConfig =
    { client : String
    , url : String
    , redirect : String
    , scope : List String
    }


config : OAuthConfig
config =
    { client = "a016751aae82c417a07d"
    , url = "https://github.com/login/oauth/authorize"
    , redirect = "http://localhost:8000"
    , scope = [ "user" ]
    }


authorizeUrl : OAuthConfig -> String
authorizeUrl config =
    config.url
        ++ "?response_type=code&immediate=true&approval_prompt=auto"
        ++ "&client_id="
        ++ config.client
        ++ "&redirect_uri="
        ++ (Http.encodeUri config.redirect)
        ++ "&scope="
        ++ (String.join " " config.scope)
