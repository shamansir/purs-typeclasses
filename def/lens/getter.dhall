let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- type Getter s t a b = forall r. Fold r s t a b

let cexpr = e.fall1 (e.av "r") (e.class "Fold" [ e.n "r", e.n "s", e.n "t", e.n "a", e.n "b" ])
-- forall r. Fold r s t a b

let getter : tc.TClass =
    { spec = d.t (d.id "getter") "Getter" [ d.v "s", d.v "t", d.v "a", d.v "b" ] cexpr
    , info = "A getter."
    , module = [ "Data", "Lens", "Getter" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , members =
        [
            { name = "Getter"
            , def = cexpr

            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.aw /\ tc.noInstances /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in getter