let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall

let alternative : tc.TClass =
    { id = "alternative"
    , name = "Alternative"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , parents = [ "plus", "applicative" ]
    , info = "To have both Plus and Applicative"
    , module = [ "Control" ]
    , package = "purescript-control"
    , link = "purescript-control/5.0.0/docs/Control.Alternative#t:Alternative"
    , members =
        [
            { name = "guard"
            , def =
                --  Alternative m => Boolean -> m Unit
                e.req1
                    (e.subj1 "Alternative" (e.t "m"))
                    (e.fn2
                        (e.classE "Boolean")
                        (e.ap2 (e.t "m") (e.classE "Unit"))
                    )
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , laws =
        [
            { law = "distributivity"
            , examples =
                [ tc.lr
                    { left =
                        -- (f <|> g) <*> x
                        e.opc2
                            (e.br (e.opc2 (e.f "f") "<|>" (e.f "g")))
                            "<*>"
                            (e.n "x")
                    , right =
                        -- (f <*> x) <|> (g <*> x)
                        e.opc2
                            (e.br (e.opc2 (e.f "f") "<*>" (e.n "x")))
                            "<|>"
                            (e.br (e.opc2 (e.f "g") "<*>" (e.n "x")))
                    }
                ]
            }
        ,
            { law = "annihilation"
            , examples =
                [ tc.lr
                    { left =
                        -- empty <*> f
                        e.opc2
                            (e.callE "empty")
                            "<*>"
                            (e.f "f")
                    , right =
                        -- empty
                        e.callE "empty"
                    }
                ]
            }
        ]

    } /\ tc.noInstances /\ tc.noValues /\ tc.noStatements

in alternative