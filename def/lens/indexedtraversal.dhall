let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- type IndexedTraversal i s t a b = forall p. Wander p => IndexedOptic p i s t a b


let indexedtraversal : tc.TClass =
    { id = "indexedtraversal"
    , name = "IndexedTraversal"
    , what = tc.What.Type_
    , vars = [ "i", "s", "t", "a", "b" ]
    , info = "An indexed traversal."
    , module = [ "Data", "Lens", "Types" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Types"
    , members =
        [
            { name = "IndexedTraversal"
            , def =
                e.fall1
                    (e.av "p")
                    (e.req1
                        (e.class1 "Wander" (e.n "p"))
                        (e.class "IndexedOptic" [ e.n "p", e.n "i", e.n "s", e.n "t", e.n "a", e.n "b" ] )
                    )
                -- forall p. Wander p => IndexedOptic p i s t a b
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
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in indexedtraversal