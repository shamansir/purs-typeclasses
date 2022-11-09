let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- type Iso s t a b = forall p. Profunctor p => Optic p s t a b

let cexpr =
     e.fall1
        (e.av "p")
        (e.req1
            (e.class1 "Profunctor" (e.n "p"))
            (e.class "Optic" [ e.n "p", e.n "s", e.n "t", e.n "a", e.n "b" ] )
        )
    -- forall p. Profunctor p => Optic p s t a b

let iso : tc.TClass =
    { spec = d.t (d.id "iso") "Iso" [ d.v "s", d.v "t", d.v "a", d.v "b" ] cexpr
    , info = "A generalized isomorphism."
    , module = [ "Data", "Lens" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , members =
        [
            { name = "Iso"
            , def = cexpr
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "Iso'"
            , def =
                e.opc2
                    (e.class "Iso'" [ e.n "s", e.n "a" ])
                    "="
                    (e.class "Iso" [ e.n "s", e.n "s", e.n "a", e.n "a" ])
                -- type Iso' s a = Iso s s a a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.aw /\ tc.noInstances /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in iso