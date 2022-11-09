let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class Biapplicative :: (Type -> Type -> Type) -> Constraint
-- class (Biapply w) <= Biapplicative w where

let biapplicative : tc.TClass =
    { spec =
        d.class_vpc
            (d.id "biapplicative")
            "Biapplicative"
            [ d.v "w" ]
            [ d.p (d.id "biapply") "Biapply" [ d.v "w" ] ]
            d.t3c
    , info = "Captures type constructors of two arguments in Applicative"
    , module = [ "Control" ]
    , package = tc.pkmj "purescript-bifunctors" +5
    , members =
        [
            { name = "bipure"
            , def = e.fn3 (e.n "a") (e.n "b") (e.ap (e.t "w") [ e.n "a", e.n "b" ]) -- a -> b -> w a b
            , belongs = tc.Belongs.Yes
            } /\ tc.noLaws /\ tc.noOps /\ tc.noExamples
        ]
    , instances =
        [ i.instanceSubj "Tuple" "Biapplicative"
        ]

    } /\ tc.aw /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in biapplicative