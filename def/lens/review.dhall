let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- type Review s t a b = Optic Tagged s t a b

let review : tc.TClass =
    { id = "review"
    , name = "Review"
    , what = tc.What.Type_
    , vars = [ "s", "t", "a", "b" ]
    , info = "A review."
    , module = [ "Data", "Lens", "Prism" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Prism"
    , members =
        [
            { name = "Review"
            , def =
                e.class "Optic" [ e.classE "Tagged", e.n "s", e.n "t", e.n "a", e.n "b" ]
                -- Optic Tagged s t a b
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "Review'"
            , def =
                e.opc2
                    (e.class "Review'" [ e.n "s", e.n "a" ])
                    "="
                    (e.class "Review" [ e.n "s", e.n "s", e.n "a", e.n "a" ])
                -- Review' s a = Review s s a a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in review