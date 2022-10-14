let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

-- class Cochoice :: (Type -> Type -> Type) -> Constraint
-- class (Profunctor p) <= Cochoice p where

let cochoice : tc.TClass =
    { id = "cochoice"
    , name = "Cochoice"
    , what = tc.What.Class_
    , vars = [ "p" ]
    , parents = [ "profunctor" ]
    , info = "Provides the dual operations of the Choice class"
    , module = [ "Data", "Profunctor" ]
    , package = tc.pkmj "purescript-profunctor" +5
    , link = "purescript-profunctor/5.0.0/docs/Data.Profunctor.Cochoice"
    , members =
        [
            { name = "unleft"
            , def =
                e.fn2
                    (e.ap3 (e.t "p") (e.br (e.class "Either" [ e.n "a", e.n "c" ])) (e.br (e.class "Either" [ e.n "b", e.n "c" ])))
                    (e.ap3 (e.t "p") (e.n "a") (e.n "b"))
                -- p (Either a c) (Either b c) -> p a b
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "unright"
            , def =
                e.fn2
                    (e.ap3 (e.t "p") (e.br (e.class "Either" [ e.n "a", e.n "b" ])) (e.br (e.class "Either" [ e.n "a", e.n "c" ])))
                    (e.ap3 (e.t "p") (e.n "b") (e.n "c"))
                -- p (Either a b) (Either a c) -> p b c
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instance "Function" "Closed"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in cochoice