let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- type IndexedSetter i s t a b = IndexedOptic Function i s t a b

let indexedsetter : tc.TClass =
    { id = "indexedsetter"
    , name = "IndexedSetter"
    , what = tc.What.Type_
    , vars = [ "i", "s", "t", "a", "b" ]
    , info = "An indexed setter."
    , module = [ "Data", "Lens", "Setter" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Setter"
    , members =
        [
            { name = "IndexedSetter"
            , def = e.class "IndexedOptic" [ e.classE "Function", e.n "i", e.n "s", e.n "t", e.n "a", e.n "b" ]
                -- IndexedOptic Function i s t a b
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in indexedsetter