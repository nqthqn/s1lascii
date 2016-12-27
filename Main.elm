module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


{- TODO
   User can modify search terms for existing ASCII art
   User can delete ASCII art
   Persist ASCII Art data model to localStorage
-}


main :
    Program Never
        { arts : List ( String, List String )
        , filteredArts : List ( String, List String )
        , newArt : String
        , term : String
        }
        Msg
main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }


type alias Model =
    { arts : List ( String, List String )
    , term : String
    , filteredArts : List ( String, List String )
    , newArt : String
    }


model :
    { arts : List ( String, List String )
    , filteredArts : List a
    , newArt : String
    , term : String
    }
model =
    { arts =
        [ ( "¯\\_(ツ)_/¯", [ "shrug", "huh" ] )
        , ( "|_|>", [ "coffee", "late" ] )
        , ( "༼ つ ◕_◕ ༽つ", [ "gimme", "want", "desire" ] )
        , ( "ヽ(￣(ｴ)￣)ﾉ", [ "panda" ] )
        , ( "٩(- ̮̮̃-̃)۶", [ "monster" ] )
        , ( "♫♪.ılılıll|̲̅̅●̲̅̅|̲̅̅=̲̅̅|̲̅̅●̲̅̅|llılılı.♫♪", [ "boom", "box" ] )
        , ( " c[○┬●]כ ", [ "robot" ] )
        , ( "|[●▪▪●]|", [ "casette" ] )
        , ( "ε(´סּ︵סּ`)з", [ "sad" ] )
        ]
    , term = ""
    , filteredArts = []
    , newArt = ""
    }


view : Model -> Html Msg
view model =
    let
        item ( ascii, terms ) =
            li [ style [ ( "margin", "1em" ) ] ]
                [ code [ style [ ( "background", "lightgreen" ), ( "padding", ".5em" ) ] ]
                    [ text ascii ]
                , em [] [ text (toString terms) ]
                ]

        newArts =
            if model.term == "" then
                -- if no search term has been entered, display all art
                model.arts
            else
                -- Only show art whoes terms contain the searchterm
                List.filter (\( _, terms ) -> List.member model.term terms) model.arts
    in
        div [ style [ ( "font-family", "sans-serif" ), ( "font-size", "1em" ) ] ]
            [ h1 [] [ text "Search and save 1-line ASCII Art" ]
            , hr [] []
            , input [ placeholder "Search for art", onInput Search ] []
            , br [] []
            , input [ placeholder "Add new art", onInput AddArt ] []
            , button [ onClick SaveIt ] [ text "Add it!" ]
            , ul [] (List.map item newArts)
            ]


type Msg
    = Search String
    | AddArt String
    | SaveIt


update : Msg -> Model -> Model
update msg model =
    case msg of
        Search term ->
            { model | term = term }

        AddArt a ->
            { model | newArt = a }

        SaveIt ->
            { model | arts = model.arts ++ [ ( model.newArt, String.split "," model.term ) ], term = "", newArt = "" }
