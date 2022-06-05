module PureScript.Tokenize exposing (..)


-- import Parser as P exposing ((|.))
import Regex


type Token
    = Class String String
    | Other String


--type Tokens = Tokens (List Token)


tokenize : String -> List Token
tokenize str =
    let
        strLen = String.length str

        matches =
            Regex.fromString "\\{\\{.*?\\}\\}"
            |> Maybe.map
                (\regex ->
                    Regex.find regex str
                )
            |> Maybe.withDefault []

        foldMatch { index, match } ( prevEnd, list ) =
            let matchLen = String.length match
                matchEnd = index + matchLen
                hasSemicolon =
                    match
                        |> String.indices ":"
                        |> List.head
                ( className, value ) =
                    case hasSemicolon of
                        Just scpos ->
                            ( match |> String.slice 2 scpos
                            , match |> String.slice (scpos + 1) (matchLen - 2)
                            )
                        Nothing -> ( "", match )
            in
                ( matchEnd
                ,
                    if index > prevEnd then

                        Class className value
                        :: ( Other <| String.slice prevEnd index str )
                        :: list
                    else
                        Class className value :: list

                )

        ( lastEnd, tokens ) =
            matches |> List.foldl foldMatch ( 0, [] )

    in
        case String.slice lastEnd strLen str of
            "" -> tokens |> List.reverse
            other -> (Other other :: tokens) |> List.reverse