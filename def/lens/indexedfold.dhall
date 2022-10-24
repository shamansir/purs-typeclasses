let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../typedef.dhall
let e = ./../../build_expr.dhall

-- type IndexedFold r i s t a b = IndexedOptic (Forget r) i s t a b

let cexpr =
    e.class "IndexedOptic" [ e.br (e.class1 "Forget" (e.n "r")), e.n "i", e.n "s", e.n "t", e.n "a", e.n "b" ]
    -- IndexedOptic (Forget r) i s t a b

let indexedfold : tc.TClass =
    { id = "indexedfold"
    , name = "IndexedFold"
    , what = tc.What.Type_
    , vars = [ "r", "i", "s", "t", "a", "b" ]
    , info = "An indexed fold."
    , module = [ "Data", "Lens", "Getter" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Getter"
    , def = d.t (d.id "indexedfold") "IndexedFold" [ d.v "r", d.v "i", d.v "s", d.v "t", d.v "a", d.v "b" ] cexpr
    , members =
        [
            { name = "IndexedFold"
            , def = cexpr
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in indexedfold