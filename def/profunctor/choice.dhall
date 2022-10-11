let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let choice : tc.TClass =
    { id = "choice"
    , name = "Choice"
    , what = tc.What.Class_
    , vars = [ "p" ]
    , parents = [ "profunctor" ]
    , info = "Extends Profunctor with combinators for working with sum types"
    , module = [ "Data", "Profunctor" ]
    , package = "purescript-profunctor"
    , link = "purescript-profunctor/5.0.0/docs/Data.Profunctor.Choice"
    , members =
        [
            { name = "left"
            , def =
                e.fn2
                    (e.ap3 (e.t "p") (e.n "a") (e.n "b"))
                    (e.ap3 (e.t "p") (e.br (e.class "Either" [ e.n "a", e.n "c" ])) (e.br (e.class "Either" [ e.n "b", e.n "c" ])))
                -- p a b -> p (Either a c) (Either b c)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "right"
            , def =
                e.fn2
                    (e.ap3 (e.t "p") (e.n "a") (e.n "b"))
                    (e.ap3 (e.t "p") (e.br (e.class "Either" [ e.n "a", e.n "b" ])) (e.br (e.class "Either" [ e.n "a", e.n "c" ])))
                --  p b c -> p (Either a b) (Either a c)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "splitChoice"
            , def =
                e.reqseq
                    [ e.class1 "Category" (e.t "p"), e.subj1 "Choice" (e.t "p") ]
                    (e.fn3
                        (e.ap3 (e.t "p") (e.n "a") (e.n "b"))
                        (e.ap3 (e.t "p") (e.n "c") (e.n "d"))
                        (e.ap3 (e.t "p") (e.br (e.class "Either" [ e.n "a", e.n "c" ])) (e.br (e.class "Either" [ e.n "a", e.n "d" ])))
                    )
                -- Category p => Choice p => p a b -> p c d -> p (Either a c) (Either b d)
            , belongs = tc.Belongs.No
            , op = Some "+++"
            , opEmoji = tc.noOp
            , laws =
                [
                    { law = "for function"
                    , examples =
                        [ tc.of
                            { fact =
                                e.opdef1 "+++"
                                    (e.fn
                                        [ e.br (e.fn2 (e.n "a") (e.n "b"))
                                        , e.br (e.fn2 (e.n "c") (e.n "d"))
                                        , e.br (e.class "Either" [ e.n "a", e.n "c" ])
                                        , e.br (e.class "Either" [ e.n "b", e.n "d" ])
                                        ]
                                    )
                                    -- (+++) :: (a -> b) -> (c -> d) -> (Either a c) -> (Either b d)
                            }
                        ]
                    }
                ]
            }
        ,
            { name = "fanin"
            , def =
                e.reqseq
                    [ e.class1 "Category" (e.t "p"), e.subj1 "Choice" (e.t "p") ]
                    (e.fn3
                        (e.ap3 (e.t "p") (e.n "a") (e.n "c"))
                        (e.ap3 (e.t "p") (e.n "b") (e.n "c"))
                        (e.ap3 (e.t "p") (e.br (e.class "Either" [ e.n "a", e.n "b" ])) (e.n "c"))
                    )
                -- Category p => Choice p => p a c -> p b c -> p (Either a b) c
            , belongs = tc.Belongs.No
            , op = Some "|||"
            , opEmoji = tc.noOp
            , laws =
                [
                    { law = "for function"
                    , examples =
                        [ tc.of
                            { fact =
                                e.opdef1 "|||"
                                    (e.fn
                                        [ e.br (e.fn2 (e.n "a") (e.n "c"))
                                        , e.br (e.fn2 (e.n "b") (e.n "c"))
                                        , e.class "Either" [ e.n "a", e.n "b" ]
                                        , e.n "c"
                                        ]
                                    )
                                -- (|||) :: (a -> c) -> (b -> c) -> Either a b -> c
                            }
                        ]
                    }
                ]
            }
        ]
    , instances =
        [ i.instance "Function" "Choice"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in choice