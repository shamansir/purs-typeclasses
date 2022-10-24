let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../typedef.dhall
let e = ./../../build_expr.dhall

-- class MonadEffect :: (Type -> Type) -> Constraint
-- class (Monad m) <= MonadEffect m where

let monadeffect : tc.TClass =
    { id = "monadeffect"
    , name = "MonadEffect"
    , what = tc.What.Class_
    , vars = [ "m" ]
    , parents = [ "monad" ]
    , info = "Captures those monads which support native effects"
    , module = [ "Data" ]
    , package = tc.pkmj "purescript-effect" +3
    , link = "purescript-effect/3.0.0/docs/Effect.Class"
    , def =
        d.class_vpc
            (d.id "monadeffect")
            "MonadEffect"
            [ d.v "m" ]
            [ d.p (d.id "monad") "Monad" [ d.v "m" ] ]
            d.t2c
    , members =
        [
            { name = "liftEffect"
            , def =
                -- Effect a -> m a
                e.fn2
                    (e.class1 "Effect" (e.n "a"))
                    (e.ap2 (e.t "m") (e.n "a"))
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceSubj "Effect" "MonadEffect"
        ]
    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in monadeffect