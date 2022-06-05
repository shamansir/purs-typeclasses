module PureScript.Render.Setup exposing (..)


import PureScript.TypeClass exposing
    ( TypeClass, Member, Law, Statement, LawExample(..), Instance )
import PureScript.State exposing (TCState)


pursuitRootUrl = "https://pursuit.purescript.org/packages"


cardWidth = 500
modulePathFontSize = 9
packagePathFontSize = 9
classNameFontSize = 20
titleHeight = 20
infoFontSize = 12
parentFontSize = floor <| classNameFontSize * 0.8
instanceFontSize = 13
statementFontSize = lawExampleFontSize
memberNameFontSize = 14
memberDefFontSize = 12
lawNameFontSize = 14

lawExampleFontSize = 12


typeClassGap = 15

memberGap = 5
lawGap = 5
statementGap = 5
instanceGap = 5


modulePathHeight = modulePathFontSize * 1.3
packagePathHeight = packagePathFontSize * 1.3
classNameHeight = classNameFontSize * 1.3
infoHeight = infoFontSize * 1.5
parentHeight = toFloat parentFontSize * 1.3
instanceHeight = instanceFontSize * 1.3
statementHeight = statementFontSize * 1.3
memberNameAndDefHeight = max memberNameFontSize memberDefFontSize * 1.3
lawNameHeight = lawNameFontSize * 1.3
lawExampleHeight = lawExampleFontSize * 1.3
firstOpX = 10
secondOpX = 36
opsY = -3

memberPadding = 52


rectY = modulePathHeight + 5
classNameY = modulePathHeight + 5 + classNameFontSize + 5

infoY = classNameY + infoHeight
parentsX = cardWidth - 10
parentsY = classNameY -- infoY + parentHeight
statementsY tc
    = infoY
    + (if not <| List.isEmpty tc.statements then statementHeight else 0)
lawsY tc
    = infoY
    + (tc.statements |> heightWithGaps statementGap heightOfStatement)
    + (if not <| List.isEmpty tc.laws then lawNameHeight else 0)
    + 10
membersY tc
    = infoY
    + (tc.statements |> heightWithGaps statementGap heightOfStatement)
    + (tc.laws |> heightWithGaps lawGap heightOfLaw)
    + (if not <| List.isEmpty tc.members then memberNameAndDefHeight else 0)
    + 10
instancesY tc
    = infoY
    + (tc.statements |> heightWithGaps statementGap heightOfStatement)
    + (tc.laws |> heightWithGaps lawGap heightOfLaw)
    + (tc.members |> heightWithGaps memberGap heightOfMember) + 15
    + (if not <| List.isEmpty tc.instances then instanceHeight else 0)


classNameFont = "Bangla MN"
parentClassFont = classNameFont
infoFont = "\"Bodoni 72\""
memberNameFont = "'Trebuchet MS', 'Lucida Sans Unicode', 'Lucida Grande', 'Lucida Sans', Arial, sans-serif"
memberDefFont = ""


arrowOffsetX = 63
arrowOffsetStartY = 36
arrowOffsetEndY = 13

parentsOffsetXBeforeArrow = 18


totalHeight : List ( TypeClass, TCState ) -> Float
totalHeight tcs =
    ( tcs
        |> List.map (\( tc, tcState ) -> fullHeight tcState tc)
        |> List.sum
    ) + typeClassGap * toFloat (List.length tcs - 1)


heightOfCard : TCState -> TypeClass -> Float
heightOfCard state tc =
    15 + infoY - rectY
    --+ ( if not <| List.isEmpty tc.parents then parentHeight else 0)
    + (tc.statements |> heightWithGaps statementGap heightOfStatement)
    + 10 + (tc.members |> heightWithGaps memberGap heightOfMember)
    + 10 + (tc.laws |> heightWithGaps lawGap heightOfLaw)
    + (if state.showInstances then tc.instances |> heightWithGaps instanceGap heightOfInstance else 0)


heightOfStatement : Statement -> Float
heightOfStatement = always statementHeight


heightOfInstance : Instance -> Float
heightOfInstance = always instanceHeight


heightOfMember : Member -> Float
heightOfMember m =
    memberNameAndDefHeight + 20
    + (m.laws |> heightWithGaps lawGap heightOfLaw)


heightOfLaw : Law -> Float
heightOfLaw l =
    lawNameHeight + 5
    + (l.examples
        |> List.map (always lawExampleHeight)
        |> List.sum)


fullHeight : TCState -> TypeClass -> Float
fullHeight state tc = rectY + heightOfCard state tc


fullWidth : TypeClass -> Float
fullWidth _ = 550


collapsedHeight : TypeClass -> Float
collapsedHeight tc = rectY + classNameFontSize + typeClassGap


collapsedWidth : TypeClass -> Float
collapsedWidth _ = 250


heightWithGaps : Float -> (a -> Float) -> List a -> Float
heightWithGaps gap heightOfA list =
    if List.isEmpty list then 0
    else (gap * (toFloat <| List.length list - 1))
        + (list |> List.map heightOfA |> List.sum)


distributeByHeight : Float -> (a -> Float) -> List a -> List (Float, a)
distributeByHeight gap toHeight =
    List.foldl
        (\a ( prevHeight, vals ) ->
            ( prevHeight + gap + toHeight a
            , (prevHeight, a)
                :: vals
            )
        ) ( 0, [] )
        >> Tuple.second
