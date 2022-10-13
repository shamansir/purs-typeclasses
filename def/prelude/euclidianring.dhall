let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let euclidianRing : tc.TClass =
    { id = "euclidianring"
    , name = "EuclidianRing"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , parents = [ "commutativering" ]
    , info = "Divide and Conquer"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Data.EuclideanRing"
    , members =
        [
            { name = "degree"
            , def = e.fn2 (e.n "a") (e.classE "Int") -- a -> Int
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "div"
            , def =
                e.fn3 (e.n "a") (e.n "a") (e.n "a")
                -- a -> a -> a
            , belongs = tc.Belongs.Yes
            , op = Some "/"
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "mod"
            , def =
                e.fn3 (e.n "a") (e.n "a") (e.n "a")
                -- a -> a -> a
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "gcd"
            , def =
                e.reqseq
                    [ e.class1 "Eq" (e.n "a")
                    , e.subj1 "EuclideanRing" (e.n "a")
                    ]
                    (e.fn3 (e.n "a") (e.n "a") (e.n "a"))
                -- Eq a => EuclideanRing a => a -> a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "lcm"
            , def =
                e.reqseq
                    [ e.class1 "Eq" (e.n "a")
                    , e.subj1 "EuclideanRing" (e.n "a")
                    ]
                    (e.fn3 (e.n "a") (e.n "a") (e.n "a"))
                -- Eq a => EuclideanRing a => a -> a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , laws =
        [
            { law = "integral domain"
            , examples =
                [ tc.fc
                    { fact =
                        e.opc2
                            (e.br (e.opc2 (e.n "a") "/=" (e.num "0")))
                            "and"
                            (e.br (e.opc2 (e.n "a") "/=" (e.num "0")))
                        -- (a /= 0) and (b /= 0)
                    , conclusion =
                        e.opc2
                            (e.opc2 (e.n "a") "*" (e.n "a"))
                            "/="
                            (e.num "0")
                        -- a * b /= 0
                    }
                ]
            }
        ,
            { law = "multiplicative Euclidean function"
            , examples =
                [ tc.lrc
                    { right = e.n "a" -- a
                    , left =
                        e.opc3
                            (e.br (e.opc2 (e.n "a") "/" (e.n "b")))
                            "*"
                            (e.n "b")
                            "+"
                            (e.br (e.inf2 (e.n "a") "mod" (e.n "b")))
                            -- (a / b) * b + (a `mod` b)
                    , conditions =
                        [ e.opc2
                            (e.call1 "degree" (e.n "a"))
                            ">"
                            (e.num "0")
                            -- degree a > 0
                        , e.opc2
                                (e.call1 "degree" (e.n "a"))
                                "<="
                                (e.call1 "degree" (e.br (e.opc2 (e.n "a") "+" (e.n "b"))))
                            -- degree a <= degree (a * b)
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