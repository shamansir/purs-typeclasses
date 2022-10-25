let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- newtype Predicate a

let predicate : tc.TClass =
    { id = "predicate"
    , name = "Predicate"
    , what = tc.What.Newtype_
    , vars = [ "a" ]
    , info = "An adaptor allowing >$< to map over the inputs of predicate"
    , module = [ "Data" ]
    , package = tc.pkmj "purescript-contravariant" +3
    , link = "purescript-contravariant/3.0.0/docs/Data.Predicate"
    , spec = d.nt (d.id "predicate") "Predicate" [ d.v "a" ]
    , members =
        [
            { name = "Predicate"
            , def =
                -- Predicate (a -> Boolean)
                e.subj1
                    "Predicate"
                    (e.fn2 (e.n "a") (e.classE "Boolean"))
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceA_ "Newtype" "Predicate"
        , i.instance "Contravariant" "predicate"
        ]
    } /\ tc.noLaws /\ tc.noParents /\ tc.noValues /\ tc.noStatements

in predicate