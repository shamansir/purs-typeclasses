let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- type Lens s t a b = forall p. Strong p => Optic p s t a b

let lens : tc.TClass =
    { id = "lens"
    , name = "Lens"
    , what = tc.What.Type_
    , vars = [ "s", "t", "a", "b" ]
    , info = "Given a type whose \"focus element\" always exists, a lens provides a convenient way to view, set, and transform that element."
    , module = [ "Data", "Lens" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens"
    , members =
        [
            { name = "Lens"
            , def =
                e.req1
                    (e.class1 "Strong" (e.n "p"))
                    (e.class "Optic" [ e.n "p", e.n "s", e.n "p", e.n "p", e.n "p" ] )
                -- Strong p => Optic p s t a b
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "Lens'"
            , def =
                e.opc2
                    (e.class "Lens'" [ e.n "s", e.n "a" ])
                    "="
                    (e.class "Lens" [ e.n "s", e.n "s", e.n "a", e.n "a" ])
                -- type Lens' s a = Lens s s a a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in lens