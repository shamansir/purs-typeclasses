module PureScript.Graph exposing (..)

import Graph as G
import Dict exposing (Dict)

import PureScript.TypeClass as TC exposing (..)


type alias Extends =
    { parentId : ( G.NodeId, TC.Id )
    , childId : ( G.NodeId, TC.Id )
    }


type alias UGraph = G.Graph TypeClass ()

type alias EGraph = G.Graph TypeClass Extends


toGraph : Dict TC.TextId TypeClass -> EGraph
toGraph dict =
  let

        indexed : List (Int, (TC.Id, TypeClass))
        indexed =
            dict
                |> Dict.toList
                |> List.map (Tuple.mapFirst TC.Id)
                |> List.sortBy (Tuple.second >> .weight >> (*) -1)
                |> List.indexedMap Tuple.pair
--                |> Debug.log "indexed"

        idToIndex : Dict String Int
        idToIndex =
            indexed
                |> List.map (Tuple.mapSecond Tuple.first)
                |> List.foldl
                    (\(index, id) ntoi ->
                        ntoi |> Dict.insert (TC.idToString id) index
                    )
                    Dict.empty

        parentsToEdges : ( Int, TC.Id ) -> List TC.Id -> List (G.Edge Extends)
        parentsToEdges ( childIdx, childId ) =
            List.map
                (\parentId ->
                    Dict.get (TC.idToString parentId) idToIndex
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


toUGraph : Dict TC.TextId TypeClass -> UGraph
toUGraph =
  toGraph >> G.mapEdges (always ())


extractToc : G.Graph TypeClass a -> Dict TC.PackageName (List TC.Id)
extractToc =
    G.nodes
        >> List.foldl
            (\node ->
                Dict.update node.label.package.name
                    <| Maybe.map
                        ((::) node.label.id)
                        >> Maybe.withDefault (List.singleton node.label.id)
                        >> Just
            )
            Dict.empty


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