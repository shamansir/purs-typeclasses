let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../typedef.dhall
let e = ./../../build_expr.dhall

-- type AnIso s t a b = Optic (Exchange a b) s t a b

let cexpr =
    e.class "Optic" [ e.br (e.class "Exchange" [ e.n "a", e.n "b"]), e.n "s", e.n "t", e.n "a", e.n "b" ]
    -- Optic (Exchange a b) s t a b

let aniso : tc.TClass =
    { id = "aniso"
    , name = "AnIso"
    , what = tc.What.Type_
    , vars = [ "s", "t", "a", "b" ]
    , info = "An isomorphism defined in terms of Exchange"
    , module = [ "Data", "Lens" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens"
    , def = d.t (d.id "aniso") "AnIso" [ d.v "s", d.v "t", d.v "a", d.v "b" ] cexpr
    , members =
        [
            { name = "AnIso"
            , def = cexpr
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "AnIso'"
            , def =
                e.opc2
                    (e.class "AnIso'" [ e.n "s", e.n "a" ])
                    "="
                    (e.class "AnIso" [ e.n "s", e.n "s", e.n "a", e.n "a" ])
                -- type Iso' s a = Iso s s a a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in aniso