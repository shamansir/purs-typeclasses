let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- type IndexedTraversal i s t a b = forall p. Wander p => IndexedOptic p i s t a b


let cexpr =
    e.fall1
        (e.av "p")
        (e.req1
            (e.class1 "Wander" (e.n "p"))
            (e.class "IndexedOptic" [ e.n "p", e.n "i", e.n "s", e.n "t", e.n "a", e.n "b" ] )
        )
    -- forall p. Wander p => IndexedOptic p i s t a b

let indexedtraversal : tc.TClass =
    { spec = d.t (d.id "indexedtraversal") "IndexedTraversal" [ d.v "i", d.v "s", d.v "t", d.v "a", d.v "b" ] cexpr
    , info = "An indexed traversal."
    , module = [ "Data", "Lens", "Types" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , members =
        [
            { name = "IndexedTraversal"
            , def = cexpr
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "IndexedTraversal'"
            , def =
                e.opc2
                    (e.class "IndexedTraversal'" [ e.n "i", e.n "s", e.n "a" ])
                    "="
                    (e.class "IndexedTraversal" [ e.n "i", e.n "s", e.n "s", e.n "a", e.n "a" ])
                -- type IndexedTraversal' i s a = IndexedTraversal i s s a a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.aw /\ tc.noInstances /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in indexedtraversal