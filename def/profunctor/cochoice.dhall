let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class Cochoice :: (Type -> Type -> Type) -> Constraint
-- class (Profunctor p) <= Cochoice p where

let cochoice : tc.TClass =
    { spec =
        d.class_vpc
            (d.id "cochoice")
            "Cochoice"
            [ d.v "p" ]
            [ d.p (d.id "profunctor") "Profunctor" [ d.v "p" ] ]
            d.t3c
    , info = "Provides the dual operations of the Choice class"
    , module = [ "Data", "Profunctor" ]
    , package = tc.pkmj "purescript-profunctor" +5
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

    } /\ tc.aw /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in cochoice