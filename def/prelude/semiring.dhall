let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let semiRing : tc.TClass =
    { id = "semiring"
    , name = "Semiring"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , info = "Sum and Multiply (a.k.a. extended Monoid)"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Semiring"
    , members =
        [
            { name = "add"
            , def = "{{var:a}} {{op:->}} {{var:a}} {{op:->}} {{var:a}}" -- a -> a -> a
            , belongs = tc.Belongs.Yes
            , op = Some "+"
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "zero"
            , def = "{{var:a}}" -- a
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "mul"
            , def = "{{var:a}} {{op:->}} {{var:a}} {{op:->}} {{var:a}}" -- a -> a -> a
            , belongs = tc.Belongs.Yes
            , op = Some "*"
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "one"
            , def = "{{var:a}}" -- a
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ]
    , laws =
        [
            { law = "associativity"
            , examples =
                [ tc.lr
                    { left = "({{var:a}} {{op:+}} {{var:b}}) {{op:+}} {{var:c}}" -- (a + b) + c
                    , right = "{{var:a}} {{op:+}} ({{var:b}} {{op:+}} {{var:c}})" -- a + (b + c)
                    }
                ]
            }
        ,
            { law = "identity"
            , examples =
                [ tc.lmr
                    { left = "{{method:zero}} {{op:+}} {{var:a}}" -- zero + a
                    , middle = "{{var:a}} {{op:+}} {{method:zero}}" -- a + zero
                    , right = "{{var:a}}" -- a
                    }
                ]
            }
        ,
            { law = "commutative"
            , examples =
                [ tc.lr
                    { left = "{{var:a}} {{op:+}} {{var:b}}" -- a + b
                    , right = "{{var:b}} {{op:+}} {{var:a}}" -- b + a
                    }
                ]
            }
        ,
            { law = "associativity"
            , examples =
                [ tc.lr
                    { left = "({{var:a}} {{op:+}} {{var:b}}) {{op:*}} {{var:c}}" -- (a + b) * c
                    , right = "{{var:a}} {{op:*}} ({{var:b}} {{op:*}} {{var:c}})" -- a * (b * c)
                    }
                ]
            }
        ,
            { law = "identity"
            , examples =
                [ tc.lmr
                    { left = "{{method:one}} {{op:*}} {{var:a}}" -- one * a
                    , middle = "{{var:a}} {{op:*}} {{method:one}}" -- a * one
                    , right = "{{var:a}}" -- a
                    }
                ]
            }
        ,
            { law = "left distributivity"
            , examples =
                [ tc.lr
                    { left = "{{var:a}} {{op:*}} ({{var:b}} {{op:+}} {{var:c}})" -- a * (b + c)
                    , right = "({{var:a}} {{op:*}} {{var:b}}) {{op:+}} ({{var:a}} {{op:*}} {{var:c}})" -- (a * b) + (a * c)
                    }
                ]
            }
        ,
            { law = "right distributivity"
            , examples =
                [ tc.lr
                    { left = "{{var:a}} {{op:+}} ({{var:b}} {{op:*}} {{var:c}})" -- a + (b * c)
                    , right = "({{var:a}} {{op:*}} {{var:c}}) {{op:+}} ({{var:b}} * {{var:c}})" -- (a * c) + (b * c)
                    }
                ]
            }
        ,
            { law = "annihilation"
            , examples =
                [ tc.lmr
                    { left = "{{method:zero}} {{op:*}} {{var:a}}" -- zero * a
                    , middle = "{{var:a}} {{op:*}} {{method:zero}}" -- a * zero
                    , right = "{{method:zero}}" -- zero
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
