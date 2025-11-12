module Main exposing (..)


import Array exposing (Array)
import Browser
import File exposing (File)
import File.Select as Select
import File.Download as Download
import Task
import Json.Decode as D
import Json.Encode as E
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Graph exposing (Graph)
import Http


import PureScript.TypeClass as PS exposing (TypeClass)
import PureScript.Graph as PS
import PureScript.Decode as PS
import PureScript.Render as PS
import PureScript.State as PS

-- MAIN

type Selected
  = Selected
  | NotSelected


type Data
    = PurescriptClasses PS.State (Graph ( Selected, TypeClass ) PS.Extends)


type alias Model =
    { data : Maybe Data
    , error : Maybe String
    }


main : Program () Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


metaContent = "application/json"


serverUrl = "https://shamansir.github.io/purs-typeclasses/gen/"


type alias Convert a =
    { decode : D.Decoder a
    , encode : a -> E.Value
    , toGraph : Array a -> Graph a ()
    }


init : () -> ( Model, Cmd Msg )
init _ =
  (
    { data = Nothing
    , error = Nothing
    }
  , Cmd.batch
    [ tryLoadingLocalJson
        "purs-typeclasses.json"
        (PS.decodeMany |> D.map PS.toGraph)
        (Graph.mapNodes (Tuple.pair NotSelected)
            >> PurescriptClasses PS.init
        )
    ]
  )


tryLoadingLocalJson : String -> D.Decoder a -> (a -> Data) -> Cmd Msg
tryLoadingLocalJson path decoder toData =
  Http.get
    { url = serverUrl ++ path
    , expect =
        Http.expectJson
          (\result ->
              case result of
                Err err -> JsonFailedToLoad <| errorToString err
                Ok items -> JsonLoaded <| toData items
          )
          decoder
    }


-- UPDATE


type Msg
--   = JsonRequested
--   | JsonSelected File
  = JsonLoaded Data
--   | JsonDownload
  | JsonFailedToLoad String
  -- | ToggleSelect Int Int
  | ToPS PS.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of

    JsonLoaded data ->
      (
          { model
          | data = Just data
          , error = Nothing
          }
      , Cmd.none
      )

    JsonFailedToLoad err ->
      (
          { model
          | error = Just err
          }
      , Cmd.none
      )

    ToPS psMsg ->
      (
          { model
          | data =
              model.data
                |> Maybe.map (\data ->
                    case data of
                      PurescriptClasses state graph ->
                        PurescriptClasses (PS.update psMsg state) graph
                )
          }
      , Cmd.none
      )

    -- ToggleSelect index toToggle ->
    --   (
    --     { model
    --     | data =
    --         model.data
    --         |> Array.indexedMap
    --           (\otherIdx (data, table) ->

    --             ( if (index == otherIdx) then

    --                 case data of
    --                   FromBackloggery items ->
    --                     items
    --                       |> Table.toggleItemSelection toToggle
    --                       |> FromBackloggery
    --                   PurescriptClasses _ _ -> data -- TODO
    --                   SwarmCheckins -> data

    --               else data
    --             , table
    --             )

    --           )
    --     }
    --   , Cmd.none
    --   )


-- VIEW


view : Model -> Html Msg
view model =
    div
      []
      [ case model.data of
            Just (PurescriptClasses state graph) ->
                (Html.div
                  [ ]
                  [ PS.stateControl state
                  , PS.toc state <| PS.extractToc <| Graph.mapNodes Tuple.second <| graph
                  , PS.graph state <| Graph.mapNodes Tuple.second <| graph
                  ]) |> Html.map ToPS
            Nothing -> div [] []
      , Html.div
          []
          [ Html.text <| case model.error of
              Just error -> error
              Nothing -> ""
          ]
      ]



            {- Nothing ->
                button [ onClick JsonRequested ] [ text "Upload JSON" ] -}


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none


{- download : String -> Cmd msg
download jsonContent =
  Download.string filename metaContent jsonContent -}


errorToString : Http.Error -> String
errorToString error =
    case error of
        Http.BadUrl url ->
            "The URL " ++ url ++ " was invalid"
        Http.Timeout ->
            "Unable to reach the server, try again"
        Http.NetworkError ->
            "Unable to reach the server, check your network connection"
        Http.BadStatus 500 ->
            "The server had a problem, try again later"
        Http.BadStatus 400 ->
            "Verify your information and try again"
        Http.BadStatus _ ->
            "Unknown error"
        Http.BadBody errorMessage ->
            errorMessage
