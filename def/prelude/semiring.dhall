let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class Semiring a where

let semiRing : tc.TClass =
    { id = "semiring"
    , name = "Semiring"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , info = "Sum and Multiply (a.k.a. extended Monoid)"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Data.Semiring"
    , spec =
        d.class_v
            (d.id "semiring")
            "Semiring"
            [ d.v "a" ]
    , members =
        [
            { name = "add"
            , def = e.fn3 (e.n "a") (e.n "a") (e.n "a") -- a -> a -> a
            , belongs = tc.Belongs.Yes
            , op = Some "+"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "zero"
            , def = e.n "a" -- a
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "mul"
            , def = e.fn3 (e.n "a") (e.n "a") (e.n "a") -- a -> a -> a
            , belongs = tc.Belongs.Yes
            , op = Some "*"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "one"
            , def = e.n "a" -- a
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , laws =
        [
            { law = "associativity"
            , examples =
                [ tc.lr
                    { left =
                        e.opc2
                            (e.br (e.opc2 (e.n "a") "+" (e.n "b")))
                            "+"
                            (e.n "c")
                        -- (a + b) + c
                    , right =
                        e.opc2
                            (e.n "a")
                            "+"
                            (e.br (e.opc2 (e.n "b") "+" (e.n "c")))
                        -- a + (b + c)
                    }
                ]
            }
        ,
            { law = "identity"
            , examples =
                [ tc.lmr
                    { left = e.opc2 (e.callE "zero") "+" (e.n "a") -- zero + a
                    , middle = e.opc2 (e.n "a") "+" (e.callE "zero") -- a + zero
                    , right = e.n "a" -- a
                    }
                ]
            }
        ,
            { law = "commutative"
            , examples =
                [ tc.lr
                    { left = e.opc2 (e.n "a") "+" (e.n "b") -- a + b
                    , right = e.opc2 (e.n "b") "+" (e.n "a") -- b + a
                    }
                ]
            }
        ,
            { law = "associativity"
            , examples =
                [ tc.lr
                    { left =
                        e.opc2
                            (e.br (e.opc2 (e.n "a") "*" (e.n "b")))
                            "*"
                            (e.n "c")
                        -- (a * b) * c
                    , right =
                        e.opc2
                            (e.n "a")
                            "*"
                            (e.br (e.opc2 (e.n "b") "*" (e.n "c")))
                        -- a * (b * c)
                    }
                ]
            }
        ,
            { law = "identity"
            , examples =
                [ tc.lmr
                    { left = e.opc2 (e.callE "one") "*" (e.n "a")  -- one * a
                    , middle = e.opc2 (e.n "a") "*" (e.callE "one") -- a * one
                    , right = e.n "a" -- a
                    }
                ]
            }
        ,
            { law = "left distributivity"
            , examples =
                [ tc.lr
                    { left =
                        e.opc2
                            (e.n "a")
                            "*"
                            (e.br (e.opc2 (e.n "b") "+" (e.n "c")))
                        -- a * (b + c)
                    , right =
                        e.opc2
                            (e.br (e.opc2 (e.n "a") "*" (e.n "b")))
                            "+"
                            (e.br (e.opc2 (e.n "b") "*" (e.n "c")))
                        -- (a * b) + (a * c)
                    }
                ]
            }
        ,
            { law = "right distributivity"
            , examples =
                [ tc.lr
                    { left =
                        e.opc2
                            (e.n "a")
                            "+"
                            (e.br (e.opc2 (e.n "b") "*" (e.n "c")))
                        -- a + (b * c)
                    , right =
                        e.opc2
                            (e.br (e.opc2 (e.n "a") "*" (e.n "c")))
                            "+"
                            (e.br (e.opc2 (e.n "b") "*" (e.n "c")))
                        -- (a * c) + (b * c)
                    }
                ]
            }
        ,
            { law = "annihilation"
            , examples =
                [ tc.lmr
                    { left = e.opc2 (e.callE "zero") "*" (e.n "a")  -- zero * a
                    , middle = e.opc2 (e.n "a") "*" (e.callE "zero") -- a * zero
                    , right = e.callE "zero" -- zero
                    }
                ]
            }
        ]
    , instances =
        [ i.instanceCl "Int"
        , i.instanceCl "Number"
        , i.instanceReqSubjArrow "Semiring"
        ]

    } /\ tc.noParents /\ tc.noValues /\ tc.noStatements

in semiRing
