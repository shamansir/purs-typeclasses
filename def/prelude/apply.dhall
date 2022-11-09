let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class Apply :: (Type -> Type) -> Constraint
-- class (Functor f) <= Apply f where

let apply : tc.TClass =
    { spec =
        d.class_vpc
            (d.id "apply")
            "Apply"
            [ d.v "f" ]
            [ d.p (d.id "functor") "Functor" [ d.v "f" ] ]
            d.t2c
    , info = "Unwrap, convert, and wrap again"
    , module = [ "Control" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , members =
        [
            { name = "apply"
            , def =
                e.fn3
                    (e.ap2 (e.f "f") (e.fn2 (e.n "a") (e.n "b")))
                    (e.ap2 (e.f "f") (e.n "a"))
                    (e.ap2 (e.f "f") (e.n "b"))
                -- f (a -> b) -> f a -> f b
            , op = Some "<*>"
            , opEmoji = Some "🚋"
            , belongs = tc.Belongs.Yes
            , laws =
                [
                    { law = "ap. composition"
                    , examples =
                        [ tc.lr
                            { left =
                                e.opc4 (e.op_fnE "<<<") "<$>" (e.f "f") "<*>" (e.f "g") "<*>" (e.f "h") -- (<<<) <$> f <*> g <*> h
                            , right =
                                e.opc2 (e.f "f") "<*>" (e.br (e.opc2 (e.f "g") "<*>" (e.f "h"))) -- f <*> (g <*> h)
                            }
                        ]
                    }
                ]
            } /\ tc.noExamples
        ,
            { name = "applyFirst"
            , def =
                e.req1
                    (e.subj1 "Apply" (e.f "f"))
                    (e.fn3
                        (e.ap2 (e.f "f") (e.n "a"))
                        (e.ap2 (e.f "f") (e.n "b"))
                        (e.ap2 (e.f "f") (e.n "a"))
                    )
                -- Apply f => f a -> f b -> f a
            , belongs = tc.Belongs.No
            , op = Some "<*"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "applySecond"
            , def =
                e.req1
                    (e.subj1 "Apply" (e.f "f"))
                    (e.fn3
                        (e.ap2 (e.f "f") (e.n "a"))
                        (e.ap2 (e.f "f") (e.n "b"))
                        (e.ap2 (e.f "f") (e.n "b"))
                    )
                -- Apply f => f a -> f b -> f b
            , belongs = tc.Belongs.No
            , op = Some "*>"
            , opEmoji = Some "👉"
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "lift2"
            , def =
                e.req1
                    (e.subj1 "Apply" (e.f "f"))
                    (e.fn
                        [ e.br (e.fn3 (e.n "a") (e.n "b") (e.n "c"))
                        , e.ap2 (e.f "f") (e.n "a")
                        , e.ap2 (e.f "f") (e.n "b")
                        , e.ap2 (e.f "f") (e.n "c")
                        ]
                    )
                -- Apply f => (a -> b -> c) -> f a -> f b -> f c
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "lift3"
            , def =
                e.req1
                    (e.subj1 "Apply" (e.f "f"))
                    (e.fn
                        [ e.br (e.fn [ e.n "a", e.n "b", e.n "c", e.n "d" ])
                        , e.ap2 (e.f "f") (e.n "a")
                        , e.ap2 (e.f "f") (e.n "b")
                        , e.ap2 (e.f "f") (e.n "c")
                        , e.ap2 (e.f "f") (e.n "d")
                        ]
                    )
                -- Apply f => (a -> b -> c -> d) -> f a -> f b -> f c -> f d
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "lift4"
            , def =
                e.req1
                    (e.subj1 "Apply" (e.f "f"))
                    (e.fn
                        [ e.br (e.fn [ e.n "a", e.n "b", e.n "c", e.n "d", e.n "e" ])
                        , e.ap2 (e.f "f") (e.n "a")
                        , e.ap2 (e.f "f") (e.n "b")
                        , e.ap2 (e.f "f") (e.n "c")
                        , e.ap2 (e.f "f") (e.n "d")
                        , e.ap2 (e.f "f") (e.n "e")
                        ]
                    )
                -- Apply f => (a -> b -> c -> d -> e) -> f a -> f b -> f c -> f d -> f e
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "lift5"
            , def =
                e.req1
                    (e.subj1 "Apply" (e.f "f"))
                    (e.fn
                        [ e.br (e.fn [ e.n "a", e.n "b", e.n "c", e.n "d", e.n "e", e.n "g" ])
                        , e.ap2 (e.f "f") (e.n "a")
                        , e.ap2 (e.f "f") (e.n "b")
                        , e.ap2 (e.f "f") (e.n "c")
                        , e.ap2 (e.f "f") (e.n "d")
                        , e.ap2 (e.f "f") (e.n "e")
                        , e.ap2 (e.f "f") (e.n "g")
                        ]
                    )
                -- Apply f => (a -> b -> c -> d -> e -> g) -> f a -> f b -> f c -> f d -> f e -> f g
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceCl "Array"
        , i.instanceArrowR
        ]

    } /\ tc.aw /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in apply