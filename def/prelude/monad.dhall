let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let monad : tc.TClass =
    { id = "monad"
    , name = "Monad"
    , what = tc.What.Class_
    , vars = [ "m" ]
    , parents = [ "bind", "applicative" ]
    , info = "Compose computations"
    , module = [ "Control" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Control.Monad"
    , laws =
        [
            { law = "left identity"
            , examples =
                [ tc.lr
                    { left = "{{method:pure}} {{var:x}} {{op:>>=}} {{fvar:f}}" -- pure x >>= f
                    , right = "{{fvar:f}} {{var:x}}" -- f x
                    }
                ]
            }
        ,
            { law = "right identity"
            , examples =
                [ tc.lr
                    { left = "{{var:x}} {{op:>>=}} {{method:pure}}" -- x >>= pure
                    , right = "{{var:x}}" -- x
                    }
                ]
            }
        ]
    , members =
        [
            { name = "liftM1"
            , def = "{{subj:Monad}} {{typevar:m}} {{op:=>}} ({{var:a}} {{op:->}} {{var:b}}) {{op:->}} {{typevar:m}} {{var:a}} {{op:->}} {{typevar:m}} {{var:b}}" -- Monad m => (a -> b) -> m a -> m b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "ap"
            , def = "{{subj:Monad}} {{typevar:m}} {{op:=>}} {{typevar:m}} ({{var:a}} {{op:->}} {{var:b}}) {{op:->}} {{typevar:m}} {{var:a}} {{op:->}} {{typevar:m}} {{var:b}}" -- Monad m => m (a -> b) -> m a -> m b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "whenM"
            , def = "{{subj:Monad}} {{typevar:m}} {{op:=>}} {{typevar:m}} {{class:Boolean}} {{op:->}} {{typevar:m}} {{class:Unit}} {{op:->}} {{typevar:m}} {{class:Unit}}" -- Monad m => m Boolean -> m Unit -> m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "unlessM"
            , def = "{{subj:Monad}} {{typevar:m}} {{op:=>}} {{typevar:m}} {{class:Boolean}} {{op:->}} {{typevar:m}} {{class:Unit}}{{op:->}} {{typevar:m}} {{class:Unit}}" -- Monad m => m Boolean -> m Unit -> m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceArrowR
        , i.instanceCl "Array"
        ]

    } /\ tc.noValues /\ tc.noStatements

in monad