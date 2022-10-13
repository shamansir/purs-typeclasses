let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- class Decidable :: (Type -> Type) -> Constraint
-- class (Decide f, Divisible f) <= Decidable f where

let decidable : tc.TClass =
    { id = "decidable"
    , name = "Decidable"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , parents = [ "decide", "divisible" ]
    , info = "Contravariant analogue of Alternative"
    , module = [ "Data" ]
    , package = tc.pkmj "purescript-contravariant" +3
    , link = "purescript-contravariant/3.0.0/docs/Data.Decidable"
    , members =
        [
            { name = "lose"
            , def =
                -- (a -> Void) -> f a
                e.fn2
                    (e.br (e.fn2 (e.n "a") (e.classE "Void")))
                    (e.ap2 (e.f "f") (e.n "a"))
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "lost"
            , def =
                -- Decidable f => f Void
                e.req1
                    (e.subj1 "Decidable" (e.n "a"))
                    (e.ap2 (e.f "f") (e.classE "Void"))
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceSubj "Decidable" "Comparison"
        , i.instanceSubj "Decidable" "Equivalence"
        , i.instanceSubj "Decidable" "Predicate"
        , e.req1
            (e.br (e.class1 "Monoid" (e.n "r")))
            (e.subj1 "Decidable" (e.br (e.class1 "Op" (e.n "r")))) -- (Monoid r) => Decidable (Op r)
        ]
    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in decidable