let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../typedef.dhall
let e = ./../../build_expr.dhall

-- class Closed :: (Type -> Type -> Type) -> Constraint
-- class (Profunctor p) <= Closed p where

let closed : tc.TClass =
    { id = "closed"
    , name = "Closed"
    , what = tc.What.Class_
    , vars = [ "p" ]
    , parents = [ "profunctor" ]
    , info = "Extends Profunctor to work with functions"
    , module = [ "Data", "Profunctor" ]
    , package = tc.pkmj "purescript-profunctor" +5
    , link = "purescript-profunctor/5.0.0/docs/Data.Profunctor.Closed"
    , def =
        d.class_vpc
            (d.id "closed")
            "Closed"
            [ d.v "p" ]
            [ d.p (d.id "profunctor") "Profunctor" [ d.v "p" ] ]
            d.t3c
    , members =
        [
            { name = "closed"
            , def =
                e.fn2
                    (e.ap3 (e.t "p") (e.n "a") (e.n "b"))
                    (e.ap3
                        (e.t "p")
                        (e.br (e.fn2 (e.n "x") (e.n "a")))
                        (e.br (e.fn2 (e.n "x") (e.n "b")))
                    )
                -- p a b -> p (x -> a) (x -> b)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instance "Function" "Closed"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in closed