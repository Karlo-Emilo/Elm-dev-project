port module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Json.Encode as E
import Json.Decode as D

-- MAIN
main : Program () Model Msg
main =
  Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }

type alias Model = {
    number: Int,
    features: List (List Int),
    labels: List Int
    }


init : () -> ( Model, Cmd Msg )
init () =
    ( Model 
        0 
        [
            [0, 1, 2],
            [1, 1, 1],
            [2, 2, 2],
            [3, 3, 3]
        ]
        [1, 1, 2, 2]
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    untruthPort Untruth


--UPDATE

type Msg 
    = Increment 
    | Decrement
    | SendData (List (List Int)) (List Int)
    | Untruth E.Value

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Increment ->
        ( { model | number = model.number + 1 }
        , Cmd.none )

    Decrement ->
        ( { model | number = model.number - 2 }
        , Cmd.none )

    SendData features labels ->
        ( model
        , dataOutputPort (E.object [ ("features", E.list E.list E.int features ), ( "labels",  E.list labels)] ) )

    Untruth value ->
        ( { model | number = untruthDecoder value model }
        , Cmd.none )

untruthDecoder : E.Value -> Model -> Int
untruthDecoder value model =
    case D.decodeValue D.int value of
        Ok v ->
            v
        Err err ->
            model.number

convertDataToJSON: (List (List Int)) -> (List Int) -> E.Value
convertDataToJSON features labels =
    let
        jSONFeatureRows = List.map (E.list E.int) features
        jSONFeatures = E.list E.List jSONFeatureRows
        jSONLabels = E.list E.int labels
    in
        E.object [
            ( "features", jSONFeatures ),
            ( "labels", jSONLabels)
        ]

-- PORTS

port dataOutputPort : E.Value -> Cmd msg

port untruthPort : (E.Value -> msg) -> Sub msg

--VIEW

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "--" ]
    , div [] [ text (String.fromInt model.number) ]
    , button [ onClick Increment ] [ text "+" ]
    , div [] [ button [ onClick (SendData model.features model.labels) ] [ text "Call JS"] ]
    ]