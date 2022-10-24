let tc = ./../../typeclass.dhall
let d = ./../../typedef.dhall
let e_ = ../../expr.dhall
let e = ./../../build_expr.dhall


let psm = \(last : e_.Expr) -> e.subj "ParserT" [ e.n "s", e.n "m", last ] -- ParserT s m <last>
let psma = psm (e.n "a") -- e.subj "ParserT" [ e.n "s", e.n "m", e.n "a" ] -- ParserT s m a
let psmu = psm (e.classE "Unit")                                           -- ParserT s m Unit
let psmaaa = psm (e.br (e.fn3 (e.n "a") (e.n "a") (e.n "a")))              -- ParserT s m (a -> a -> a)
let psma2psma = e.fn2 psma psma                                            -- ParserT s m a -> ParserT s m a
let psma2psmu = e.fn2 psma psmu                                            -- ParserT s m a -> ParserT s m Unit
let br_maybe_a = e.br (e.class1 "Maybe" (e.n "a"))                         -- (Maybe a)
let br_list_a = e.br (e.class1 "List" (e.n "a"))                           -- (List a)
let br_nelist_a = e.br (e.class1 "NonEmptyList" (e.n "a"))                 -- (NonEmptyList a)
let br_arr_a = e.br (e.class1 "Array" (e.n "a"))                           -- (Array a)
let br_nearr_a = e.br (e.class1 "NonEmptyArray" (e.n "a"))                 -- (NonEmptyArray a)
let br_tuple = \(a : e_.Expr) -> \(b : e_.Expr) -> e.br (e.class "Tuple" [ a, b ]) -- (Tuple <a> <b>)


let combinators : tc.TClass =
    { id = "combinators"
    , name = "Combinators"
    , what = tc.What.Package_
    , info = "A “parser combinator” is a function which takes some parsers as arguments and returns a new parser"
    , module = [ "Parsing", "Combinators" ]
    , package = tc.pkmj "purescript-parsing" +10
    , link = "purescript-parsing/10.0.0/docs/Parsing"
    , def = d.pkg (d.id "combinators") "combinators"
    , members =
        [
            { name = "try"
            , def = psma2psma
            -- ParserT s m a -> ParserT s m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- >>> runParser "ac" ((char 'a' *> char 'b') <|> (char 'a' *> char 'c'))
            -- Left (ParseError "Expected 'b'" (Position { line: 1, column: 2 }))
            -- >>> runParser "ac" (try (char 'a' *> char 'b') <|> (char 'a' *> char 'c'))
            -- Right 'c'
        ,
            { name = "tryRethrow"
            , def = psma2psma
            -- ParserT s m a -> ParserT s m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- >>> runParser "ac" (try (char 'a' *> char 'b'))
            -- Left (ParseError "Expected 'b'" (Position { index: 1, line: 1, column: 2 }))
            -- >>> runParser "ac" (tryRethrow (char 'a' *> char 'b'))
            -- Left (ParseError "Expected 'b'" (Position { index: 0, line: 1, column: 1 }))
        ,
            { name = "lookAhead"
            , def = psma2psma
            -- ParserT s m a -> ParserT s m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "choice"
            , def =
                e.req1
                    (e.class1 "Foldable" (e.f "f"))
                    (e.fn2 (e.ap2 (e.f "f") (e.br psma)) psma)
            -- Foldable f => f (ParserT s m a) -> ParserT s m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "between"
            , def = e.fn [ psm (e.n "open"), psm (e.n "close"), psma, psma ]
            -- ParserT s m open -> ParserT s m close -> ParserT s m a -> ParserT s m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- parens = between (string "(") (string ")")
        ,
            { name = "notFollowedBy"
            , def = psma2psmu
            -- ParserT s m a -> ParserT s m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "option"
            , def = psma2psma
            -- ParserT s m a -> ParserT s m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "optionMaybe"
            , def = e.fn2 psma (psm br_maybe_a)
            -- ParserT s m a -> ParserT s m (Maybe a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "optional"
            , def = psma2psmu
            -- ParserT s m a -> ParserT s m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- optional (try p)
        ,
            { name = "many"
            , def = e.fn2 psma (psm br_list_a)
            -- ParserT s m a -> ParserT s m (List a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "many1"
            , def = e.fn2 psma (psm br_nelist_a)
            -- ParserT s m a -> ParserT s m (NonEmptyList a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "manyTill"
            , def = e.fn3 psma (psm (e.n "e")) (psm br_list_a)
            -- ParserT s m a -> ParserT s m e -> ParserT s m (List a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "manyTill_"
            , def = e.fn3 psma (psm (e.n "e")) (psm (br_tuple (br_list_a) (e.n "e")))
            -- ParserT s m a -> ParserT s m e -> ParserT s m (Tuple (List a) e)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            --
            -- runParser "aab" do
            --     a <- many letter
            --     b <- char 'b'
            --     pure (Tuple a b)
            --
            -- (ParseError "Expected 'b'" (Position { line: 1, column: 4 }))
            --
            -- runParser "aab" do
            --     Tuple a b <- manyTill_ letter do
            --         char 'b'
            --     pure (Tuple a b)
            --
            -- (Tuple ('a' : 'a' : Nil) 'b')
        ,
            { name = "many1Till"
            , def = e.fn3 psma (psm (e.n "e")) (psm br_nelist_a)
            -- ParserT s m a -> ParserT s m e -> ParserT s m (NonEmptyList a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "many1Till_"
            , def = e.fn3 psma (psm (e.n "e")) (psm (br_tuple br_nelist_a (e.n "e") ))
            -- ParserT s m a -> ParserT s m e -> ParserT s m (Tuple (NonEmptyList a) e)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "manyIndex"
            , def =
                e.fn
                    [ e.classE "Int"
                    , e.classE "Int"
                    , e.br (e.fn2 (e.classE "Int") psma)
                    , psm (br_tuple (e.classE "Int") br_list_a)
                    ]
            -- Int -> Int -> (Int -> ParserT s m a) -> ParserT s m (Tuple Int (List a))
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- manyIndex n n (\_ -> p) is equivalent to replicateA n p.
        ,
            { name = "skipMany"
            , def = psma2psmu
            -- ParserT s m a -> ParserT s m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "skipMany1"
            , def = psma2psmu
            -- ParserT s m a -> ParserT s m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "sepBy"
            , def = e.fn3 psma (psm (e.n "sep")) (psm br_list_a)
            -- ParserT s m a -> ParserT s m sep -> ParserT s m (List a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- digit `sepBy` string ","
        ,
            { name = "sepBy1"
            , def = e.fn3 psma (psm (e.n "sep")) (psm br_nelist_a)
            -- ParserT s m a -> ParserT s m sep -> ParserT s m (NonEmptyList a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "sepEndBy"
            , def = e.fn3 psma (psm (e.n "sep")) (psm br_list_a)
            -- ParserT s m a -> ParserT s m sep -> ParserT s m (List a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "sepEndBy1"
            , def = e.fn3 psma (psm (e.n "sep")) (psm br_nelist_a)
            -- ParserT s m a -> ParserT s m sep -> ParserT s m (NonEmptyList a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "endBy"
            , def = e.fn3 psma (psm (e.n "sep")) (psm br_list_a)
            -- ParserT s m a -> ParserT s m sep -> ParserT s m (List a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "endBy1"
            , def = e.fn3 psma (psm (e.n "sep")) (psm br_nelist_a)
            -- ParserT s m a -> ParserT s m sep -> ParserT s m (NonEmptyList a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "chainl"
            , def = e.fn [ psma, psmaaa, e.n "a", psma ]
            -- ParserT s m a -> ParserT s m (a -> a -> a) -> a -> ParserT s m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- chainl digit (string "+" $> add) 0
        ,
            { name = "chainl1"
            , def = e.fn [ psma, psmaaa, psma ]
            -- ParserT s m a -> ParserT s m (a -> a -> a) -> ParserT s m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "chainr"
            , def = e.fn [ psma, psmaaa, e.n "a", psma ]
            -- ParserT s m a -> ParserT s m (a -> a -> a) -> a -> ParserT s m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- chainr digit (string "+" $> add) 0
        ,
            { name = "chainr1"
            , def = e.fn [ psma, psmaaa, psma ]
            -- ParserT s m a -> ParserT s m (a -> a -> a) -> ParserT s m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "advance"
            , def = psma2psma
            -- ParserT s m a -> ParserT s m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "withErrorMessage"
            , def = e.fn [ psma, e.classE "String", psma ]
            -- ParserT s m a -> String -> ParserT s m a
            , belongs = tc.Belongs.No
            , op = Some "<?>"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "withLazyErrorMessage"
            , def = e.fn [ psma, e.br (e.fn2 (e.classE "Unit") (e.classE "String")), psma ]
            -- ParserT s m a -> (Unit -> String) -> ParserT s m a
            , belongs = tc.Belongs.No
            , op = Some "<~?>"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
            -- parseBang :: Parser Char
            -- parseBang = char '!' <~?> \_ -> "Expected a bang"
        ,
            { name = "asErrorMessage"
            , def = e.fn [ e.classE "String", psma, psma ]
            -- String -> ParserT s m a -> ParserT s m a
            , belongs = tc.Belongs.No
            , op = Some "<??>"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "alt"
            , def =
                e.req1
                    (e.class1 "Alt" (e.f "f"))
                    (e.fn3
                        (e.ap2 (e.f "f") (e.n "a"))
                        (e.ap2 (e.f "f") (e.n "a"))
                        (e.ap2 (e.f "f") (e.n "a"))
                    )
            -- Alt f => f a -> f a -> f a
            , belongs = tc.Belongs.Export [ "Control", "Plus" ]
            , op = Some "<|>"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "empty"
            , def =
                e.req1
                    (e.class1 "Plus" (e.f "f"))
                    (e.ap2 (e.f "f") (e.n "a"))
            -- Plus f => f a
            , belongs = tc.Belongs.Export [ "Control", "Plus" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "replicateM"
            , def =
                e.req1
                    (e.class1 "Monad" (e.t "m"))
                    (e.fn3
                        (e.classE "Int")
                        (e.ap2 (e.t "m") (e.n "a"))
                        (e.ap2 (e.f "m") (e.ap2 (e.t "m") br_list_a))
                    )
            -- Monad m => Int -> m a -> m (List a)
            , belongs = tc.Belongs.Export [ "Data", "List", "Lazy" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "replicateA"
            , def =
                e.reqseq
                    [ e.class1 "Applicative" (e.t "m"), e.subj1 "Unfoldable" (e.t "f"), e.class1 "Traversable" (e.t "f") ]
                    (e.fn3
                        (e.classE "Int")
                        (e.ap2 (e.t "m") (e.n "a"))
                        (e.ap2 (e.t "m") (e.br (e.ap2 (e.t "f") (e.n "a"))))
                    )
                -- Applicative m => Unfoldable f => Traversable f => Int -> m a -> m (f a)
            , belongs = tc.Belongs.Export [ "Data", "Unfoldable" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- > replicateA 5 (randomInt 1 10) :: Effect (Array Int)
            -- [1,3,2,7,5]
        ,
            { name = "replicate1A"
            , def =
                e.reqseq
                    [ e.class1 "Apply" (e.t "m"), e.subj1 "Unfoldable" (e.t "f"), e.class1 "Traversable" (e.t "f") ]
                    (e.fn3
                        (e.classE "Int")
                        (e.ap2 (e.t "m") (e.n "a"))
                        (e.ap2 (e.t "m") (e.br (e.ap2 (e.t "f") (e.n "a"))))
                    )
                -- Apply m => Unfoldable1 f => Traversable1 f => Int -> m a -> m (f a)
            , belongs = tc.Belongs.Export [ "Data", "Unfoldable1" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- > replicate1A 2 (randomInt 1 10) :: Effect (NEL.NonEmptyList Int)
            -- (NonEmptyList (NonEmpty 8 (2 : Nil)))
            -- > replicate1A 0 (randomInt 1 10) :: Effect (NEL.NonEmptyList Int)
            -- (NonEmptyList (NonEmpty 4 Nil))
        ,
            { name = "many*"
            , def = e.fn2 psma (psm br_arr_a)
            -- ParserT s m a -> ParserT s m (Array a)
            , belongs = tc.Belongs.Export [ "Parsing", "Combinators", "Array" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "many1*"
            , def = e.fn2 psma (psm br_nearr_a)
            -- ParserT s m a -> ParserT s m (NonEmptyArray a)
            , belongs = tc.Belongs.Export [ "Parsing", "Combinators", "Array" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "manyTill_*"
            , def = e.fn3 psma (psm (e.n "e")) (psm (br_tuple br_arr_a (e.n "e")))
            -- ParserT s m a -> ParserT s m e -> ParserT s m (Tuple (Array a) e)
            , belongs = tc.Belongs.Export [ "Parsing", "Combinators", "Array" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "manyIndex*"
            , def =
                e.fn
                    [ e.classE "Int"
                    , e.classE "Int"
                    , e.br (e.fn2 (e.classE "Int") psma)
                    , psm (br_tuple (e.classE "Int") br_arr_a)
                    ]
            -- Int -> Int -> (Int -> ParserT s m a) -> ParserT s m (Tuple Int (Array a))
            , belongs = tc.Belongs.Export [ "Parsing", "Combinators", "Array" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noVars /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in combinators