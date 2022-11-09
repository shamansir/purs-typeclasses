let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class MonadEffect :: (Type -> Type) -> Constraint
-- class (Monad m) <= MonadEffect m where

let monadeffect : tc.TClass =
    { spec =
        d.class_vpc
            (d.id "monadeffect")
            "MonadEffect"
            [ d.v "m" ]
            [ d.p (d.id "monad") "Monad" [ d.v "m" ] ]
            d.t2c
    , info = "Captures those monads which support native effects"
    , module = [ "Data" ] -- FIXME: wrong module?
    , package = tc.pkmj "purescript-effect" +3
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
    } /\ tc.aw /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in monadeffect