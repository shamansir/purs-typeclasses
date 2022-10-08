let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

let comparison : tc.TClass =
    { id = "comparison"
    , name = "Comparison"
    , what = tc.What.Newtype_
    , vars = [ "a" ]
    , info = "An adaptor allowing >$< to map over the inputs of a comparison function"
    , module = [ "Data" ]
    , package = "purescript-contravariant"
    , link = "purescript-contravariant/3.0.0/docs/Data.Comparison"
    , members =
        [
            { name = "Comparison"
            , def =
                -- Comparison (a -> a -> Ordering)
                e.subj1 "Comparison" (e.br (e.fn [ e.n "a", e.n "a", e.classE "Ordering" ]))
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "defaultComparison"
            , def =
                -- Ord a => Comparison a
                e.req1
                    (e.class1 "Ord" (e.n "a"))
                    (e.subj1 "Comparison" (e.n "a"))
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceA_ "Newtype" "Comparison"
        , i.instance "Contravariant" "Comparison"
        , i.instanceA "Semigroup" "Comparison"
        , i.instanceA "Monoid" "Comparison"
        ]
    } /\ tc.noLaws /\ tc.noParents /\ tc.noValues /\ tc.noStatements

in comparison