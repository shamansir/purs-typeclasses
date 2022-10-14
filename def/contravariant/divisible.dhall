let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- class Divisible :: (Type -> Type) -> Constraint
-- class (Divide f) <= Divisible f where

let divisible : tc.TClass =
    { id = "divisible"
    , name = "Divisible"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , parents = [ "divide" ]
    , info = "Contravariant analogue of Applicative"
    , module = [ "Data" ]
    , package = tc.pkmj "purescript-contravariant" +3
    , link = "purescript-contravariant/3.0.0/docs/Data.Divisible"
    , members =
        [
            { name = "conquer"
            , def =
                -- f a
                e.ap2 (e.f "f") (e.n "a")
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceSubj "Divisible" "Comparison"
        , i.instanceSubj "Divisible" "Equivalence"
        , i.instanceSubj "Divisible" "Predicate"
        , e.req1
            (e.br (e.class1 "Monoid" (e.n "r")))
            (e.subj1 "Divisible" (e.br (e.class1 "Op" (e.n "r")))) -- (Monoid r) => Divisible (Op r)
        ]
    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in divisible