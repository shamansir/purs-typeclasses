let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- newtype Predicate a

let predicate : tc.TClass =
    { spec = d.nt (d.id "predicate") "Predicate" [ d.v "a" ]
    , info = "An adaptor allowing >$< to map over the inputs of predicate"
    , module = [ "Data" ]
    , package = tc.pkmj "purescript-contravariant" +3
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
    } /\ tc.aw /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in predicate