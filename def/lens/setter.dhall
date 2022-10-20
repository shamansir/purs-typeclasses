let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- type Setter s t a b = Optic Function s t a b

let setter : tc.TClass =
    { id = "setter"
    , name = "Setter"
    , what = tc.What.Type_
    , vars = [ "s", "t", "a", "b" ]
    , info = "A setter."
    , module = [ "Data", "Lens", "Setter" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Setter"
    , members =
        [
            { name = "Lens"
            , def = e.class "Optic" [ e.classE "Function", e.n "s", e.n "t", e.n "a", e.n "b" ]
                -- Optic Function s t a b
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "Setter'"
            , def =
                e.opc2
                    (e.class "Setter'" [ e.n "s", e.n "a" ])
                    "="
                    (e.class "Setter" [ e.n "s", e.n "s", e.n "a", e.n "a" ])
                -- type Setter' s a = Setter s s a a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in setter