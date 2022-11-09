let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- type APrism s t a b = Optic (Market a b) s t a b

let cexpr =
    e.class "Optic" [ e.br (e.class "Market" [ e.n "a", e.n "b" ]), e.n "s", e.n "t", e.n "a", e.n "b" ]
    -- Optic (Market a b) s t a b

let aprism : tc.TClass =
    { spec = d.t (d.id "aprism") "APrism" [ d.v "s", d.v "t", d.v "a", d.v "b" ] cexpr
    , info = "A prism defined in terms of Market"
    , module = [ "Data", "Lens", "Prism" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , members =
        [
            { name = "APrism"
            , def = cexpr
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "APrism'"
            , def =
                e.opc2
                    (e.class "APrism'" [ e.n "s", e.n "a" ])
                    "="
                    (e.class "Prism" [ e.n "s", e.n "s", e.n "a", e.n "a" ])
                -- APrism' s a = APrism s s a a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.aw /\ tc.noInstances /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in aprism