let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class MonadPlus :: (Type -> Type) -> Constraint
-- class (Monad m, Alternative m) <= MonadPlus m

let monadplus : tc.TClass =
    { spec =
        d.class_vpc
            (d.id "monadplus")
            "MonadPlus"
            [ d.v "m" ]
            [ d.p (d.id "monad") "Monad" [ d.v "m" ]
            , d.p (d.id "alternative") "Alternative" [ d.v "m" ]
            ]
            d.t2c
    , info = "Distributivity for Monads"
    , module = [ "Control" ]
    , package = tc.pkmj "purescript-control" +5
    , laws =
        [
            { law = "distributivity"
            , examples =
                [ tc.lr
                    { left =
                        -- (x <|> y) >>= f
                        e.opc2
                            (e.br (e.opc2 (e.n "x") "<|>" (e.n "y")))
                            ">>="
                            (e.f "f")
                    , right =
                        -- (f <*> x) <|> (g <*> x)
                        e.opc2
                            (e.br (e.opc2 (e.f "f") "<*>" (e.n "x")))
                            "<|>"
                            (e.br (e.opc2 (e.f "g") "<*>" (e.n "x")))
                    }
                ]
            }
        ]
    , instances =
        [ i.instanceCl "Array"
        ]

    } /\ tc.aw /\ tc.noValues /\ tc.noMembers /\ tc.noStatements

in monadplus