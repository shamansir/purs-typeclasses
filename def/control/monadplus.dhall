let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- class MonadPlus :: (Type -> Type) -> Constraint
-- class (Monad m, Alternative m) <= MonadPlus m

let monadplus : tc.TClass =
    { id = "monadplus"
    , name = "MonadPlus"
    , what = tc.What.Class_
    , vars = [ "m" ]
    , info = "Distributivity for Monads"
    , parents = [ "monad", "alternative" ]
    , module = [ "Control" ]
    , package = tc.pkmj "purescript-control" +5
    , link = "purescript-control/5.0.0/docs/Control.MonadPlus"
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

    } /\ tc.noValues /\ tc.noMembers /\ tc.noStatements

in monadplus