module PureScript.Graph exposing (..)

import Graph as G
import Dict exposing (Dict)

import PureScript.TypeClass exposing (..)


type alias Extends =
    { parentId : ( G.NodeId, String )
    , childId : ( G.NodeId, String )
    }


type alias UGraph = G.Graph TypeClass ()

type alias EGraph = G.Graph TypeClass Extends


toGraph : Dict String TypeClass -> EGraph
toGraph dict =
  let

        indexed : List (Int, (String, TypeClass))
        indexed =
            dict
                |> Dict.toList
                |> List.indexedMap Tuple.pair
--                |> Debug.log "indexed"

        nameToIndex : Dict String Int
        nameToIndex =
            indexed
                |> List.map (Tuple.mapSecond Tuple.first)
                |> List.foldl
                    (\(index, name) ntoi ->
                        ntoi |> Dict.insert name index
                    )
                    Dict.empty

        parentsToEdges : ( Int, String ) -> List String -> List (G.Edge Extends)
        parentsToEdges ( childIdx, childId ) =
            List.map
                (\parentId ->
                    Dict.get parentId nameToIndex
                        |> Maybe.map
                            (\parentIdx ->
                                G.Edge parentIdx childIdx
                                    <| Extends ( parentIdx, parentId ) ( childIdx, childId )
                            )
                )
                >> List.filterMap identity
    in
    indexed
    |> List.map (Tuple.mapSecond Tuple.second)
    |> List.foldl
        (\(idx, typeclass ) (nodes, edges) ->
            ( G.Node idx typeclass :: nodes
            , parentsToEdges (idx, typeclass.id) typeclass.parents
                ++ edges
            )
        )
        ( [], [] )
    |> \(nodes, edges)
            -> G.fromNodesAndEdges nodes edges


toUGraph : Dict String TypeClass -> UGraph
toUGraph =
  toGraph >> G.mapEdges (always ())


noParentsNodes : G.Graph n e -> List G.NodeId
noParentsNodes g =
    let
        oneOrAdd =
            Maybe.map ((+) 1) >> Maybe.withDefault 1 >> Just
        nodesThatHaveParents =
            G.edges g
                |> List.foldl (\{ to } dict -> Dict.update to oneOrAdd dict) Dict.empty
                |> Dict.keys
    in
        G.nodes g
            |> List.filter (\n -> not <| List.member n.id nodesThatHaveParents)
            |> List.map .id