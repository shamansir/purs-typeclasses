let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

let equivalence : tc.TClass =
    { id = "equivalence"
    , name = "Equivalence"
    , what = tc.What.Newtype_
    , vars = [ "a" ]
    , info = "An adaptor allowing >$< to map over the inputs of an equivalence function"
    , module = [ "Data" ]
    , package = "purescript-contravariant"
    , link = "purescript-contravariant/3.0.0/docs/Data.Equivalence"
    , members =
        [
            { name = "Equivalence"
            , def =
                -- Equivalence (a -> a -> Boolean)
                e.subj1
                    "Equivalence"
                    (e.br (e.fn
                        [ e.n "a"
                        , e.n "a"
                        , e.classE "Boolean"
                        ]
                    ))
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "defaultEquivalence"
            , def =
                -- Eq a => Equivalence a
                e.req1
                    (e.class1 "Eq" (e.n "a"))
                    (e.subj1 "Equivalence" (e.n "a"))
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "comparisonEquivalence"
            , def =
                -- Comparison a -> Equivalence a
                e.ap2
                    (e.class1 "Comparison" (e.n "a"))
                    (e.subj1 "Equivalence" (e.n "a"))
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceA_ "Newtype" "Equivalence"
        , i.instance "Contravariant" "Equivalence"
        , i.instanceA "Semigroup" "Equivalence"
        , i.instanceA "Monoid" "Equivalence"
        ]
    } /\ tc.noLaws /\ tc.noParents /\ tc.noValues /\ tc.noStatements

in equivalence