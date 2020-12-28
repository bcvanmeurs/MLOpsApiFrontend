module Main exposing (..)

import Browser
import Html exposing (Html, button, div, option, select, text)
import Html.Events exposing (onClick, onInput)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { content : String
    }


init : Model
init =
    { content = Maybe.withDefault "no data found" (List.head options) }



-- UPDATE


type Msg
    = Test String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Test selected ->
            { model | content = selected }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ select [ onInput Test ]
            (getOptions options)
        , div [] [ text model.content ]
        ]


options =
    [ "unacceptable", "acceptable", "good", "very good" ]


getOptions : List String -> List (Html msg)
getOptions list =
    List.map (\item -> option [] [ text item ]) list
