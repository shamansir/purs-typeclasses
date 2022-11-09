let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- type AGetter s t a b = Fold a s t a b

let cexpr = e.class "Fold" [ e.n "a", e.n "s", e.n "t", e.n "a", e.n "b" ] -- Fold a s t a b

let agetter : tc.TClass =
    { spec = d.t (d.id "agetter") "AGetter" [ d.v "s", d.v "t", d.v "a", d.v "b" ] cexpr
    , info = "A getter."
    , module = [ "Data", "Lens", "Getter" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , members =
        [
            { name = "AGetter"
            , def = cexpr
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.aw /\ tc.noInstances /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in agetter