module Main exposing (..)

import Browser
import Debug exposing (log)
import Html exposing (Html, button, div, option, select, text)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Encode exposing (encode, string)



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { buying : String
    , doors : String
    , lug_boot : String
    , maint : String
    , persons : String
    , safety : String
    , result : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { buying = "low"
      , maint = "low"
      , doors = "2"
      , persons = "2"
      , lug_boot = "small"
      , safety = "low"
      , result = "res"
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Buying String
    | Maint String
    | Doors String
    | Persons String
    | Lug_boot String
    | Safety String
    | SendHttpRequest
    | DataReceived (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Buying selected ->
            ( { model | buying = selected }, Cmd.none )

        Maint selected ->
            ( { model | maint = selected }, Cmd.none )

        Doors selected ->
            ( { model | doors = selected }, Cmd.none )

        Persons selected ->
            ( { model | persons = selected }, Cmd.none )

        Lug_boot selected ->
            ( { model | lug_boot = selected }, Cmd.none )

        Safety selected ->
            ( { model | safety = selected }, Cmd.none )

        SendHttpRequest ->
            ( model, getPrediction )

        DataReceived result ->
            case result of
                Ok response ->
                    ( { model | result = response }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ div []
                [ text model.buying
                , select [ onInput Buying ] (getOptions factors.buying)
                ]
            , div []
                [ text model.maint
                , select [ onInput Maint ] (getOptions factors.maint)
                ]
            , div []
                [ text model.doors
                , select [ onInput Doors ] (getOptions factors.doors)
                ]
            , div []
                [ text model.persons
                , select [ onInput Persons ] (getOptions factors.persons)
                ]
            , div []
                [ text model.lug_boot
                , select [ onInput Lug_boot ] (getOptions factors.lug_boot)
                ]
            , div []
                [ text model.safety
                , select [ onInput Safety ] (getOptions factors.safety)
                ]
            ]
        , div [] [ button [ onClick SendHttpRequest ] [ text "test" ] ]
        , div [] [ text model.result ]
        ]



-- HELPER FUNCTIONS


factors =
    { buying = [ "low", "med", "high", "vhigh" ]
    , maint = [ "low", "med", "high", "vhigh" ]
    , doors = [ "2", "3", "4", "5more" ]
    , persons = [ "2", "4", "5more" ]
    , lug_boot = [ "small", "med", "big" ]
    , safety = [ "low", "med", "high" ]
    }


getOptions : List String -> List (Html msg)
getOptions list =
    List.map (\item -> option [] [ text item ]) list


url : String
url =
    "https://cors-anywhere.herokuapp.com/http://86357569-2159-41d2-9e7b-503afe9ed019.uksouth.azurecontainer.io/score"



--    "http://86357569-2159-41d2-9e7b-503afe9ed019.uksouth.azurecontainer.io/score"
--    "https://jsonplaceholder.typicode.com/posts/1"


getPrediction : Cmd Msg
getPrediction =
    Http.post
        { url = url
        , body = Http.stringBody "application/json" "{\"data\": [[\"low\", \"low\", \"3\", \"more\", \"big\", \"high\"]] }"
        , expect = Http.expectString DataReceived
        }



--{'data': [['low', 'high', '3', '5more', 'big', 'low']] }
