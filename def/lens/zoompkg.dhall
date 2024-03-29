let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e_ = ./../../expr.dhall
let e = ./../../build_expr.dhall


let zoompkg : tc.TClass =
    { spec = d.pkg (d.id "zoompkg") "Lens.Zoom"
    , info = "Zooms into a substate in a StateT transformer"
    , module = [ "Data", "Lens", "Zoom" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , members =
        [
            { name = "zoom"
            , def =
                e.fn
                    [ e.class "Optic'"
                        [ e.br (e.class1 "Star" (e.br (e.class "Focusing" [ e.n "m", e.n "r" ]))), e.n "s", e.n "a" ]
                    , e.class "StateT" [ e.n "a", e.n "m", e.n "r" ]
                    , e.class "StateT" [ e.n "s", e.n "m", e.n "r" ]
                    ]
                -- Optic' (Star (Focusing m r)) s a -> StateT a m r -> StateT s m r
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.aw /\ tc.noInstances /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in zoompkg