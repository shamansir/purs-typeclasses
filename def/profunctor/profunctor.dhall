let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class Profunctor :: (Type -> Type -> Type) -> Constraint
-- class Profunctor p where

let profunctor : tc.TClass =
    { spec =
        d.class_vc
            (d.id "profunctor")
            "Profunctor"
            [ d.v "p" ]
            d.t3c
    , info = "Functor from the pair category"
    , module = [ "Data" ]
    , package = tc.pkmj "purescript-profunctor" +5
    , laws =
        [
            { law = "identity"
            , examples =
                [ tc.lr
                    { left =
                        e.call "dimap" [ e.callE "identity", e.callE "identity" ]
                        -- dimap identity identity
                    , right =
                        e.callE "identity"
                        -- identity
                    }
                ]
            }
        ,
            { law = "composition"
            , examples =
                [ tc.lr
                    { left =
                        e.opc2
                            (e.call "dimap" [ e.f "f1", e.f "f2" ])
                            "<<<"
                            (e.call "dimap" [ e.f "f2", e.f "g2" ])
                        -- dimap f1 g1 <<< dimap f2 g2
                    , right =
                        e.call
                            "dimap"
                            [ e.br (e.opc2 (e.f "f1") ">>>" (e.f "f2"))
                            , e.br (e.opc2 (e.f "g1") "<<<" (e.f "g2"))
                            ]
                        -- dimap (f1 >>> f2) (g1 <<< g2)
                    }
                ]
            }
        ]
    , members =
        [
            { name = "dimap"
            , def =
                e.fn
                    [ e.br (e.fn2 (e.n "a") (e.n "b"))
                    , e.br (e.fn2 (e.n "c") (e.n "d"))
                    , e.ap3 (e.t "b") (e.n "b") (e.n "c")
                    , e.ap3 (e.t "p") (e.n "a") (e.n "d")
                    ]
                 -- (a -> b) -> (c -> d) -> p b c -> p a d
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "lcmap"
            , def =
                e.req1
                    (e.subj1 "Profunctor" (e.t "p"))
                    (e.fn
                        [ e.br (e.fn2 (e.n "a") (e.n "b"))
                        , e.ap3 (e.t "b") (e.n "b") (e.n "c")
                        , e.ap3 (e.t "p") (e.n "a") (e.n "c")
                        ]
                    )
                -- Profunctor p => (a -> b) -> p b c -> p a c
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "rmap"
            , def =
                e.req1
                    (e.subj1 "Profunctor" (e.t "p"))
                    (e.fn
                        [ e.br (e.fn2 (e.n "b") (e.n "c"))
                        , e.ap3 (e.t "b") (e.n "a") (e.n "b")
                        , e.ap3 (e.t "p") (e.n "a") (e.n "c")
                        ]
                    )
                 -- Profunctor p => (b -> c) -> p a b -> p a c
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "arr"
            , def =
                e.reqseq
                    [ e.class1 "Category" (e.t "p"), e.subj1 "Profunctor" (e.t "p") ]
                    (e.fn2
                        (e.br (e.fn2 (e.n "a") (e.n "b")))
                        (e.ap3 (e.t "b") (e.n "a") (e.n "b"))
                    )
                -- Category p => Profunctor p => (a -> b) -> p a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "unwrapIso"
            , def =
                e.reqseq
                    [ e.subj1 "Profunctor" (e.t "p"), e.class "Newtype" [ e.t "t", e.n "a" ] ]
                    (e.fn2
                        (e.ap3 (e.t "p") (e.t "t") (e.t "t"))
                        (e.ap3 (e.t "p") (e.n "a") (e.n "a"))
                    )
                -- Profunctor p => Newtype t a => p t t -> p a a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "wrapIso"
            , def =
                e.reqseq
                    [ e.subj1 "Profunctor" (e.t "p"), e.class "Newtype" [ e.t "t", e.n "a" ] ]
                    (e.fn3
                        (e.br (e.fn2 (e.n "a") (e.n "t")))
                        (e.ap3 (e.t "p") (e.n "a") (e.n "a"))
                        (e.ap3 (e.t "p") (e.t "t") (e.t "t"))
                    )
                -- Profunctor p => Newtype t a => (a -> t) -> p a a -> p t t
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instance "Function" "Profunctor"
        ]

    } /\ tc.aw /\ tc.noValues /\ tc.noStatements

in profunctor