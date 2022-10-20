let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- type Fold r s t a b = Optic (Forget r) s t a b

let fold : tc.TClass =
    { id = "fold"
    , name = "Fold"
    , what = tc.What.Type_
    , vars = [ "r", "s", "t", "a", "b" ]
    , info = "Given a type whose \"focus element\" always exists, a lens provides a convenient way to view, set, and transform that element."
    , module = [ "Data", "Lens" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens"
    , members =
        [
            { name = "Fold"
            , def =
                e.class "Optic" [ e.br (e.class1 "Forget" (e.n "r")), e.n "s", e.n "p", e.n "p", e.n "p" ]
                -- Optic (Forget r) s t a b
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "Fold'"
            , def =
                e.opc2
                    (e.class "Fold'" [ e.n "s", e.n "a" ])
                    "="
                    (e.class "Fold" [ e.n "r", e.n "s", e.n "s", e.n "a", e.n "a" ])
                -- type Fold' r s a = Fold r s s a a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in fold