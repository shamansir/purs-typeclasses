module PureScript.State exposing (..)


-- import IntDict as ID exposing (IntDict)
import Dict exposing (Dict)
import Graph exposing (Node, NodeId)

import PureScript.TypeClass exposing (TypeClass)


type alias TypeClassId = String


type alias PackageId = String


type alias State =
    { collapsed : Collapsed
    , showConnections : Bool
    , packagesShown : PackagesShown
    , controlCollapsed : Bool
    , showInstances : Bool
    , showLinks : Bool
    }


type alias PackagesShown = Dict TypeClassId Bool


type Collapsed
    = AllCollapsed
    | AllExpanded
    | AllExpandedExcept (List TypeClassId)
    | AllCollapsedExcept (List TypeClassId)


knownPackages =
    [ "prelude"
    , "foldable-traversable"
    , "control"
    , "contravariant"
    , "const"
    , "functors"
    , "bifunctors"
    , "profunctor"
    , "distributive"
    , "invariant"
    , "parsing"
    , "profunctor-lenses"
    , "unfoldable"
    , "distributive"
    ]



init : State

init =
    { collapsed = AllExpanded
    --{ collapsed = AllCollapsed
    , showConnections = True
    -- , showVars = False
    -- , collapseInstances = True // showInstances
    -- , showLaws = False
    , packagesShown =
        knownPackages
        |> List.map (\package -> ( package, (package == "prelude") ) )
        |> Dict.fromList
    , controlCollapsed = False
    , showInstances = False
    , showLinks = True
    }


type alias TCState =
    { nodeId : NodeId
    , collapsed : Bool
    , showConnection : Bool
    , showInstances : Bool
    , showLink : Bool
    }


type Msg
    = Expand TypeClassId
    | Collapse TypeClassId
    | ExpandAll
    | CollapseAll
    | HideAll
    | ShowAll
    | Switch PackageId
    | SwitchStateControl
    | SwitchConnections
    | SwitchInstances
    | SwitchLinks


update : Msg -> State -> State
update msg state =
    case msg of
        Switch package ->
            { state
            | packagesShown =
                state.packagesShown
                    |> Dict.update package (Maybe.map not)
            }
        Collapse tClass ->
            { state
            | collapsed =
                case state.collapsed of
                    AllExpanded -> AllExpandedExcept [ tClass ]
                    AllExpandedExcept collapsed -> AllExpandedExcept <| tClass :: collapsed
                    AllCollapsedExcept expanded -> AllCollapsedExcept <| List.filter (not << (==) tClass) <| expanded
                    AllCollapsed -> AllCollapsed
            }
        Expand tClass ->
            { state
            | collapsed =
                case state.collapsed of
                    AllCollapsed -> AllCollapsedExcept [ tClass ]
                    AllCollapsedExcept expanded -> AllCollapsedExcept <| tClass :: expanded
                    AllExpandedExcept collapsed -> AllExpandedExcept <| List.filter (not << (==) tClass) <| collapsed
                    AllExpanded -> AllExpanded
            }
        CollapseAll ->
            { state
            | collapsed = AllCollapsed
            }
        ExpandAll ->
            { state
            | collapsed = AllExpanded
            }
        HideAll ->
            { state
            | packagesShown = state.packagesShown |> (Dict.map <| always <| always False)
            }
        ShowAll ->
            { state
            | packagesShown = state.packagesShown |> (Dict.map <| always <| always True)
            }
        SwitchStateControl ->
            { state
            | controlCollapsed = not state.controlCollapsed
            }
        SwitchConnections ->
            { state
            | showConnections = not state.showConnections
            }
        SwitchInstances ->
            { state
            | showInstances = not state.showInstances
            }
        SwitchLinks ->
            { state
            | showLinks = not state.showLinks
            }



isCollapsed : Collapsed -> TypeClassId -> Bool
isCollapsed collapsed tcId =
    case collapsed of
        AllExpanded -> False
        AllCollapsed -> True
        AllCollapsedExcept clases -> not <| List.member tcId clases
        AllExpandedExcept clases -> List.member tcId clases


isShown : PackagesShown -> PackageId -> Bool
isShown packagesShown pkgId =
    packagesShown
        |> Dict.get (String.dropLeft (String.length "purescript-") pkgId)
        |> Maybe.withDefault False


makeTCState : Node TypeClass -> State -> TCState
makeTCState node state =
    { nodeId = node.id
    , collapsed = isCollapsed state.collapsed node.label.id
    , showConnection = state.showConnections
    , showInstances = state.showInstances
    , showLink = state.showLinks
    }