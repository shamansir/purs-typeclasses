let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- type Prism s t a b = forall p. Choice p => Optic p s t a b

let prism : tc.TClass =
    { id = "prism"
    , name = "Prism"
    , what = tc.What.Type_
    , vars = [ "s", "t", "a", "b" ]
    , info = "A prism."
    , module = [ "Data", "Lens", "Prism" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Prism"
    , members =
        [
            { name = "Prism"
            , def =
                e.req1
                    (e.class1 "Choice" (e.n "p"))
                    (e.class "Optic" [ e.n "p", e.n "s", e.n "t", e.n "a", e.n "b" ] )
                -- Strong p => Optic p s t a b
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "Prism'"
            , def =
                e.opc2
                    (e.class "Prism'" [ e.n "s", e.n "a" ])
                    "="
                    (e.class "Prism" [ e.n "s", e.n "s", e.n "a", e.n "a" ])
                -- Prism' s a = Prism s s a a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in prism