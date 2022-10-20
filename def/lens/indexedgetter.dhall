let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- type IndexedGetter i s t a b = IndexedFold a i s t a b

let indexedgetter : tc.TClass =
    { id = "indexedgetter"
    , name = "IndexedGetter"
    , what = tc.What.Type_
    , vars = [ "i", "s", "t", "a", "b" ]
    , info = "An indexed getter."
    , module = [ "Data", "Lens", "Getter" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Getter"
    , members =
        [
            { name = "IndexedGetter"
            , def = e.class "IndexedFold" [ e.n "a", e.n "i", e.n "s", e.n "t", e.n "a", e.n "b" ]
                -- IndexedFold a i s t a b
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in indexedgetter