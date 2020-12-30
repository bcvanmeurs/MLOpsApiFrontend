module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h1, input, label, option, select, text)
import Html.Attributes exposing (class, placeholder)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Encode as Encode



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
    , request : String
    , result : String
    , url : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { buying = "low"
      , maint = "low"
      , doors = "2"
      , persons = "2"
      , lug_boot = "small"
      , safety = "low"
      , request = ""
      , result = "Press button to send first API request"
      , url = "http://86357569-2159-41d2-9e7b-503afe9ed019.uksouth.azurecontainer.io/score"
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = URL String
    | Buying String
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
        URL url ->
            ( { model | url = url }, Cmd.none )

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
            ( { model | result = "waiting for response" }, getPrediction model )

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
    div [ class "container" ]
        [ h1 [ class "display-5 mt-4" ] [ text "Car acceptability inferencing" ]
        , div [ class "mt-4" ]
            [ label [ class "form-label" ] [ text "API endpoint" ]
            , input [ class "form-control", placeholder model.url, onInput URL ] []
            ]
        , div [ class "row gx-4 my-4" ]
            -- TODO make function
            [ div [ class "col" ]
                [ text "Buying price"
                , select [ class "form-select", onInput Buying ] (getOptions factors.buying)
                ]
            , div [ class "col" ]
                [ text "Maintenance price"
                , select [ class "form-select", onInput Maint ] (getOptions factors.maint)
                ]
            , div [ class "col" ]
                [ text "Number of doors"
                , select [ class "form-select", onInput Doors ] (getOptions factors.doors)
                ]
            , div [ class "col" ]
                [ text "Number of persons"
                , select [ class "form-select", onInput Persons ] (getOptions factors.persons)
                ]
            , div [ class "col" ]
                [ text "Luggage boot size"
                , select [ class "form-select", onInput Lug_boot ] (getOptions factors.lug_boot)
                ]
            , div [ class "col" ]
                [ text "Estimated safety"
                , select [ class "form-select", onInput Safety ] (getOptions factors.safety)
                ]
            ]
        , div [ class "mb-4" ]
            [ label [ class "form-label" ] [ text "Composed API request" ]
            , div [ class "alert alert-primary" ] [ text (Encode.encode 4 (postEncoder model)) ]
            ]
        , div [ class "mb-4" ] [ button [ class "btn btn-primary", onClick SendHttpRequest ] [ text "Send to API endpoint" ] ]
        , div [ class "mt-4" ]
            [ label [ class "form-label" ] [ text "API response" ]
            , div [ class "alert alert-primary" ] [ text model.result ]
            ]
        ]



-- HELPER FUNCTIONS


factors =
    -- TODO make dict
    { buying = [ "low", "med", "high", "vhigh" ]
    , maint = [ "low", "med", "high", "vhigh" ]
    , doors = [ "2", "3", "4", "5more" ]
    , persons = [ "2", "4", "more" ]
    , lug_boot = [ "small", "med", "big" ]
    , safety = [ "low", "med", "high" ]
    }


getOptions : List String -> List (Html msg)
getOptions list =
    List.map (\item -> option [] [ text item ]) list


getPrediction : Model -> Cmd Msg
getPrediction model =
    Http.post
        { url = "https://cors-anywhere.herokuapp.com/" ++ model.url
        , body = Http.jsonBody (postEncoder model)
        , expect = Http.expectString DataReceived
        }


postEncoder : Model -> Encode.Value
postEncoder model =
    let
        selectedList =
            [ model.buying, model.maint, model.doors, model.persons, model.lug_boot, model.safety ]
    in
    Encode.object [ ( "data", Encode.list identity [ Encode.list Encode.string selectedList ] ) ]
