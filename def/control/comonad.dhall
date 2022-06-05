let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall

let comonad : tc.TClass =
    { id = "comonad"
    , name = "Comonad"
    , what = tc.What.Class_
    , vars = [ "w" ]
    , parents = [ "extend" ]
    , info = "Comonad is the dual of Monad, and extract is the dual of pure"
    , module = [ "Control" ]
    , package = "purescript-control"
    , link = "purescript-control/5.0.0/docs/Control.Comonad"
    , members =
        [
            { name = "extract"
            , def =
                 -- w a -> a
                e.fn
                    (e.ap1_ (e.t "w") (e.n "a"))
                    (e.vn "a")
            , belongs = tc.Belongs.Yes
            , laws =
                [
                    { law = "left identity"
                    , examples =
                        [ tc.lr
                            { left =
                                -- extract <<== xs
                                e.inf "<<=="
                                    (e.callE "extract")
                                    (e.vn "xs")
                            , right =
                                 -- xs
                                e.var (e.n "xs")
                            }
                        ]
                    }
                ,
                    { law = "right identity"
                    , examples =
                        [ tc.lr
                            { left =
                                 -- extract (f <<== xs)
                                e.val
                                    (e.call_ "extract"
                                        [ e.r (e.inf "<<==" (e.vf "f") (e.vn "xs"))
                                        ]
                                    )
                            , right =
                                -- f xs
                                e.val
                                    (e.ap1_ (e.f "f") (e.n "xs"))
                            }
                        ]
                    }
                ]
            } /\ tc.noOps
        ]

    } /\ tc.noLaws /\ tc.noInstances /\ tc.noValues /\ tc.noStatements

in comonad