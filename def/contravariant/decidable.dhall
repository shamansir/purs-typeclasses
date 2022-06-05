let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

let decidable : tc.TClass =
    { id = "decidable"
    , name = "Decidable"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , parents = [ "decide", "divisible" ]
    , info = "Contravariant analogue of Alternative"
    , module = [ "Data" ]
    , package = "purescript-contravariant"
    , link = "purescript-contravariant/3.0.0/docs/Data.Decidable"
    , members =
        [
            { name = "lose"
            , def =
                -- (a -> Void) -> f a
                e.fn
                    (e.fn_ [ e.n "a", e.rv (e.classE "Void") ])
                    (e.ap1_ (e.f "f") (e.n "a"))
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "lost"
            , def =
                -- Decidable f => f Void
                e.req1
                    (e.subj_ "Decidable" [ e.n "a" ])
                    (e.ap1_ (e.f "f") (e.rv (e.classE "Void")))
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceSubj "Decidable" "Comparison"
        , i.instanceSubj "Decidable" "Equivalence"
        , i.instanceSubj "Decidable" "Predicate"
        , e.req1
            (e.class_ "Monoid" [ e.n "r" ])
            (e.subj_ "Decidable" [ e.rv (e.class1_ "Op" (e.n "r")) ]) -- (Monoid r) => Decidable (Op r)
        ]
    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in decidable