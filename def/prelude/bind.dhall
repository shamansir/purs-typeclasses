let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class Bind :: (Type -> Type) -> Constraint
-- class (Apply m) <= Bind m where

let bind : tc.TClass =
    { id = "bind"
    , name = "Bind"
    , what = tc.What.Class_
    , vars = [ "m" ]
    , parents = [ "apply" ]
    , info = "Compose computations"
    , module = [ "Control" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Control.Bind"
    , spec =
        d.class_vpc
            (d.id "bind")
            "Bind"
            [ d.v "m" ]
            [ d.p (d.id "apply") "Apply" [ d.v "f" ] ]
            d.t2c
    , members =
        [
            { name = "bind"
            , def =
                e.fn3
                    (e.ap2 (e.t "m") (e.n "a"))
                    (e.fn2 (e.n "a") (e.ap2 (e.t "m") (e.n "a")))
                    (e.ap2 (e.t "m") (e.n "b"))
                -- m a -> (a -> m b) -> m b
            , belongs = tc.Belongs.Yes
            , op = Some ">>="
            , opEmoji = Some "🎉"
            , laws =
                [
                    { law = "associativity"
                    , examples =
                        [ tc.lr
                            { left =
                                e.opc2 (e.br (e.opc2 (e.n "x") ">>=" (e.f "f"))) ">>=" (e.f "g")
                                -- (x >>= f) >>= g
                            , right =
                                e.opc2 (e.n "x") ">>=" (e.br (e.lbd1 (e.av "k") (e.opc2 (e.ap2 (e.f "f") (e.n "k")) ">>=" (e.f "g"))))
                                -- x >>= (\\k -> f k >>= g)
                            }
                        ]
                    }
                ]
            } /\ tc.noExamples
        ,
            { name = "bindFlipped"
            , def =
                e.req1
                    (e.subj1 "Bind" (e.t "m"))
                    (e.fn3
                        (e.br (e.fn2 (e.n "a") (e.ap2 (e.t "m") (e.n "b"))))
                        (e.ap2 (e.t "m") (e.n "a"))
                        (e.ap2 (e.t "m") (e.n "b"))
                    )
                -- Bind m => (a -> m b) -> m a -> m b
            , belongs = tc.Belongs.No
            , op = Some "==<<"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "join"
            , def =
                e.req1
                    (e.subj1 "Bind" (e.t "m"))
                    (e.fn2
                        (e.ap2 (e.t "m") (e.br (e.ap2 (e.t "m") (e.n "b"))))
                        (e.ap2 (e.t "m") (e.n "a"))
                    )
                -- Bind m => m (m a) -> m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "composeKleisli"
            , def =
                e.req1
                    (e.subj1 "Bind" (e.t "m"))
                    (e.fn
                        [ e.br (e.fn2 (e.n "a") (e.ap2 (e.t "m") (e.n "b")))
                        , e.br (e.fn2 (e.n "b") (e.ap2 (e.t "m") (e.n "c")))
                        , e.n "a"
                        , e.ap2 (e.t "m") (e.n "c")
                        ]
                    )
                -- Bind m => (a -> m b) -> (b -> m c) -> a -> m c
            , belongs = tc.Belongs.No
            , op = Some ">==>"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "composeKleisliFlipped"
            , def =
                e.req1
                    (e.subj1 "Bind" (e.t "m"))
                    (e.fn
                        [ e.br (e.fn2 (e.n "b") (e.ap2 (e.t "m") (e.n "c")))
                        , e.br (e.fn2 (e.n "a") (e.ap2 (e.t "m") (e.n "b")))
                        , e.n "a"
                        , e.ap2 (e.t "m") (e.n "c")
                        ]
                    )
                -- Bind m => (b -> m c) -> (a -> m b) -> a -> m c
            , belongs = tc.Belongs.No
            , op = Some "<==<"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "ifM"
            , def =
                e.req1
                    (e.subj1 "Bind" (e.t "m"))
                    (e.fn
                        [ e.ap2 (e.t "m") (e.classE "Boolean")
                        , e.ap2 (e.t "m") (e.n "a")
                        , e.ap2 (e.t "m") (e.n "a")
                        , e.ap2 (e.t "m") (e.n "a")
                        ]
                    )
                -- Bind m => m Boolean -> m a -> m a -> m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceCl "Array"
        , i.instanceArrowR
        ]

    } /\ tc.aw /\ tc.noLaws /\ tc.noValues /\ tc.noStatements
    : tc.TClass

in bind