let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let strong : tc.TClass =
    { id = "strong"
    , name = "Strong"
    , what = tc.What.Class_
    , vars = [ "p" ]
    , parents = [ "profunctor" ]
    , info = "Extends Profunctor with combinators for working with product types"
    , module = [ "Data", "Profunctor" ]
    , package = tc.pkmj "purescript-profunctor" +5
    , link = "purescript-profunctor/5.0.0/docs/Data.Profunctor.Strong"
    , members =
        [
            { name = "first"
            , def =
                e.fn2
                    (e.ap3 (e.t "p") (e.n "a") (e.n "b"))
                    (e.ap3 (e.t "p") (e.br (e.class "Tuple" [ e.n "a", e.n "c" ])) (e.br (e.class "Tuple" [ e.n "b", e.n "c" ])))
                 -- p a b -> p (Tuple a c) (Tuple b c)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "second"
            , def =
                e.fn2
                    (e.ap3 (e.t "p") (e.n "b") (e.n "c"))
                    (e.ap3 (e.t "p") (e.br (e.class "Tuple" [ e.n "a", e.n "b" ])) (e.br (e.class "Tuple" [ e.n "a", e.n "c" ])))
                -- p b c -> p (Tuple a b) (Tuple a c)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "splitStrong"
            , def =
                e.reqseq
                    [ e.class1 "Category" (e.t "p"), e.subj1 "Strong" (e.t "p") ]
                    (e.fn
                        [ e.ap3 (e.t "p") (e.n "a") (e.n "b")
                        , e.ap3 (e.t "p") (e.n "c") (e.n "d")
                        , (e.ap3 (e.t "p") (e.br (e.class "Tuple" [ e.n "a", e.n "c" ])) (e.br (e.class "Tuple" [ e.n "b", e.n "d" ])))
                        ]
                    )
                -- Category p => Strong p => p a b -> p c d -> p (Tuple a c) (Tuple b d)
            , belongs = tc.Belongs.No
            , op = Some "***"
            , opEmoji = tc.noOp
            , laws =
                [
                    { law = "for function"
                    , examples =
                        [ tc.of
                            { fact =
                                e.opdef1 "***"
                                    (e.fn
                                        [ e.br (e.fn2 (e.n "a") (e.n "b"))
                                        , e.br (e.fn2 (e.n "c") (e.n "d"))
                                        , e.br (e.class "Tuple" [ e.n "a", e.n "c" ])
                                        , e.br (e.class "Tuple" [ e.n "b", e.n "d" ])
                                        ]
                                    )
                                -- (***) :: (a -> b) -> (c -> d) -> (Tuple a c) -> (Tuple b d)
                            }
                        ]
                    }
                ]
            }
        ,
            { name = "fanout"
            , def =
                e.reqseq
                    [ e.class1 "Category" (e.t "p"), e.subj1 "Strong" (e.t "p") ]
                    (e.fn
                        [ e.ap3 (e.t "p") (e.n "a") (e.n "b")
                        , e.ap3 (e.t "p") (e.n "a") (e.n "c")
                        , e.ap3 (e.t "p") (e.n "a") (e.br (e.class "Tuple" [ e.n "b", e.n "c" ]))
                        ]
                    )
                -- Category p => Strong p => p a b -> p a c -> p a (Tuple b c)
            , belongs = tc.Belongs.No
            , op = Some "&&&"
            , opEmoji = tc.noOp
            , laws =
                [
                    { law = "for function"
                    , examples =
                        [ tc.of
                            { fact =
                                e.opdef1 "&&&"
                                    (e.fn
                                        [ e.br (e.fn2 (e.n "a") (e.n "b"))
                                        , e.br (e.fn2 (e.n "c") (e.n "d"))
                                        , e.br (e.fn2 (e.n "a") (e.class "Tuple" [ e.n "a", e.n "c" ]))
                                        ]
                                    )
                                -- (&&&) :: (a -> b) -> (a -> c) -> (a -> (Tuple b c))
                            }
                        ]
                    }
                ]
            }
        ]
    , instances =
        [ i.instance "Function" "Strong"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in strong