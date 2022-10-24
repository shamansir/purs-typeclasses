let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../typedef.dhall
let e = ./../../build_expr.dhall

-- type IndexedSetter i s t a b = IndexedOptic Function i s t a b

let cexpr = e.class "IndexedOptic" [ e.classE "Function", e.n "i", e.n "s", e.n "t", e.n "a", e.n "b" ]
                -- IndexedOptic Function i s t a b

let indexedsetter : tc.TClass =
    { id = "indexedsetter"
    , name = "IndexedSetter"
    , what = tc.What.Type_
    , vars = [ "i", "s", "t", "a", "b" ]
    , info = "An indexed setter."
    , module = [ "Data", "Lens", "Setter" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Setter"
    , def = d.t (d.id "indexedsetter") "IndexedSetter" [ d.v "i", d.v "s", d.v "t", d.v "a", d.v "b" ] cexpr
    , members =
        [
            { name = "IndexedSetter"
            , def = cexpr
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in indexedsetter