let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let monoid : tc.TClass =
    { id = "monoid"
    , name = "Monoid"
    , what = tc.What.Class_
    , vars = [ "m" ]
    , parents = [ "semigroup" ]
    , info = "Folding empty collection"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Monoid"
    , members =
        [
            { name = "mempty"
            , def = e.t "m" -- m
            , belongs = tc.Belongs.Yes
            , laws =
                [
                    { law = "associativity"
                    , examples =
                        [ tc.lmr
                            { left =
                                e.opc2
                                    (e.callE "mempty")
                                    "<>"
                                    (e.n "x")
                                -- mempty <> x
                            , middle =
                                e.opc2
                                    (e.n "x")
                                    "<>"
                                    (e.callE "mempty")
                                -- x <> mempty
                            , right =
                                e.ap3
                                    (e.n "x")
                                    (e.kw "forall")
                                    (e.n "x")
                                -- x forall x
                            }
                        ]
                    }
                ]
            } /\ tc.noOps
        ,
            { name = "power"
            , def =
                e.req1
                    (e.class1 "Monoid" (e.t "m"))
                    (e.fn3 (e.t "m") (e.classE "Int") (e.t "m"))
                -- Monoid m => m -> Int -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "guard"
            , def =
                e.req1
                    (e.class1 "Monoid" (e.t "m"))
                    (e.fn3 (e.classE "Boolean") (e.t "m") (e.t "m"))
                -- Monoid m => Boolean -> m -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceCl "Unit"
        , i.instanceCl "Ordering"
        , i.instanceCl "Number"
        , i.instanceCl "String"
        , i.instanceClA "Array"
        , i.instanceReqSubjArrow "Monoid"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in monoid