let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- type AnAffineTraversal s t a b = Optic (Stall a b) s t a b

let cexpr = e.class "Optic" [ e.br (e.class "Stall" [ e.n "a", e.n "b" ]), e.n "s", e.n "t", e.n "a", e.n "b" ]
-- Optic (Stall a b) s t a b

let anaffinetraversal : tc.TClass =
    { spec = d.t (d.id "anaffinetraversal") "AnAffineTraversal" [ d.v "s", d.v "t", d.v "a", d.v "b" ] cexpr
    , info = "An affine traversal defined in terms of Stall, which can be used to avoid issues with impredicativity."
    , module = [ "Data", "Lens", "AffineTraversal" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , members =
        [
            { name = "AnAffineTraversal"
            , def = cexpr
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "AnAffineTraversal'"
            , def =
                e.opc2
                    (e.class "AnAffineTraversal'" [ e.n "s", e.n "a" ])
                    "="
                    (e.class "AnAffineTraversal" [ e.n "s", e.n "s", e.n "a", e.n "a" ])
                -- type AnAffineTraversal' s a = AnAffineTraversal s s a a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.aw /\ tc.noInstances /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in anaffinetraversal