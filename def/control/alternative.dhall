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
                    (e.subj_ "Alternative" [ e.t "m" ])
                    (e.rtv
                        (e.fn
                            (e.classE "Boolean")
                            (e.ap_ (e.t "m") [ e.rv (e.classE "Unit") ])
                        )
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
                        e.inf "<*>"
                            (e.rtvbr (e.inf "<|>" (e.vf "f") (e.vf "g")))
                            (e.vn "x")
                    , right =
                        -- (f <*> x) <|> (g <*> x)
                        e.inf "<*>"
                            (e.rtvbr (e.inf "<*>" (e.vf "f") (e.vn "x")))
                            (e.rtvbr (e.inf "<*>" (e.vf "g") (e.vn "x")))
                    }
                ]
            }
        ,
            { law = "annihilation"
            , examples =
                [ tc.lr
                    { left =
                        -- empty <*> f
                        e.inf
                            "<*>"
                            (e.callE "empty")
                            (e.vf "f")
                    , right =
                        -- empty
                        e.val (e.callE "empty")
                    }
                ]
            }
        ]

    } /\ tc.noInstances /\ tc.noValues /\ tc.noStatements

in alternative