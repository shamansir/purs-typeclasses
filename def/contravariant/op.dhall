let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../typedef.dhall
let e = ./../../build_expr.dhall

-- newtype Op a b

let op : tc.TClass =
    { id = "op"
    , name = "Op"
    , what = tc.What.Newtype_
    , vars = [ "a", "b" ]
    , info = "The opposite of the function category"
    , module = [ "Data" ]
    , package = tc.pkmj "purescript-contravariant" +3
    , link = "purescript-contravariant/3.0.0/docs/Data.Equivalence"
    , def = d.nt (d.id "op") "Op" [ d.v "a", d.v "b" ]
    , members =
        [
            { name = "Op"
            , def =
                -- Op (b -> a)
                e.subj1 "Op" (e.fn2 (e.n "b") (e.n "a"))
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "defaultEquivalence"
            , def =
                -- Eq a => Equivalence a
                e.req1
                    (e.class1 "Eq" (e.n "a"))
                    (e.subj1 "Equivalence" (e.n "a"))
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "comparisonEquivalence"
            , def =
                -- Comparison a -> Equivalence a
                e.fn2
                    (e.class1 "Comparison" (e.n "a"))
                    (e.class1 "Equivalence" (e.n "a"))
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceAB_ "Newtype" "Op"
        , i.instance "Semigroupoid" "Op"
        , i.instance "Category" "Op"
        , i.instanceA "Contravariant" "Op"
        ]
    } /\ tc.noLaws /\ tc.noParents /\ tc.noValues /\ tc.noStatements

in op