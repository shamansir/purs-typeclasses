let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let heytingAlgebra : tc.TClass =
    { id = "heytingalgebra"
    , name = "HeytingAlgebra"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , info = "Bounded lattices, boolean starters"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Data.HeytingAlgebra"
    , members =
        [
            { name = "ff"
            , def = e.n "a" -- a
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "tt"
            , def = e.n "a" -- a
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "implies"
            , def = e.fn3 (e.n "a") (e.n "a") (e.n "a") -- a -> a -> a
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "conj"
            , def = e.fn3 (e.n "a") (e.n "a") (e.n "a") -- a -> a -> a
            , belongs = tc.Belongs.Yes
            , op = Some "&&"
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "disj"
            , def = e.fn3 (e.n "a") (e.n "a") (e.n "a") -- a -> a -> a
            , belongs = tc.Belongs.Yes
            , op = Some "||"
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "not"
            , def = e.n "a" -- a
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ]
    , laws =
        [
            { law = "associativity"
            , examples =
                [ tc.lr
                    { left =
                        e.opc2 (e.n "a") "||" (e.br (e.opc2 (e.n "b") "||" (e.n "c")))
                        -- a || (b || c)
                    , right =
                        e.opc2 (e.br (e.opc2 (e.n "a") "||" (e.n "b"))) "||" (e.n "c")
                         -- (a || b) || c
                    }
                , tc.lr
                    { left =
                        e.opc2 (e.n "a") "&&" (e.br (e.opc2 (e.n "b") "&&" (e.n "c")))
                        -- a && (b && c)
                    , right =
                        e.opc2 (e.br (e.opc2 (e.n "a") "&&" (e.n "b"))) "&&" (e.n "c")
                        -- (a && b) && c
                    }
                ]
            }
        ,
            { law = "commutativity"
            , examples =
                [ tc.lr
                    { left = e.opc2 (e.n "a") "||" (e.n "b") -- a || b
                    , right = e.opc2 (e.n "b") "||" (e.n "a") -- b || a
                    }
                , tc.lr
                    { left = e.opc2 (e.n "a") "&&" (e.n "b") -- a && b
                    , right = e.opc2 (e.n "b") "&&" (e.n "a") -- b && a
                    }
                ]
            }
        ,
            { law = "absorption"
            , examples =
                [ tc.lr
                    { left = e.opc2 (e.n "a") "||" (e.br (e.opc2 (e.n "a") "&&" (e.n "b"))) -- a || (a && b)
                    , right = e.n "a" -- a
                    }
                , tc.lr
                    { left = e.opc2 (e.n "a") "&&" (e.n "a") -- a && a
                    , right = e.n "a" -- a
                    }
                ]
            }
        ,
            { law = "idempotent"
            , examples =
                [ tc.lr
                    { left = e.opc2 (e.n "a") "||" (e.n "a") -- a || a
                    , right = e.n "a" -- a
                    }
                , tc.lr
                    { left = e.opc2 (e.n "a") "&&" (e.br (e.opc2 (e.n "a") "||" (e.n "b"))) -- a && (a || b)
                    , right = e.n "a" -- a
                    }
                ]
            }
        ,
            { law = "identity"
            , examples =
                [ tc.lr
                    { left = e.opc2 (e.n "a") "||" (e.callE "ff") -- a || ff
                    , right = e.n "a" -- a
                    }
                , tc.lr
                    { left = e.opc2 (e.n "a") "&&" (e.callE "tt")  -- a && tt
                    , right = e.n "a" -- a
                    }
                ]
            }
        ,
            { law = "implication"
            , examples =
                [ tc.lr
                    { left = e.inf2 (e.n "a") "implies" (e.n "a") -- a `implies` a
                    , right = e.callE "tt" -- tt
                    }
                , tc.lr
                    { left =
                        e.opc2
                            (e.n "a")
                            "&&"
                            (e.br (e.inf2 (e.n "a") "implies" (e.n "b")))
                            -- a && (a `implies` b)
                    , right = e.opc2 (e.n "a") "&&" (e.n "b") -- a && b
                    }
                , tc.lr
                    { left =
                        e.opc2
                            (e.n "b")
                            "&&"
                            (e.br (e.inf2 (e.n "a") "implies" (e.n "b")))
                        -- b && (a `implies` b)
                    , right = e.n "b" -- b
                    }
                , tc.lr
                    { left =
                        e.inf2
                            (e.n "a")
                            "implies"
                            (e.br (e.opc2 (e.n "a") "&&" (e.n "b")))
                        -- a `implies` (b && c)
                    , right =
                        e.opc2
                            (e.br (e.inf2 (e.n "a") "implies" (e.n "b")))
                            "&&"
                            (e.br (e.inf2 (e.n "a") "implies" (e.n "c")))
                        -- (a `implies` b) && (a `implies` c)
                    }
                ]
            }
        ,
            { law = "complemented"
            , examples =
                [ tc.lr
                    { left = e.call1 "not" (e.n "a") -- not a
                    , right = e.inf2 (e.n "a") "implies" (e.callE "ff") -- a `implies` ff
                    }
                    ]
            }
        ]
    , instances =
        [ i.instanceCl "Boolean"
        , i.instanceCl "Unit"
        , i.instanceFn
        ]

    } /\ tc.noParents /\ tc.noValues /\ tc.noStatements

in heytingAlgebra