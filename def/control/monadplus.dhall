let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

let monadplus : tc.TClass =
    { id = "monadplus"
    , name = "MonadPlus"
    , what = tc.What.Class_
    , vars = [ "m" ]
    , info = "Distributivity for Monads"
    , parents = [ "monad", "alternative" ]
    , module = [ "Control" ]
    , package = "purescript-control"
    , link = "purescript-control/5.0.0/docs/Control.MonadPlus"
    , laws =
        [
            { law = "distributivity"
            , examples =
                [ tc.lr
                    { left =
                        -- (x <|> y) >>= f
                        e.inf ">>="
                            (e.rtvbr (e.inf "<|>" (e.vn "x") (e.vn "y")))
                            (e.vf "f")
                    , right =
                        -- (f <*> x) <|> (g <*> x)
                        e.inf "<|>"
                            (e.rtvbr (e.inf ">>=" (e.vn "x") (e.vf "f")))
                            (e.rtvbr (e.inf ">>=" (e.vn "y") (e.vf "f")))
                    }
                ]
            }
        ]
    , instances =
        [ i.instanceCl "Array"
        ]

    } /\ tc.noValues /\ tc.noMembers /\ tc.noStatements

in monadplus