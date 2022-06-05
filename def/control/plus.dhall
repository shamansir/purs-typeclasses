let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

let plus : tc.TClass =
    { id = "plus"
    , name = "Plus"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , parents = [ "alt" ]
    , info = "Left and Right identity for Alt"
    , module = [ "Control" ]
    , package = "purescript-control"
    , link = "purescript-control/5.0.0/docs/Control.Plus"
    , members =
        [
            { name = "empty"
            , def = e.val (e.ap1_ (e.f "f") (e.n "a")) -- f a
            , belongs = tc.Belongs.Yes
            , laws =
                [
                    { law = "left identity"
                    , examples =
                        [ tc.lr
                            { left =
                                 -- empty <|> x
                                e.inf "<|>" (e.callE "empty") (e.vn "x")
                            , right =
                                -- x
                                e.var (e.n "x")
                            }
                        ]
                    }
                ,
                    { law = "right identity"
                    , examples =
                        [ tc.lr
                            { left =
                                -- x <|> empty
                                e.inf "<|>" (e.vn "x") (e.callE "empty")
                            , right =
                                -- x
                                e.var (e.n "x")
                            }
                        ]
                    }
                ,
                    { law = "annihilation"
                    , examples =
                        [ tc.lr
                            { left =
                                -- f <$> empty
                                e.inf "<$>" (e.vf "f") (e.callE "empty")
                            , right =
                                -- empty
                                e.val (e.callE "empty")
                            }
                        ]
                    }
                ]
            } /\ tc.noOps
        ]
    , instances =
        [ i.instanceCl "Array"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in plus