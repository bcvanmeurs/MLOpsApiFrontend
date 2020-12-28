module Main exposing (..)

import Browser
import Html exposing (Html, button, div, option, select, text)
import Html.Events exposing (onClick, onInput)



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { buying : String
    , doors : String
    , lug_boot : String
    , maint : String
    , persons : String
    , safety : String
    }


init : Model
init =
    { buying = "low"
    , maint = "low"
    , doors = "2"
    , persons = "2"
    , lug_boot = "small"
    , safety = "low"
    }



-- UPDATE


type Msg
    = Buying String
    | Maint String
    | Doors String
    | Persons String
    | Lug_boot String
    | Safety String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Buying selected ->
            { model | buying = selected }

        Maint selected ->
            { model | maint = selected }

        Doors selected ->
            { model | doors = selected }

        Persons selected ->
            { model | persons = selected }

        Lug_boot selected ->
            { model | lug_boot = selected }

        Safety selected ->
            { model | safety = selected }



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
        ]


factors =
    { buying = [ "low", "med", "high", "vhigh" ]
    , maint = [ "low", "med", "high", "vhigh" ]
    , doors = [ "2", "3", "4", "5more" ]
    , persons = [ "2", "4", "5more" ]
    , lug_boot = [ "small", "med", "big" ]
    , safety = [ "low", "med", "high" ]
    }



-- generateSelect : String -> List String -> Html Msg
-- generateSelect string list =
--     select [ onInput Test ] (getOptions factors.buying)


getOptions : List String -> List (Html msg)
getOptions list =
    List.map (\item -> option [] [ text item ]) list
