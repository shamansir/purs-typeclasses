let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- type Fold r s t a b = Optic (Forget r) s t a b

let cexpr =
    e.class "Optic" [ e.br (e.class1 "Forget" (e.n "r")), e.n "s", e.n "t", e.n "a", e.n "b" ]
    -- Optic (Forget r) s t a b

let fold : tc.TClass =
    { id = "fold"
    , name = "Fold"
    , what = tc.What.Type_
    , vars = [ "r", "s", "t", "a", "b" ]
    , info = "Given a type whose \"focus element\" always exists, a lens provides a convenient way to view, set, and transform that element."
    , module = [ "Data", "Lens" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens"
    , spec = d.t (d.id "fold") "Fold" [ d.v "r", d.v "s", d.v "t", d.v "a", d.v "b" ] cexpr
    , members =
        [
            { name = "Fold"
            , def = cexpr
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