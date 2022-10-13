let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

-- class Biapplicative :: (Type -> Type -> Type) -> Constraint
-- class (Biapply w) <= Biapplicative w where

let bifunctor : tc.TClass =
    { id = "biapplicative"
    , name = "Biapplicative"
    , what = tc.What.Class_
    , vars = [ "w" ]
    , parents = [ "biapply" ]
    , info = "Captures type constructors of two arguments in Applicative"
    , module = [ "Control" ]
    , package = tc.pkmj "purescript-bifunctors" +5
    , link = "purescript-bifunctors/5.0.0/docs/Control.Biapplicative"
    , members =
        [
            { name = "bipure"
            , def = e.fn3 (e.n "a") (e.n "b") (e.ap (e.t "w") [ e.n "a", e.n "b" ]) -- a -> b -> w a b
            , belongs = tc.Belongs.Yes
            } /\ tc.noLaws /\ tc.noOps
        ]
    , instances =
        [ i.instanceSubj "Tuple" "Biapplicative"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in bifunctor