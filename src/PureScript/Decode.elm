module PureScript.Decode exposing (..)


import Json.Decode as D
import Dict exposing (Dict)

import PureScript.TypeClass exposing (..)



decode : D.Decoder TypeClass
decode =
    D.map6
        (\id name info what vars link ->
            { id = id, name = name, info = info, what = what, vars = vars, link = link }
        )
        (D.field "id" D.string)
        (D.field "name" D.string)
        (D.field "info" D.string)
        (D.field "what" D.string)
        (D.field "vars" <| D.list D.string)
        (D.field "link" D.string)
    |> D.andThen
        (\{ id, name, info, what, vars, link } ->
            D.map8
                (TypeClass id name info what vars link)
                (D.field "parents" <| D.list D.string)
                (D.field "package" <| D.string)
                (D.field "module" <| D.list D.string)
                (D.field "instances" <| D.list D.string)
                (D.field "statements" <| D.list decodeStatement)
                (D.field "members" <| D.list decodeMember)
                (D.field "values" <| D.list D.string)
                (D.field "laws" <| D.list decodeLaw)
        )

decodeMember : D.Decoder Member
decodeMember =
    D.map5
        Member
        (D.field "name" D.string)
        (D.field "def" D.string)
        (D.maybe <| D.field "op" D.string)
        (D.maybe <| D.field "opEmoji" D.string)
        ("laws" |> maybeListOf decodeLaw)


decodeLaw : D.Decoder Law
decodeLaw =
    D.map2
        Law
        (D.field "law" D.string)
        (D.field "examples" <| D.list decodeExample)


decodeExample : D.Decoder LawExample
decodeExample =
    let
        lr_ l r = LR { left = l, right = r }
        lmr_ l m r = LMR { left = l, middle = m, right = r }
        lrc_ l r c = LRC { left = l, right = r, conditions = c }
        fc_ f c = FC { fact = f, conclusion = c }
        of_ f = OF { fact = f }
        decodeValue ty =
            case ty of
                "of" ->
                    D.field "fact" D.string
                        |> D.map of_
                "fc" ->
                    D.map2
                        fc_
                        (D.field "fact" D.string)
                        (D.field "conclusion" D.string)
                "lr" ->
                    D.map2
                        lr_
                        (D.field "left" D.string)
                        (D.field "right" D.string)
                "lmr" ->
                    D.map3
                        lmr_
                        (D.field "left" D.string)
                        (D.field "middle" D.string)
                        (D.field "right" D.string)
                "lrc" ->
                    D.map3
                        lrc_
                        (D.field "left" D.string)
                        (D.field "right" D.string)
                        (D.field "conditions" <| D.list D.string)
                _ -> D.fail <| "Unknown type " ++ ty
    in D.field "type" D.string
        |> D.andThen
            (D.field "v" << decodeValue)


decodeStatement : D.Decoder Statement
decodeStatement =
    D.map2
        Statement
        (D.field "right" D.string)
        (D.field "left" D.string)


decodeMany : D.Decoder (Dict String TypeClass)
decodeMany =
    -- D.dict decode
    (D.field "defs" <| D.list decode)
        |> D.map (List.map <| \tc -> ( tc.id, tc ))
        |> D.map Dict.fromList


maybeListOf : D.Decoder a -> String -> D.Decoder (List a)
maybeListOf itemDecoder field =
    D.list itemDecoder
    |> D.field field
    |> D.maybe
    |> D.map (Maybe.withDefault [])