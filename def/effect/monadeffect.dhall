let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

let monadeffect : tc.TClass =
    { id = "monadeffect"
    , name = "MonadEffect"
    , what = tc.What.Class_
    , vars = [ "m" ]
    , parents = [ "monad" ]
    , info = "Captures those monads which support native effects"
    , module = [ "Data" ]
    , package = "purescript-effect"
    , link = "purescript-effect/3.0.0/docs/Effect.Class"
    , members =
        [
            { name = "liftEffect"
            , def =
                -- Effect a -> m a
                e.fn
                    (e.class1_ "Effect" (e.n "a"))
                    (e.ap1_ (e.t "m") (e.n "a"))
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceSubj "Effect" "MonadEffect"
        ]
    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in monadeffect