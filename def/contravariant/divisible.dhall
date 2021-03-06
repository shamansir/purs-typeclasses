let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

let divisible : tc.TClass =
    { id = "divisible"
    , name = "Divisible"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , parents = [ "divide" ]
    , info = "Contravariant analogue of Applicative"
    , module = [ "Data" ]
    , package = "purescript-contravariant"
    , link = "purescript-contravariant/3.0.0/docs/Data.Divisible"
    , members =
        [
            { name = "conquer"
            , def =
                -- f a
                e.ap
                    (e.vf "f")
                    (e.vn "a")
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceSubj "Divisible" "Comparison"
        , i.instanceSubj "Divisible" "Equivalence"
        , i.instanceSubj "Divisible" "Predicate"
        , e.req1
            (e.class_ "Monoid" [ e.n "r" ])
            (e.subj_ "Divisible" [ e.rv (e.class1_ "Op" (e.n "r")) ]) -- (Monoid r) => Divisible (Op r)
        ]
    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in divisible