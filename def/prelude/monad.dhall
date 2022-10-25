let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class Monad :: (Type -> Type) -> Constraint
-- class (Applicative m, Bind m) <= Monad m

let monad : tc.TClass =
    { id = "monad"
    , name = "Monad"
    , what = tc.What.Class_
    , vars = [ "m" ]
    , parents = [ "bind", "applicative" ]
    , info = "Compose computations"
    , module = [ "Control" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Control.Monad"
    , spec =
        d.class_vpc
            (d.id "monad")
            "Monad"
            [ d.v "m" ]
            [ d.p (d.id "applicative") "Applicative" [ d.v "m" ]
            , d.p (d.id "bind") "Bind" [ d.v "m" ]
            ]
            d.t2c
    , laws =
        [
            { law = "left identity"
            , examples =
                [ tc.lr
                    { left =
                        e.opc2
                            (e.call1 "pure" (e.n "x"))
                            ">>="
                            (e.f "f")
                        -- pure x >>= f
                    , right = e.ap2 (e.f "f") (e.n "x") -- f x
                    }
                ]
            }
        ,
            { law = "right identity"
            , examples =
                [ tc.lr
                    { left = e.opc2 (e.n "x") ">>=" (e.callE "pure") -- x >>= pure
                    , right = e.n "x" -- x
                    }
                ]
            }
        ]
    , members =
        [
            { name = "liftM1"
            , def =
                e.req1
                    (e.subj1 "Monad" (e.t "m"))
                    (e.fn3
                        (e.br (e.fn2 (e.n "a") (e.n "b")))
                        (e.ap2 (e.t "m") (e.n "a"))
                        (e.ap2 (e.t "m") (e.n "b"))
                    )
                -- Monad m => (a -> b) -> m a -> m b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "ap"
            , def =
                e.req1
                    (e.subj1 "Monad" (e.t "m"))
                    (e.fn3
                        (e.ap2 (e.t "m") (e.br (e.fn2 (e.n "a") (e.n "b"))))
                        (e.ap2 (e.t "m") (e.n "a"))
                        (e.ap2 (e.t "m") (e.n "b"))
                    )
            -- Monad m => m (a -> b) -> m a -> m b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "whenM"
            , def =
                e.req1
                    (e.subj1 "Monad" (e.t "m"))
                    (e.fn3
                        (e.ap2 (e.t "m") (e.classE "Boolean"))
                        (e.ap2 (e.t "m") (e.classE "Unit"))
                        (e.ap2 (e.t "m") (e.classE "Unit"))
                    )
            -- Monad m => m Boolean -> m Unit -> m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "unlessM"
            , def =
                e.req1
                    (e.subj1 "Monad" (e.t "m"))
                    (e.fn3
                        (e.ap2 (e.t "m") (e.classE "Boolean"))
                        (e.ap2 (e.t "m") (e.classE "Unit"))
                        (e.ap2 (e.t "m") (e.classE "Unit"))
                    )
            -- Monad m => m Boolean -> m Unit -> m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceArrowR
        , i.instanceCl "Array"
        ]

    } /\ tc.noValues /\ tc.noStatements

in monad