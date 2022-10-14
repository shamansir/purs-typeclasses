let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall


-- class (Eq a) <= Ord a where

let ord : tc.TClass =
    { id = "ord"
    , name = "Ord"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , parents = [ "eq" ]
    , info = "Ordering"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Data.Ord"
    , members =
        let ordA2B
            = e.req1
                (e.subj1 "Ord" (e.n "a"))
                (e.fn3 (e.n "a") (e.n "a") (e.classE "Boolean"))
            -- Ord a => a -> a -> Boolean
        let ordA3
            = e.req1
                (e.subj1 "Ord" (e.n "a"))
                (e.fn3 (e.n "a") (e.n "a") (e.n "a"))
            -- Ord a => a -> a -> a
        in
        [
            { name = "compare"
            , def = e.fn3 (e.n "a") (e.n "a") (e.classE "Ordering") -- a -> a -> Ordering
            , belongs = tc.Belongs.Yes
            , op = Some "=="
            , opEmoji = tc.noOp
            , laws =
                [
                    { law = "reflexivity"
                    , examples =
                        [ tc.of
                            { fact =
                                e.opc2 (e.n "a") "<=" (e.n "a") -- a <= a
                            }
                        ]
                    }
                ,
                    { law = "antisymmetry"
                    , examples =
                        [ tc.fc
                            { fact =
                                e.opc2
                                    (e.opc2 (e.n "a") "<=" (e.n "b"))
                                    "and" -- `and`?
                                    (e.opc2 (e.n "b") "<=" (e.n "a"))
                                -- (a <= b) and (b <= a)
                            , conclusion =
                                e.opc2 (e.n "a") "=" (e.n "b") -- a = b
                            }
                        ]
                    }
                ,
                    { law = "transitivity"
                    , examples =
                        [ tc.fc
                            { fact =
                                e.opc2
                                    (e.opc2 (e.n "a") "<=" (e.n "b"))
                                    "and" -- `and`?
                                    (e.opc2 (e.n "b") "<=" (e.n "c"))
                                -- (a <= b) and (b <= c)
                            , conclusion =
                                e.opc2 (e.n "a") "<=" (e.n "c") -- a <= c
                            }
                        ]
                    }
                ]
            } /\ tc.noExamples
        ,
            { name = "lessThan"
            , def = ordA2B -- Ord a => a -> a -> Boolean
            , belongs = tc.Belongs.No
            , op = Some "<"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "greaterThan"
            , def = ordA2B -- Ord a => a -> a -> Boolean
            , belongs = tc.Belongs.No
            , op = Some ">"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "lessThanOrEq"
            , def = ordA2B -- Ord a => a -> a -> Boolean
            , belongs = tc.Belongs.No
            , op = Some "<="
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "greaterThanOrEq"
            , def = ordA2B -- Ord a => a -> a -> Boolean
            , belongs = tc.Belongs.No
            , op = Some ">="
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "min"
            , def = ordA3 -- Ord a => a -> a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "max"
            , def = ordA3 -- Ord a => a -> a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "clamp"
            , def
                = e.req1
                    (e.subj1 "Ord" (e.n "a"))
                    (e.fn [ e.n "a", e.n "a", e.n "a", e.n "a" ])
                -- Ord a => a -> a -> a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "between"
            , def
                = e.req1
                    (e.subj1 "Ord" (e.n "a"))
                    (e.fn [ e.n "a", e.n "a", e.n "a", e.classE "Boolean" ])
                 -- Ord a => a -> a -> a -> Boolean
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "abs"
            , def
                = e.req
                    [ e.subj1 "Ord" (e.n "a"), e.subj1 "Ring" (e.n "a") ]
                    (e.fn2 (e.n "a") (e.n "a"))
                -- (Ord a, Ring a) => a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "signum"
            , def
                = e.req
                    [ e.subj1 "Ord" (e.n "a"), e.subj1 "Ring" (e.n "a") ]
                    (e.fn2 (e.n "a") (e.n "a"))
                -- (Ord a, Ring a) => a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "comparing"
            , def =
                e.req1
                    (e.subj1 "Ord" (e.n "b"))
                    (e.fn2
                        (e.br (e.fn2 (e.n "a") (e.n "b")))
                        (e.br (e.fn3 (e.n "a") (e.n "a") (e.classE "Ordering")))
                    )
                -- Ord b => (a -> b) -> (a -> a -> Ordering)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]

    } /\ tc.noInstances /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in ord
