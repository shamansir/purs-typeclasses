let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- newtype ParserT :: Type -> (Type -> Type) -> Type -> Type
-- newtype ParserT s m a

let parsert : tc.TClass =
    { id = "parsert"
    , name = "ParserT"
    , vars = [ "s", "m", "a" ]
    , what = tc.What.Type_
    , info = "The `Parser s` monad with a monad transformer parameter m."
    , module = [ "Parsing" ]
    , package = tc.pkmj "purescript-parsing" +10
    , link = "purescript-parsing/10.0.0/docs/Parsing"
    , members =
        [
            { name = "runParserT"
            , def =
                e.req1
                    (e.class1 "MonadRec" (e.t "m"))
                    (e.fn3
                        (e.n "s")
                        (e.subj "ParserT" [ e.n "s", e.t "m", e.n "a" ])
                        (e.ap2 (e.t "m") (e.br (e.class "Either" [ e.classE "ParseError", e.n "a" ])))
                    )
                -- MonadRec m => s -> ParserT s m a -> m (Either ParseError a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "runParserT'"
            , def =
                e.req1
                    (e.class1 "MonadRec" (e.t "m"))
                    (e.fn3
                        (e.class1 "ParseState" (e.n "s"))
                        (e.subj "ParserT" [ e.n "s", e.t "m", e.n "a" ])
                        (e.ap2
                            (e.t "m")
                            (e.br
                                (e.class "Tuple"
                                    [ e.br ( e.class "Either" [ e.classE "ParseError", e.n "a" ] )
                                    , e.br ( e.class1 "ParseState" (e.n "s") )
                                    ]
                                )
                            )
                        )
                    )
                -- MonadRec m => ParseState s -> ParserT s m a -> m (Tuple (Either ParseError a) (ParseState s))
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "consume"
            , def = e.subj "ParserT" [ e.n "s", e.t "m", e.classE "Unit" ] -- ParserT s m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "position"
            , def = e.subj "ParserT" [ e.n "s", e.t "m", e.classE "Position" ] -- ParserT s m Position
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "fail"
            , def = e.fn2 (e.classE "String") (e.subj "ParserT" [ e.n "s", e.t "m", e.classE "a" ]) -- String -> ParserT s m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "failWithPosition"
            , def = e.fn3 (e.classE "String") (e.classE "Position") (e.subj "ParserT" [ e.n "s", e.t "m", e.classE "a" ]) -- String -> Position -> ParserT s m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "region"
            , def =
                e.fn3
                    (e.br (e.fn2 (e.classE "ParseError") (e.classE "ParseError")))
                    (e.subj "ParserT" [ e.n "s", e.t "m", e.classE "a" ])
                    (e.subj "ParserT" [ e.n "s", e.t "m", e.classE "a" ])
                -- (ParseError -> ParseError) -> ParserT s m a -> ParserT s m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "stateParserT"
            , def =
                e.fn2
                    (e.br (e.fn2 (e.class1 "ParseState" (e.n "s")) (e.class "Tuple" [ e.n "a", e.br (e.class1 "ParseState" (e.n "s")) ])))
                    (e.subj "ParserT" [ e.n "s", e.t "m", e.classE "a" ])
                --  (ParseState s -> Tuple a (ParseState s)) -> ParserT s m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "getParserT"
            , def = e.subj "ParserT" [ e.n "s", e.t "m", e.class1 "ParseState" (e.n "s") ] -- ParserT s m (ParseState s)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "hoistParserT"
            , def =
                e.fn3
                    (e.br (e.opc2 (e.n "m") "~>" (e.n "n")))
                    (e.subj "ParserT" [ e.n "s", e.t "m", e.classE "a" ])
                    (e.subj "ParserT" [ e.n "s", e.t "n", e.classE "a" ])
                -- (m ~> n) -> ParserT s m a -> ParserT s n a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "mapParserT"
            , def =
                e.reqseq
                    [ e.class1 "MonadRec" (e.n "m"), e.class1 "Functor" (e.n "n") ]
                    (
                        e.fn
                            [ e.ap2
                                (e.t "m")
                                (e.br
                                    (e.class "Tuple"
                                        [ e.br ( e.class "Either" [ e.classE "ParseError", e.n "a" ] )
                                        , e.br ( e.class1 "ParseState" (e.n "s") )
                                        ]
                                    )
                                )
                            , e.ap2
                                (e.t "m")
                                (e.br
                                    (e.class "Tuple"
                                        [ e.br ( e.class "Either" [ e.classE "ParseError", e.n "b" ] )
                                        , e.br ( e.class1 "ParseState" (e.n "s") )
                                        ]
                                    )
                                )
                            , e.subj "ParserT" [ e.n "s", e.t "m", e.classE "a" ]
                            , e.subj "ParserT" [ e.n "s", e.t "n", e.classE "b" ]
                            ]
                    )
                -- MonadRec m => Functor n => (m (Tuple (Either ParseError a) (ParseState s)) -> n (Tuple (Either ParseError b) (ParseState s))) -> ParserT s m a -> ParserT s n b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

-- Lazy (ParserT s m a)
-- (Semigroup a) => Semigroup (ParserT s m a)
-- (Monoid a) => Monoid (ParserT s m a)
-- Functor (ParserT s m)
-- Apply (ParserT s m)
-- Applicative (ParserT s m)
-- Bind (ParserT s m)
-- Monad (ParserT s m)
-- MonadRec (ParserT s m)
-- (MonadState t m) => MonadState t (ParserT s m)
-- MonadThrow ParseError (ParserT s m)
-- MonadError ParseError (ParserT s m)
-- Alt (ParserT s m)
-- Plus (ParserT s m)
-- Alternative (ParserT s m)
-- MonadPlus (ParserT s m)
-- MonadTrans (ParserT s)

in parsert