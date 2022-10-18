let tc = ./../../typeclass.dhall
let e_ = ../../expr.dhall
let e = ./../../build_expr.dhall

let pma = \(last : e_.Expr) -> e.subj "ParserT" [ e.classE "String", e.t "m", last ] -- ParserT String m <last>
let pmaa = pma (e.n "a")                                                             -- ParserT String m a
let pmchar = pma (e.classE "Char")                                                   -- ParserT String m Char
let pmstr = pma (e.classE "String")                                                  -- ParserT String m String
let pmcp = pma (e.classE "CodePoint")                                                -- ParserT String m CodePoint
let pmu = pma (e.classE "Unit")                                                      -- ParserT String m Unit
let pmtsa = pma (e.br (e.class "Tuple" [ e.classE "String", e.n "a" ]))              -- ParserT String m (Tuple String a)



let stringParsers : tc.TClass =
    { id = "stringparsers"
    , name = "String"
    , what = tc.What.Package_
    , info = "Primitive parsers for working with an input stream of type String"
    , module = [ "Parsing", "String" ]
    , package = tc.pkmj "purescript-parsing" +10
    , link = "purescript-parsing/10.0.0/docs/Parsing"
    , members =
        [
            { name = "char"
            , def = e.fn2 (e.classE "Char") pmchar
            -- Char -> ParserT String m Char
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "string"
            , def = e.fn2 (e.classE "String") pmstr
            -- String -> ParserT String m String
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "anyChar"
            , def = pmchar
            -- ParserT String m Char
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "anyCodePoint"
            , def = pmcp
            -- ParserT String m CodePoint
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "satisfy"
            , def = e.fn2 (e.br (e.fn2 (e.classE "Char") (e.classE "Boolean"))) pmchar
            -- (Char -> Boolean) -> ParserT String m Char
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "satisfyCodePoint"
            , def = e.fn2 (e.br (e.fn2 (e.classE "CodePoint") (e.classE "Boolean"))) pmcp
            -- (Char -> CodePoint) -> ParserT String m CodePoint
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "takeN"
            , def = e.fn2 (e.classE "Int") pmstr
            -- Int -> ParserT String m String
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "rest"
            , def = pmstr
            -- ParserT String m String
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "eof"
            , def = pmu
            -- ParserT String m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "match"
            , def = e.fn2 pmaa pmtsa
            -- ParserT String m a -> ParserT String m (Tuple String a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- fromCharArray <$> Data.Array.many (char 'x')
            -- fst <$> match (Combinators.skipMany (char 'x'))
        ,
            { name = "regex"
            , def =
                e.fn3
                    (e.classE "String")
                    (e.classE "RegexFlags")
                    (e.class "Either" [ e.classE "String", e.br pmstr ])
            -- String -> RegexFlags -> Either String (ParserT String m String)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- case regex "x*" noFlags of
            --     Left compileError -> unsafeCrashWith $ "xMany failed to compile: " <> compileError
            --     Right xMany -> runParser "xxxZ" do
            --         xMany
            --
            -- regex "x*" (dotAll <> ignoreCase)
        ,
            { name = "anyTill"
            , def =
                e.req1
                    (e.class1 "Monad" (e.t "m"))
                    (e.fn2 pmaa pmtsa)
            -- Monad m => ParserT String m a -> ParserT String m (Tuple String a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "consumeWiths"
            , def =
                e.fn2
                    (e.br (e.fn2 (e.classE "String")
                                 (e.class "Either" [ e.classE "String"
                                                   , e.obj (toMap { consumed = e.classE "String", remainder = e.classE "String", value = e.n "a" }) ]))
                    )
                    pmaa
            -- (String -> Either String { consumed :: String, remainder :: String, value :: a }) -> ParserT String m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "digit"
            , def = pmchar
            -- ParserT String m Char
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Basic" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "hexDigit"
            , def = pmchar
            -- ParserT String m Char
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Basic" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "octDigit"
            , def = pmchar
            -- ParserT String m Char
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Basic" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "letter"
            , def = pmchar
            -- ParserT String m Char
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Basic" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "space"
            , def = pmchar
            -- ParserT String m Char
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Basic" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "lower"
            , def = pmchar
            -- ParserT String m Char
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Basic" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "upper"
            , def = pmchar
            -- ParserT String m Char
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Basic" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "alphaNum"
            , def = pmchar
            -- ParserT String m Char
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Basic" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "intDecimal"
            , def = pma (e.classE "Int")
            -- ParserT String m Int
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Basic" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "number"
            , def = pma (e.classE "Number")
            -- ParserT String m Number
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Basic" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "whiteSpace"
            , def = pmstr
            -- ParserT String m String
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Basic" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "skipSpaces"
            , def = pmu
            -- ParserT String m Unit
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Basic" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "oneOf"
            , def = e.fn2 (e.class1 "Array" (e.classE "Char")) pmchar
            -- Array Char -> ParserT String m Char
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Basic" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "oneOfCodePoints"
            , def = e.fn2 (e.class1 "Array" (e.classE "CodePoint")) pmcp
            -- Array CodePoint -> ParserT String m CodePoint
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Basic" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "noneOf"
            , def = e.fn2 (e.class1 "Array" (e.classE "Char")) pmchar
            -- Array Char -> ParserT String m Char
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Basic" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "noneOfCodePoints"
            , def = e.fn2 (e.class1 "Array" (e.classE "CodePoint")) pmcp
            -- Array CodePoint -> ParserT String m CodePoint
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Basic" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "breakCap"
            , def =
                e.fn3
                    (e.classE "String")
                    (e.class "Parser" [ e.classE "String", e.n "a" ])
                    (e.class1 "Maybe" (e.br (e.class "T3" [ e.classE "String", e.n "a", e.classE "String" ])))
            -- String -> Parser String a -> Maybe (T3 String a String)
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Replace" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- breakCap "hay needle hay" (string "needle") -> Just ("hay " /\ "needle" /\ " hay")
            -- breakCap "abc 123 def" (match intDecimal) -> Just ("abc " /\ ("123" /\ 123) /\ " def")
        ,
            { name = "breakCapT"
            , def =
                e.reqseq
                    [ e.class1 "Monad" (e.t "m"), e.class1 "MonadRec" (e.t "m") ]
                    (e.fn3
                        (e.classE "String")
                        pmaa
                        (e.ap2 (e.t "m") (e.br (e.class1 "Maybe" (e.br (e.class "T3" [ e.classE "String", e.n "a", e.classE "String" ])))))
                    )
            -- Monad m => MonadRec m => String -> ParserT String m a -> m (Maybe (T3 String a String))
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Replace" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "splitCap"
            , def =
                e.fn3
                    (e.classE "String")
                    (e.class "Parser" [ e.classE "String", e.n "a" ])
                    (e.class1 "NonEmptyList" (e.br (e.class "Either" [ e.classE "String", e.n "a" ])))
            -- String -> Parser String a -> NonEmptyList (Either String a)
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Replace" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- splitCap "hay 1 straw 2 hay" intDecimal -> [Left "hay ", Right 1, Left " straw ", Right 2, Left " hay"]
            --
            -- catMaybes $ hush <$> splitCap ".𝝺...\n...𝝺." (position <* string "𝝺")
            -- [ Position {index: 1, line: 1, column: 2 }
            -- , Position { index: 9, line: 2, column: 4 }
            -- ]
            --
            -- ...
        ,
            { name = "splitCapT"
            , def =
                e.reqseq
                    [ e.class1 "Monad" (e.t "m"), e.class1 "MonadRec" (e.t "m") ]
                    (e.fn3
                        (e.classE "String")
                        pmaa
                        (e.ap2 (e.t "m") (e.br (e.class1 "NonEmptyList" (e.br (e.class "Either" [ e.classE "String", e.n "a" ])))))
                    )
            -- Monad m => MonadRec m => String -> ParserT String m a -> m (NonEmptyList (Either String a))
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Replace" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- ...
        ,
            { name = "replace"
            , def =
                e.fn3
                    (e.classE "String")
                    (e.class "Parser" [ e.classE "String", e.classE "String" ])
                    (e.classE "String")
            -- String -> Parser String String -> String
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Replace" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- replace "hay needle hay" (toUpper <$> string "needle") -> "hay NEEDLE hay"
            -- replace "1 6 21 107" (show <$> (_*2) <$> intDecimal) -> "2 12 42 214"
        ,
            { name = "replaceT"
            , def =
                e.reqseq
                    [ e.class1 "Monad" (e.t "m"), e.class1 "MonadRec" (e.t "m") ]
                    (e.fn3
                        (e.classE "String")
                        pmstr
                        (e.ap2 (e.t "m") (e.classE "String"))
                    )
            -- Monad m => MonadRec m => String -> ParserT String m String -> m String
            , belongs = tc.Belongs.Export [ "Parsing", "String", "Replace" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- ...
        ]
    } /\ tc.noVars /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in stringParsers