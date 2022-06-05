let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let euclidianRing : tc.TClass =
    { id = "euclidianring"
    , name = "EuclidianRing"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , parents = [ "commutativering" ]
    , info = "Divide and Conquer"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.EuclideanRing"
    , members =
        [
            { name = "degree"
            , def = "{{var:a}} {{op:->}} {{class:Int}}" -- a -> Int
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "div"
            , def = "{{var:a}} {{op:->}} {{var:a}} {{op:->}} {{var:a}}" -- a -> a -> a
            , belongs = tc.Belongs.Yes
            , op = Some "/"
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "mode"
            , def = "{{var:a}} {{op:->}} {{var:a}} {{op:->}} {{var:a}}" -- a -> a -> a
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "gcd"
            , def = "{{class:Eq}} {{var:a}} {{op:=>}} {{subj:EuclideanRing}} {{var:a}} {{op:=>}} {{var:a}} {{op:->}} {{var:a}} {{op:->}} {{var:a}}" -- Eq a => EuclideanRing a => a -> a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "lcm"
            , def = "{{class:Eq}} {{var:a}} {{op:=>}} {{subj:EuclideanRing}} {{var:a}} {{op:=>}} {{var:a}} {{op:->}} {{var:a}} {{op:->}} {{var:a}}" -- Eq a => EuclideanRing a => a -> a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , laws =
        [
            { law = "integral domain"
            , examples =
                [ tc.fc
                    { fact = "({{var:a}} {{op:/=}} {{val:0}}) {{method:and}} ({{var:b}} {{op:/=}} {{val:0}})" -- (a /= 0) and (b /= 0)
                    , conclusion = "{{var:a}} {{op:*}} {{var:b}} {{op:/=}} {{val:0}}" -- a * b /= 0
                    }
                ]
            }
        ,
            { law = "multiplicative Euclidean function"
            , examples =
                [ tc.lrc
                    { right = "{{var:a}}" -- a
                    , left = "({{var:a}} {{op:/}} {{var:b}}) {{op:*}} {{var:b}} {{op:+}} ({{var:a}} {{method:`mod`}} {{var:b}})" -- (a / b) * b + (a `mod` b)
                    , conditions =
                        [ "{{method:degree}} {{var:a}} {{op:>}} {{val:0}}" -- degree a > 0
                        , "{{method:degree}} {{var:a}} {{op:<=}} {{method:degree}} ({{var:a}} {{op:*}} {{var:b}})" -- degree a <= degree (a * b)
                        ]
                    }
                ]
            }
        ]
    , instances =
        [ i.instanceCl "Int"
        , i.instanceCl "Number"
        ]

    } /\ tc.noValues /\ tc.noStatements

in euclidianRing