let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- type Traversal s t a b = forall p. Wander p => Optic p s t a b


let cexpr =
     e.fall1
        (e.av "p")
        (e.req1
            (e.class1 "Wander" (e.n "p"))
            (e.class "Optic" [ e.n "p", e.n "s", e.n "t", e.n "a", e.n "b" ] )
        )
    -- forall p. Wander p => Optic p s t a b


let traversal : tc.TClass =
    { spec = d.t (d.id "traversal") "Traversal" [ d.v "s", d.v "t", d.v "a", d.v "b" ] cexpr
    , info = "An indexed traversal."
    , module = [ "Data", "Lens", "Types" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , members =
        [
            { name = "Traversal"
            , def = cexpr
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "Traversal'"
            , def =
                e.opc2
                    (e.class "Traversal'" [ e.n "s", e.n "a" ])
                    "="
                    (e.class "Traversal" [ e.n "s", e.n "s", e.n "a", e.n "a" ])
                -- type Traversal' s a = Traversal s s a a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.aw /\ tc.noInstances /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in traversal