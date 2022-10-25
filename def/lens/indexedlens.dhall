let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- type IndexedLens i s t a b = forall p. Strong p => IndexedOptic p i s t a b

let cexpr =
    e.req1
        (e.class1 "Strong" (e.n "p"))
        (e.class "IndexedOptic" [ e.n "p", e.n "i", e.n "s", e.n "t", e.n "a", e.n "b" ] )
    -- Strong p => IndexedOptic p i s t a b

let indexedlens : tc.TClass =
    { id = "indexedlens"
    , name = "IndexedLens"
    , what = tc.What.Type_
    , vars = [ "i", "s", "t", "a", "b" ]
    , info = "An indexed lens."
    , module = [ "Data", "Lens", "Lens" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Lens"
    , spec = d.t (d.id "indexedlens") "IndexedLens" [ d.v "i", d.v "s", d.v "t", d.v "a", d.v "b" ] cexpr
    , members =
        [
            { name = "IndexedLens"
            , def = cexpr
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "IndexedLens'"
            , def =
                e.opc2
                    (e.class "IndexedLens'" [ e.n "i", e.n "s", e.n "a" ])
                    "="
                    (e.class "IndexedLens" [ e.n "i", e.n "s", e.n "s", e.n "a", e.n "a" ])
                -- type IndexedLens' i s a = IndexedLens i s s a a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in indexedlens