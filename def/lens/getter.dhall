let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- type Getter s t a b = forall r. Fold r s t a b

let getter : tc.TClass =
    { id = "getter"
    , name = "Getter"
    , what = tc.What.Type_
    , vars = [ "s", "t", "a", "b" ]
    , info = "A getter."
    , module = [ "Data", "Lens", "Getter" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Getter"
    , members =
        [
            { name = "Getter"
            , def = e.fall1 (e.av "r") (e.class "Fold" [ e.n "r", e.n "s", e.n "t", e.n "a", e.n "b" ])
                -- forall r. Fold r s t a b
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in getter