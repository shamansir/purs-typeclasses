let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- type IndexedGetter i s t a b = IndexedFold a i s t a b

let cexpr = e.class "IndexedFold" [ e.n "a", e.n "i", e.n "s", e.n "t", e.n "a", e.n "b" ]
        -- IndexedFold a i s t a b

let indexedgetter : tc.TClass =
    { id = "indexedgetter"
    , name = "IndexedGetter"
    , what = tc.What.Type_
    , vars = [ "i", "s", "t", "a", "b" ]
    , info = "An indexed getter."
    , module = [ "Data", "Lens", "Getter" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Getter"
    , spec = d.t (d.id "indexedfold") "IndexedFold" [ d.v "i", d.v "s", d.v "t", d.v "a", d.v "b" ] cexpr
    , members =
        [
            { name = "IndexedGetter"
            , def = cexpr
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in indexedgetter