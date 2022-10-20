let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- type AnAffineTraversal s t a b = Optic (Stall a b) s t a b

let anaffinetraversal : tc.TClass =
    { id = "anaffinetraversal"
    , name = "AnAffineTraversal"
    , what = tc.What.Type_
    , vars = [ "s", "t", "a", "b" ]
    , info = "An affine traversal defined in terms of Stall, which can be used to avoid issues with impredicativity."
    , module = [ "Data", "Lens", "AffineTraversal" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.AffineTraversal"
    , members =
        [
            { name = "AnAffineTraversal"
            , def =
                e.class "Optic" [ e.br (e.class "Stall" [ e.n "a", e.n "b" ]), e.n "s", e.n "t", e.n "a", e.n "b" ]
                -- type AnAffineTraversal s t a b = Optic (Stall a b) s t a b
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
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in anaffinetraversal