let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- type Setter s t a b = Optic Function s t a b

let cexpr = e.class "Optic" [ e.classE "Function", e.n "s", e.n "t", e.n "a", e.n "b" ]
    -- Optic Function s t a b

let setter : tc.TClass =
    { spec = d.t (d.id "setter") "Setter" [ d.v "s", d.v "t", d.v "a", d.v "b" ] cexpr
    , info = "A setter."
    , module = [ "Data", "Lens", "Setter" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , members =
        [
            { name = "Lens"
            , def = cexpr
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
    } /\ tc.aw /\ tc.noInstances /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in setter