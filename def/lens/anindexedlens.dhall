let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- type AnIndexedLens i s t a b = IndexedOptic (Shop (Tuple i a) b) i s t a b

let anindexedlens : tc.TClass =
    { id = "anindexedlens"
    , name = "AnIndexedLens"
    , what = tc.What.Type_
    , vars = [ "i", "s", "t", "a", "b" ]
    , info = "An indexed lens defined in terms of Shop."
    , module = [ "Data", "Lens", "Lens" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Lens"
    , members =
        [
            { name = "AnIndexedLens"
            , def =
                e.class "IndexedOptic"
                    [ e.br (e.class "Shop" [ e.br (e.class "Tuple" [ e.n "i", e.n "a" ]), e.n "b" ])
                    , e.n "i", e.n "s", e.n "t", e.n "a", e.n "b"
                    ]
                -- IndexedOptic (Shop (Tuple i a) b) i s t a b
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
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in anindexedlens