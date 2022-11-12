module PureScript.Render exposing (..)


import Html exposing (Html)
import Html.Attributes as Html
import Html.Events as Html
import Svg exposing (Svg)
import Svg.Attributes as Svg
import Graph exposing (Graph, Adjacency)
import Graph.Extra as Graph
import IntDict as ID


import PureScript.TypeClass as TC exposing
    ( TypeClass, Member, Law, Statement, LawExample(..), Instance, Var, Link, Package )
import PureScript.Render.Setup exposing (..)
import Graph.Geometry.Make as Render
import Graph.Render.Svg.Defs as Render
import Graph.Render.Svg.Graph as Render
import PureScript.Graph exposing (Extends)
import PureScript.Tokenize as T
import Dict
import PureScript.State as State exposing (State, TCState, Msg(..), knownPackages)


member : Member -> Svg Msg
member m =
    Svg.g
        []
        [ case m.opEmoji of
            Just operator ->
                Svg.g
                    []
                    [ Svg.circle
                        [ Svg.cx <| String.fromFloat firstOpX, Svg.cy <| String.fromFloat opsY
                        , Svg.r "10"
                        , Svg.fill "none", Svg.stroke "blue", Svg.strokeDasharray "1 1"
                        ]
                        []
                    , Svg.text_
                        [ Svg.x <| String.fromFloat firstOpX
                        , Svg.textAnchor "middle"
                        ]
                        [ Svg.text operator ]
                    ]
            Nothing ->
                Svg.g [] []
        , case m.op of
            Just operator ->
                Svg.g
                    []
                    [ Svg.circle
                        [ Svg.cx <| String.fromFloat secondOpX, Svg.cy <| String.fromFloat opsY
                        , Svg.r <| if String.length operator <= 3 then "10" else "14"
                        , Svg.fill "none", Svg.stroke "black", Svg.strokeDasharray "1 1"
                        ]
                        []
                    , Svg.text_
                        [ Svg.x <| String.fromFloat secondOpX
                        , Svg.textAnchor "middle"
                        ]
                        [ Svg.text operator ]
                    ]
            Nothing ->
                Svg.g [] []
        , Svg.text_
            [ Svg.transform <| translateTo memberPadding 2
            , Svg.fontSize <| String.fromInt memberNameFontSize
            ] <|
            [ Svg.tspan
                [ Svg.fontWeight "600"
                ]
                [ Svg.text <| m.name ]
            , Svg.tspan [ Svg.fill "lightgray" ] [ Svg.text " :: " ]
            ] ++ highlightTokens (T.tokenize m.def)
        , Svg.g
            [ Svg.transform <| translateTo memberPadding 25
            ]
            <| List.map (applyYCoord law)
            <| distributeByHeight lawGap heightOfLaw
            <| m.laws
        ]


law2 : ( String, String ) -> Svg msg
law2 ( left, right ) =
    Svg.g
        [ ]
        [ highlightTokens_
            [ Svg.transform <| translateTo 0 0 ]
            <| T.tokenize <| left
        , highlightTokens_
            [ Svg.transform <| translateTo 100 0 ]
            <| T.tokenize <| right
        ]


law3 : ( String, String, String ) -> Svg msg
law3 ( left, middle, right ) =
    Svg.g
        [ ]
        [ highlightTokens_
            [ Svg.transform <| translateTo 0 0 ]
            <| T.tokenize <| left
        , highlightTokens_
            [ Svg.transform <| translateTo 100 0 ]
            <| T.tokenize <| middle
        , highlightTokens_
            [ Svg.transform <| translateTo 200 0 ]
            <| T.tokenize <| right
        ]


law3Alt : ( String, String, List String ) -> Svg msg
law3Alt ( left, right, conclusions ) =
    Svg.g
        [ ]
        [ highlightTokens_
            [ Svg.transform <| translateTo 0 0 ]
            <| T.tokenize <| left
        , highlightTokens_
            [ Svg.transform <| translateTo 100 0 ]
            <| T.tokenize <| right
        , Svg.g
            []
            <| List.map (highlightTokens_ [] << T.tokenize)
            <| conclusions
        ]

lawExample : LawExample -> Svg msg
lawExample le =
    case le of
        LR { left, right } -> law2 ( left, right )
        LMR { left, middle, right } -> law3 ( left, middle, right )
        LRC { left, right, conditions } -> law3Alt ( left, right, conditions )
        FC { fact, conclusion } -> law2 ( fact, conclusion )
        OF { fact } -> law2 ( fact, "" )


law : Law -> Svg msg
law l =
    Svg.g
        [ Svg.fontSize <| String.fromInt lawExampleFontSize ]
        [ highlightTokens_
            [ ]
            <| T.tokenize <| l.law
        , Svg.g
            [ Svg.transform <| translateTo 0 lawNameHeight ]
            <| List.indexedMap (shiftByIndex lawExampleHeight)
            <| List.map lawExample
            <| l.examples
        ]


module_ : List String -> Svg msg
module_ =
    String.join "."
        >> Svg.text
        >> List.singleton
        >> Svg.text_
            [ Svg.fontSize <| String.fromFloat modulePathHeight
            , Svg.fill "#999900"
            ]


package_ : Package -> Svg msg
package_ =
    .name
    >> String.dropLeft (String.length "purescript-")
    >> Svg.text
    >> List.singleton
    >> Svg.text_
        [ Svg.fontSize <| String.fromFloat packagePathHeight
        -- , Svg.fill "#009999"
        , Svg.fill "lightgray"
        ]


parents : List TC.Id -> Svg msg
parents ps =
    if not <| List.isEmpty ps then
        "(" ++ String.join "," (List.map TC.idToString ps) ++ ")"
            |> Svg.text
            |> List.singleton
            |> Svg.text_
                [ Svg.fontSize <| String.fromInt parentFontSize
                , Svg.fill "#ccc"
                ]
    else Svg.g [] []


instances : List String -> Svg msg
instances is =
    if not <| List.isEmpty is then
        is
            |> List.map (T.tokenize >> highlightTokens)
            |> List.intersperse ([ Svg.tspan [] [ Svg.text "," ] ])
            |> List.concat
            |> Svg.text_
                [ Svg.fontSize <| String.fromInt instanceFontSize
                , Svg.fill "#999900"
                ]
    else Svg.g [] []


instance : Instance -> Svg msg
instance = T.tokenize >> highlightTokens_ [ Svg.fontSize <| String.fromInt instanceFontSize ]


statement : Statement -> Svg msg
statement { left, right } = law2 ( left, right )


statements : List Statement -> Svg msg
statements ss =
    if not <| List.isEmpty ss then
        {- "(" ++ String.join "," ss ++ ")"
            |> Svg.text
            |> List.singleton
            |> Svg.text_
                [ Svg.fontSize <| String.fromInt statementFontSize
                , Svg.fill "#999900"
                ] -}
        ss
            |> distributeByHeight lawGap heightOfStatement
            |> List.map (applyYCoord statement)
            |> Svg.g
                [ Svg.fontSize <| String.fromInt statementFontSize
                , Svg.fill "#000099"
                ]
    else Svg.g [] []


vars : List Var -> List (Svg msg)
vars =
    List.map (\var -> Svg.tspan [ Svg.fill "lightgray" ] [ Svg.text var ])
    >> List.intersperse (Svg.tspan [] [ Svg.text " " ])


link : Link -> Svg Msg
link l =
    Svg.text_
        []
        [ Svg.a
            [ Svg.xlinkHref <| pursuitRootUrl ++ "/" ++ l
            , Svg.target "_blank"
            ]
            [ Svg.text "🔗" ]
        ]


typeClass : TCState -> TypeClass -> Html Msg
typeClass tcState tclass =
    if not tcState.collapsed then
    Svg.g
        [ ]
        [ Svg.rect
            [ Svg.x "1", Svg.y <| String.fromFloat rectY
            , Svg.width <| String.fromInt cardWidth, Svg.height <| String.fromFloat <| heightOfCard tcState tclass
            , Svg.fill "transparent"
            , Svg.stroke "black", Svg.strokeWidth "1", Svg.rx "5", Svg.ry "5" ]
            []
        , Svg.g
            [ Svg.transform <| translateTo 5 modulePathHeight
            , Svg.fontSize <| String.fromInt modulePathFontSize
            ]
            [ module_ tclass.module_
            ]
        , Svg.g
            [ Svg.transform <| translateTo (cardWidth - 5) packagePathHeight
            , Svg.fontSize <| String.fromInt packagePathFontSize
            , Svg.textAnchor "end"
            ]
            [ package_ tclass.package
            ]
        , Svg.text_
            [ Svg.x "10", Svg.y  <| String.fromFloat classNameY
            , Svg.fontSize <| String.fromInt classNameFontSize
            , Svg.fontFamily classNameFont
            , Svg.fontWeight "500"
            , Html.style "cursor" "pointer"
            , Html.onClick <| Collapse tclass.id
            --, Svg.textDecoration "underline"
            --, Svg.textDecorationStyle "underline"
            ]
            (
                -- [ Svg.a [ Svg.xlinkHref <| "#" ++ tclass.name, Svg.id tclass.name ] [ Svg.text tclass.name ]
                [ Svg.tspan [ Svg.xlinkHref <| "#" ++ tclass.name, Svg.id tclass.name ] [ Svg.text tclass.name ]
                , Svg.tspan [] [ Svg.text " " ]
                ] ++ (tclass.vars |> vars)
            )
        , if tcState.showLink then
            let
                hasParents = List.length tclass.parents > 0
                ( linkX, linkY ) =
                    if not hasParents-- || not tcState.showConnection
                        then ( cardWidth - 25, classNameY )
                        else
                            if tcState.showConnection
                                then ( cardWidth - 25, classNameY + 20 )
                                else ( cardWidth - 25, classNameY + 25 ) -- + parentFontSize )

            in Svg.g
                [ Svg.transform <| translateTo linkX linkY
                , Svg.fontSize <| String.fromInt 15
                , Html.style "cursor" "pointer"
                ]
                [ link tclass.link
                ]
            else Svg.g [] []
        , Svg.g
            [ Svg.transform <| translateTo
                (if tcState.showConnection then parentsX - parentsOffsetXBeforeArrow else parentsX) parentsY
            , Svg.fontSize <| String.fromInt parentFontSize
            , Svg.fontFamily parentClassFont
            , Svg.textAnchor "end"
            ]
            [ parents tclass.parents
            ]
        , Svg.text_
            [ Svg.x "10", Svg.y  <| String.fromFloat infoY
            , Svg.fontSize <| String.fromInt infoFontSize
            , Svg.fontFamily infoFont
            , Svg.fill "#666"
            -- , Svg.fontStyle "italic"
            ]
            [ Svg.text tclass.info
            ]
        , Svg.g
            [ Svg.transform <| translateTo 10 <| statementsY tclass
            , Svg.fontSize <| String.fromInt statementFontSize
            ]
            [ statements tclass.statements
            ]
        , Svg.g
            [ Svg.transform <| translateTo 10 <| lawsY tclass
            ]
            <| List.map (applyYCoord law)
            <| distributeByHeight lawGap heightOfLaw
            <| tclass.laws
        , Svg.g
            [ Svg.transform <| translateTo 10 <| membersY tclass
            -- , Svg.fontSize <| String.fromInt memberFontSize
            ]
            <| List.map (applyYCoord member)
            -- <| List.map (applyYCoord <| addHeightRect member heightOfMember)
            <| distributeByHeight memberGap heightOfMember
            <| tclass.members
        , if tcState.showInstances then
             Svg.g
                [ Svg.transform <| translateTo 10 <| instancesY tclass ]
                <| List.map (applyYCoord instance)
                <| distributeByHeight instanceGap heightOfInstance
                <| tclass.instances
          else Svg.g [] []
        ]
    else
    Svg.g
        [ ]
        [ Svg.rect
            [ Svg.x "1", Svg.y <| String.fromFloat rectY
            , Svg.width <| String.fromFloat <| collapsedWidth tclass - typeClassGap
            , Svg.height <| String.fromFloat <| collapsedHeight tclass - typeClassGap
            , Svg.fill "transparent"
            , Svg.stroke "black", Svg.strokeWidth "1", Svg.rx "5", Svg.ry "5"
            ]
            []
        , Svg.text_
            [ Svg.x "10", Svg.y <| String.fromFloat classNameY
            , Svg.fontSize <| String.fromInt classNameFontSize
            , Svg.fontFamily classNameFont
            , Svg.fontWeight "500"
            --, Svg.textDecoration "underline"
            --, Svg.textDecorationStyle "underline"
            , Html.style "cursor" "pointer"
            , Html.onClick <| Expand tclass.id
            ]
            (
                [ Svg.tspan [ Svg.xlinkHref <| "#" ++ tclass.name, Svg.id tclass.name ] [ Svg.text tclass.name ]
                , Svg.tspan [] [ Svg.text " " ]
                ] ++ (tclass.vars |> vars)
            )
        ]


addHeightRect : (a -> Svg msg) -> (a -> Float) -> (a -> Svg msg)
addHeightRect render getHeight a =
    Svg.g
        []
        [ Svg.rect
            [ Svg.x "0", Svg.y <| String.fromFloat <| -1 * memberNameAndDefHeight
            , Svg.width "500", Svg.height <| String.fromFloat <| getHeight a
            , Svg.stroke "black", Svg.strokeWidth "1", Svg.fill "none"
            ]
            []
        , render a
        ]


shiftByIndex : Float -> Int -> Svg msg -> Svg msg
shiftByIndex height index =
    Svg.g
        [ Svg.transform <| translateTo 0 <| toFloat index * height
        ]
        << List.singleton


groupAndTranslate : Float -> Float -> Svg msg -> Svg msg
groupAndTranslate x y =
    Svg.g
        [ Svg.transform <| translateTo x y
        ]
        << List.singleton


applyYCoord : (a -> Svg msg) -> (Float, a) -> Svg msg
applyYCoord render (yPos, a) =
    render a |> groupAndTranslate 0 yPos


arrowHeadDefs : Render.Defs msg
arrowHeadDefs =
    Render.defs
        -- [ Svg.marker
        --     [ Svg.id "arrowhead", Svg.markerWidth "10", Svg.markerHeight "7", Svg.refX "0", Svg.refY "3.5", Svg.orient "auto" ]
        --     [ Svg.polygon [ Svg.points "0 0, 10 3.5, 0 7" ] [] ]
        -- ]
        [ Svg.marker
            [ Svg.id "arrowhead", Svg.markerWidth "5", Svg.markerHeight "4.5", Svg.refX "8.0", Svg.refY "1.75", Svg.orient "auto"
            , Svg.fill "rgba(0, 0, 0, 0.2)"
            ]
            [ Svg.polygon [ Svg.points "0 0, 5 1.75, 0 3.5" ] [] ]
        ]


type alias NodesSizes = ID.IntDict { width : Float, height : Float }


edge : State.Collapsed -> NodesSizes -> Render.NodesPositions -> Extends -> Html Msg
edge collapsed sizes positions { parentId, childId } =
    let
        parentPos = positions |> ID.get (parentId |> Tuple.first) |> Maybe.withDefault { x = 0, y = 0 }
        childPos =  positions |> ID.get (childId |> Tuple.first) |> Maybe.withDefault { x = 0, y = 0 }
        isParentCollapsed = parentId |> Tuple.second |> State.isCollapsed collapsed
        isChildCollapsed = childId |> Tuple.second |> State.isCollapsed collapsed
        parentSize = sizes |> ID.get (parentId |> Tuple.first) |> Maybe.withDefault { width = 0, height = 0 }
        childSize = sizes |> ID.get (childId |> Tuple.first) |> Maybe.withDefault { width = 0, height = 0 }
        startPos =
            { x = childPos.x + childSize.width - (if not isChildCollapsed then arrowOffsetX else 30)
            , y = childPos.y + arrowOffsetStartY
            }
        endPos =
            { x = parentPos.x + parentSize.width - (if not isChildCollapsed then arrowOffsetX else 30)
            , y = parentPos.y + parentSize.height - (if not isChildCollapsed then arrowOffsetEndY else 15)
            }
        radius = 8
    in
    Svg.g
        []
        [ Svg.circle
            [ Svg.cx <| String.fromFloat <| startPos.x, Svg.cy <| String.fromFloat <| startPos.y
            -- , Svg.r "8", Svg.stroke "black", Svg.fill "transparent", Svg.strokeDasharray "1 0 1"
            , Svg.r "6", Svg.fill "black"
            -- , Svg.transform <| translateTo parentPos.x parentPos.y
            ]
            []
        , Svg.line
            [ Svg.x1 <| String.fromFloat <| startPos.x, Svg.y1 <| String.fromFloat <| startPos.y
            , Svg.x2 <| String.fromFloat <| endPos.x,   Svg.y2 <| String.fromFloat <| endPos.y
            , Svg.stroke "rgba(0, 0, 0, 0.2)", Svg.strokeWidth "2"
            -- , Svg.strokeDasharray "3 0 3"
            -- , Svg.markerStart "url(#arrowhead)"
            , Svg.markerEnd "url(#arrowhead)"
            ]
            []
        , Svg.circle
            [ Svg.cx <| String.fromFloat <| endPos.x, Svg.cy <| String.fromFloat <| endPos.y
            , Svg.r "6", Svg.fill "black"
            -- , Svg.transform <| translateTo parentPos.x parentPos.y
            ]
            []
        ]


edges : State.Collapsed -> NodesSizes -> Render.NodesPositions -> Adjacency Extends -> Html Msg
edges collapsed sizes positions adjacency =
    Svg.g []
        <| List.map (Tuple.second >> edge collapsed sizes positions)
        <| ID.toList adjacency


graph : State -> Graph TypeClass Extends -> Html Msg
graph state g =
    let

        graphPrepared
            : Graph
                { tc : TypeClass, size : { width : Float, height : Float }, state : State.TCState }
                Extends
        graphPrepared =
            g
                |> Graph.filter (.package >> .name >> State.isShown state.packagesShown)
                |> Graph.mapContexts mapContext

        mapContext ctx =
            let
                tc = ctx.node.label
                tcState = state |> State.makeTCState ctx.node
            in
                { node =
                    { id = ctx.node.id
                    , label =
                        { size = sizeOfTC tcState tc
                        , state = tcState
                        , tc = tc
                        }
                    }
                , incoming = ctx.incoming
                , outgoing = ctx.outgoing
                }

        sizeOfTC tcState tc =
            if not <| State.isCollapsed state.collapsed tc.id then
                { width = fullWidth tc, height = fullHeight tcState tc }
            else
                { width = collapsedWidth tc, height = collapsedHeight tc }

        sizes =
            graphPrepared
                |> Graph.nodes
                |> List.foldl
                    (\{ id, label } -> ID.insert id label.size)
                    ID.empty

        idToNodeId =
            graphPrepared
                |> Graph.nodes
                |> List.foldl
                    (\{ id, label } -> Dict.insert (TC.idToString label.tc.id) id)
                    Dict.empty

        positionTypeClass positions { x, y } =
            case state.focusAt of
                Just (TC.Id tcId) ->
                    case idToNodeId |> Dict.get tcId |> Maybe.andThen (\nodeId -> ID.get nodeId positions) of
                        Just p -> groupAndTranslate (x - p.x) (y - p.y) -- TODO: groupAndTranslate x y
                        Nothing -> groupAndTranslate x y
                Nothing -> groupAndTranslate x y

        renderCtx pos positions { node, incoming, outgoing } =
            Svg.g
                [ ]
                [ typeClass node.label.state node.label.tc |> positionTypeClass positions pos
                , if state.showConnections then edges state.collapsed sizes positions incoming else Svg.g [] []
                , if state.showConnections then edges state.collapsed sizes positions outgoing else Svg.g [] []
                ]

    in Render.graphWithDefs
        arrowHeadDefs
        Render.defaultWay
        renderCtx
        .size
        graphPrepared



translateTo : Float -> Float -> String
translateTo x y = "translate(" ++ String.fromFloat x ++ "," ++ String.fromFloat y ++ ")"


highlightRules =
    Dict.fromList
        [ ( "subj", "tan" )
        , ( "var", "darkcyan" )
        , ( "op", "dimgray" )
        , ( "class", "#2657AF" )
        , ( "method", "brown" )
        , ( "typevar", "orange" )
        , ( "fvar", "steelblue" )
        , ( "kw", "blue" )
        , ( "val", "green" )
        -- 1D3D75
        -- 239290
        -- 2657AF
        -- AE0428
        -- FF8B25
        -- 33C5B9
        -- FFBD16
        ]


highlightTokens : List T.Token -> List (Svg msg)
highlightTokens =
    List.map
        (\token ->
            case token of
                T.Other text ->
                    Svg.tspan [] [ Svg.text text ]
                T.Class class text ->
                    Svg.tspan [ Svg.fill <| Maybe.withDefault "black" <| Dict.get class highlightRules ] [ Svg.text text ]
        )

highlightTokens_ : List (Svg.Attribute msg) -> List T.Token -> Svg msg
highlightTokens_ attrs =
    Svg.text_
        attrs
        << List.map
            (\token ->
                case token of
                    T.Other text ->
                        Svg.tspan [] [ Svg.text text ]
                    T.Class class text ->
                        Svg.tspan [ Svg.fill <| Maybe.withDefault "black" <| Dict.get class highlightRules ] [ Svg.text text ]
            )


stateControl : State -> Html Msg
stateControl state =
    let
        controlHeight =
            Dict.size state.packagesShown * 20 + (3 * 25) + 8
        button text onClick = button_ text onClick False
        button_ text onClick disabled =
            Html.input
                [ Html.type_ "button"
                , Html.onClick onClick
                , Html.value text
                , Html.style "font-size" "9px"
                , Html.disabled disabled
                ]
                [ Html.text text ]
        toggle id text onClick checked =
            Html.div
                []
                [ Html.input
                    [ Html.id id, Html.type_ "checkbox"
                    , Html.checked checked
                    , Html.onClick onClick
                    ]
                    []
                , Html.label [ Html.for id ] [ Html.text text ]
                ]
        packageSwitchers =
            Html.div
            []
            <| List.map
                (\(package, shown) ->
                    toggle ("show-" ++ package) package (Switch package) shown
                )
            <| Dict.toList
            <| state.packagesShown
        expandCollapseClasses =
            Html.div
                []
                [ button_ "Expand All" ExpandAll
                    <| case state.collapsed of
                        State.AllExpanded -> True
                        _ -> False
                , button_ "Collapse All" CollapseAll
                    <| case state.collapsed of
                        State.AllCollapsed -> True
                        _ -> False
                ]
        showHideAllClasses =
            Html.div
                []
                [ button_ "Show All" ShowAll
                    <| not <| List.any not <| Dict.values state.packagesShown
                , button_ "Hide All" HideAll
                    <| not <| List.any identity <| Dict.values state.packagesShown
                ]
        expandCollapseStateButton =
            Html.span
                [ Html.style "position" "absolute"
                , Html.style "right" "5px"
                , Html.style "top" "3px"
                , Html.onClick <| SwitchStateControl
                ]
                [ Html.text "⚙️"
                ]
        whatToDisplayControls =
            Html.div
                []
                [ toggle "show-connections" "<->" SwitchConnections state.showConnections
                , toggle "show-instances" "=>" SwitchInstances state.showInstances
                , toggle "show-links" "🔗" SwitchLinks state.showLinks
                ]
    in
    if not state.controlCollapsed then
        Html.div
            [ Html.style "position" "fixed"
            , Html.style "width" "150px"
            , Html.style "height" <| String.fromInt controlHeight ++ "px"
            , Html.style "border" "1px solid black"
            , Html.style "border-radius" "5px"
            , Html.style "bottom" "10px"
            , Html.style "background" "white"
            , Html.style "cursor" "pointer"
            ]
            [ expandCollapseStateButton
            , expandCollapseClasses
            , showHideAllClasses
            , packageSwitchers
            , Html.hr [] []
            , whatToDisplayControls
            ]
    else
        Html.div
            [ Html.style "position" "fixed"
            , Html.style "width" "20px"
            , Html.style "height" "20px"
            , Html.style "border" "1px solid black"
            , Html.style "border-radius" "5px"
            , Html.style "bottom" "10px"
            , Html.style "background" "white"
            , Html.style "cursor" "pointer"
            ]
            [ expandCollapseStateButton
            ]
