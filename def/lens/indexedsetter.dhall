let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- type IndexedSetter i s t a b = IndexedOptic Function i s t a b

let cexpr = e.class "IndexedOptic" [ e.classE "Function", e.n "i", e.n "s", e.n "t", e.n "a", e.n "b" ]
                -- IndexedOptic Function i s t a b

let indexedsetter : tc.TClass =
    { spec = d.t (d.id "indexedsetter") "IndexedSetter" [ d.v "i", d.v "s", d.v "t", d.v "a", d.v "b" ] cexpr
    , info = "An indexed setter."
    , module = [ "Data", "Lens", "Setter" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , members =
        [
            { name = "IndexedSetter"
            , def = cexpr
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.aw /\ tc.noInstances /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in indexedsetter