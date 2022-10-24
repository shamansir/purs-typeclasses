let tc = ./../../typeclass.dhall
let d = ./../../typedef.dhall
let e = ./../../build_expr.dhall

-- class Comonad :: (Type -> Type) -> Constraint
-- class (Extend w) <= Comonad w where

let comonad : tc.TClass =
    { id = "comonad"
    , name = "Comonad"
    , what = tc.What.Class_
    , vars = [ "w" ]
    , parents = [ "extend" ]
    , info = "Comonad is the dual of Monad, and extract is the dual of pure"
    , module = [ "Control" ]
    , package = tc.pkmj "purescript-control" +5
    , link = "purescript-control/5.0.0/docs/Control.Comonad"
    , def =
        d.class_vpc
            (d.id "comonad")
            "Comonad"
            [ d.v "w" ]
            [ d.p (d.id "extend") "Extend" [ d.v "w" ] ]
            d.t2c
    , members =
        [
            { name = "extract"
            , def =
                 -- w a -> a
                e.fn2
                    (e.ap2 (e.t "w") (e.n "a"))
                    (e.n "a")
            , belongs = tc.Belongs.Yes
            , laws =
                [
                    { law = "left identity"
                    , examples =
                        [ tc.lr
                            { left =
                                -- extract <<== xs
                                e.opc2
                                    (e.callE "extract")
                                    "<<=="
                                    (e.n "xs")
                            , right =
                                 -- xs
                                e.n "xs"
                            }
                        ]
                    }
                ,
                    { law = "right identity"
                    , examples =
                        [ tc.lr
                            { left =
                                 -- extract (f <<== xs)
                                e.call1 "extract"
                                    (e.br (e.opc2 (e.f "f") "<<==" (e.n "xs")))
                            , right =
                                -- f xs
                                e.ap2 (e.f "f") (e.n "xs")
                            }
                        ]
                    }
                ]
            } /\ tc.noOps /\ tc.noExamples
        ]

    } /\ tc.noLaws /\ tc.noInstances /\ tc.noValues /\ tc.noStatements

in comonad