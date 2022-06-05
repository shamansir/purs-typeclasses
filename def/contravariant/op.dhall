let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

let op : tc.TClass =
    { id = "op"
    , name = "Op"
    , what = tc.What.Newtype_
    , vars = [ "a", "b" ]
    , info = "The opposite of the function category"
    , module = [ "Data" ]
    , package = "purescript-contravariant"
    , link = "purescript-contravariant/3.0.0/docs/Data.Equivalence"
    , members =
        [
            { name = "Op"
            , def =
                -- Op (b -> a)
                e.val
                    (e.subj_
                        "Op"
                        [ e.r
                            (e.fnvs
                                [ e.vf "b"
                                , e.vf "a"
                                ]
                            )
                        ]
                    )
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "defaultEquivalence"
            , def =
                -- Eq a => Equivalence a
                e.req1
                    (e.class_ "Eq" [ e.n "a" ])
                    (e.subj_ "Equivalence" [ e.n "a" ])
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "comparisonEquivalence"
            , def =
                -- Comparison a -> Equivalence a
                e.ap
                    (e.class_ "Comparison" [ e.n "a" ])
                    (e.subj_ "Equivalence" [ e.n "a" ])
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceAB_ "Newtype" "Op"
        , i.instance "Semigroupoid" "Op"
        , i.instance "Category" "Op"
        , i.instanceA "Contravariant" "Op"
        ]
    } /\ tc.noLaws /\ tc.noParents /\ tc.noValues /\ tc.noStatements

in op