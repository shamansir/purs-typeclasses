let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- type AnIndexedLens i s t a b = IndexedOptic (Shop (Tuple i a) b) i s t a b

let cexpr =
    e.class "IndexedOptic"
        [ e.br (e.class "Shop" [ e.br (e.class "Tuple" [ e.n "i", e.n "a" ]), e.n "b" ])
        , e.n "i", e.n "s", e.n "t", e.n "a", e.n "b"
        ]
-- IndexedOptic (Shop (Tuple i a) b) i s t a b

let anindexedlens : tc.TClass =
    { spec = d.t (d.id "anindexedlens") "AnIndexedLens" [ d.v "i", d.v "s", d.v "t", d.v "a", d.v "b" ] cexpr
    , info = "An indexed lens defined in terms of Shop."
    , module = [ "Data", "Lens", "Lens" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , members =
        [
            { name = "AnIndexedLens"
            , def = cexpr
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "AnIndexedLens'"
            , def =
                e.opc2
                    (e.class "AnIndexedLens'" [ e.n "i", e.n "s", e.n "a" ])
                    "="
                    (e.class "AnIndexedLens" [ e.n "i", e.n "s", e.n "s", e.n "a", e.n "a" ])
                -- type AnIndexedLens' i s a = AnIndexedLens i s s a a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples

        ]
    } /\ tc.aw /\ tc.noInstances /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in anindexedlens