let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../typedef.dhall
let e = ./../../build_expr.dhall

-- newtype Comparison a

let comparison : tc.TClass =
    { id = "comparison"
    , name = "Comparison"
    , what = tc.What.Newtype_
    , vars = [ "a" ]
    , info = "An adaptor allowing >$< to map over the inputs of a comparison function"
    , module = [ "Data" ]
    , package = tc.pkmj "purescript-contravariant" +3
    , link = "purescript-contravariant/3.0.0/docs/Data.Comparison"
    , def = d.nt (d.id "comparison") "Comparison" [ d.v "a" ]
    , members =
        [
            { name = "Comparison"
            , def =
                -- Comparison (a -> a -> Ordering)
                e.subj1 "Comparison" (e.br (e.fn [ e.n "a", e.n "a", e.classE "Ordering" ]))
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "defaultComparison"
            , def =
                -- Ord a => Comparison a
                e.req1
                    (e.class1 "Ord" (e.n "a"))
                    (e.subj1 "Comparison" (e.n "a"))
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceA_ "Newtype" "Comparison"
        , i.instance "Contravariant" "Comparison"
        , i.instanceA "Semigroup" "Comparison"
        , i.instanceA "Monoid" "Comparison"
        ]
    } /\ tc.noLaws /\ tc.noParents /\ tc.noValues /\ tc.noStatements

in comparison