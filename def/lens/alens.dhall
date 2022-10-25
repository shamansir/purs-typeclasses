let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- type ALens s t a b = Optic (Shop a b) s t a b

let cexpr =
    e.class "Optic"
        [ e.br (e.class "Shop" [ e.n "a", e.n "b" ])
        , e.n "s", e.n "t", e.n "a", e.n "b"
        ]
                -- Optic (Shop a b) s t a b

let alens : tc.TClass =
    { id = "alens"
    , name = "ALens"
    , what = tc.What.Type_
    , vars = [ "i", "s", "t", "a", "b" ]
    , info = "A lens defined in terms of Shop."
    , module = [ "Data", "Lens", "Lens" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Lens"
    , spec = d.t (d.id "alens") "ALens" [ d.v "i", d.v "s", d.v "t", d.v "a", d.v "b" ] cexpr
    , members =
        [
            { name = "ALens"
            , def = cexpr
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "ALens'"
            , def =
                e.opc2
                    (e.class "ALens'" [ e.n "s", e.n "a" ])
                    "="
                    (e.class "ALens" [ e.n "s", e.n "s", e.n "a", e.n "a" ])
                -- type ALens' s a = ALens s s a a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples

        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in alens