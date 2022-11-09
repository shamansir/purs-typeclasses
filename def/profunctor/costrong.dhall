let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class Costrong :: (Type -> Type -> Type) -> Constraint
-- class (Profunctor p) <= Costrong p where

let costrong : tc.TClass =
    { spec =
        d.class_vpc
            (d.id "costrong")
            "Costrong"
            [ d.v "p" ]
            [ d.p (d.id "profunctor") "Profunctor" [ d.v "p" ] ]
            d.t3c
    , info = "Provides the dual operations of the Strong class"
    , module = [ "Data", "Profunctor" ]
    , package = tc.pkmj "purescript-profunctor" +5
    , members =
        [
            { name = "unfirst"
            , def =
                e.fn2
                    (e.ap3 (e.t "p") (e.br (e.class "Tuple" [ e.n "a", e.n "c" ])) (e.br (e.class "Tuple" [ e.n "b", e.n "c" ])))
                    (e.ap3 (e.t "p") (e.n "a") (e.n "b"))
                -- p (Tuple a c) (Tuple b c) -> p a b
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "unsecond"
            , def =
                e.fn2
                    (e.ap3 (e.t "p") (e.br (e.class "Tuple" [ e.n "a", e.n "b" ])) (e.br (e.class "Tuple" [ e.n "a", e.n "c" ])))
                    (e.ap3 (e.t "p") (e.n "b") (e.n "c"))
                -- p (Tuple a b) (Tuple a c) -> p b c
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instance "Function" "Closed"
        ]

    } /\ tc.aw /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in costrong