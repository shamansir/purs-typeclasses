let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let bind : tc.TClass =
    { id = "bind"
    , name = "Bind"
    , what = tc.What.Class_
    , vars = [ "m" ]
    , parents = [ "apply" ]
    , info = "Compose computations"
    , module = [ "Control" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Control.Bind"
    , members =
        [
            { name = "bind"
            , def = "{{typevar:m}} {{var:a}} {{op:->}} ({{var:a}} {{op:->}} {{typevar:m}} {{var:b}}) {{op:->}} {{typevar:m}} {{var:b}}" -- m a -> (a -> m b) -> m b
            , belongs = tc.Belongs.Yes
            , op = Some ">>="
            , opEmoji = Some "🎉"
            , laws =
                [
                    { law = "associativity"
                    , examples =
                        [ tc.lr
                            { left = "({{var:x}} {{op:>>=}} {{fvar:f}}) {{op:>>=}} {{fvar:g}}" -- (x >>= f) >>= g
                            , right = "{[var:x}} {{op:>>=}} (\\{{var:k}} {{op:->}} {{fvar:f}} {{fvar:k}} {{op:>>=}} {{var:g}})" -- x >>= (\\k -> f k >>= g)
                            }
                        ]
                    }
                ]
            }
        ,
            { name = "bindFlipped"
            , def = "{{subj:Bind}} {{typevar:m}} {{op:=>}} ({{var:a}} {{op:->}} {{typevar:m}} {{var:b}}) {{op:->}} {{typevar:m}} {{var:a}} {{op:->}} {{typevar:m}} {{var:b}}" -- Bind m => (a -> m b) -> m a -> m b
            , belongs = tc.Belongs.No
            , op = Some "==<<"
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "join"
            , def = "{{subj:Bind}} {{typevar:m}} {{op:=>}} {{typevar:m}} ({{typevar:m}} {{var:a}}) {{op:->}} {{typevar:m}} {{var:a}}" -- Bind m => m (m a) -> m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "composeKleisli"
            , def = "{{subj:Bind}} {{typevar:m}} {{op:=>}} ({{var:a}} {{op:->}} {{typevar:m}} {{var:b}}) {{op:->}} ({{var:b}} {{op:->}} {{typevar:m}} {{var:c}}) {{op:->}} {{var:a}} {{op:->}} {{typevar:m}} {{var:c}}" -- Bind m => (a -> m b) -> (b -> m c) -> a -> m c
            , belongs = tc.Belongs.No
            , op = Some ">==>"
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "composeKleisliFlipped"
            , def = "{{subj:Bind}} {{typevar:m}} {{op:=>}} ({{var:b}} {{op:->}} {{typevar:m}} {{var:c}}) {{op:->}} ({{var:a}} {{op:->}} {{typevar:m}} {{var:b}}) {{op:->}} {{var:a}} {{op:->}} {{typevar:m}} {{var:c}}" -- Bind m => (b -> m c) -> (a -> m b) -> a -> m c
            , belongs = tc.Belongs.No
            , op = Some "<==<"
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "ifM"
            , def = "{{subj:Bind}} {{typevar:m}} {{op:=>}} {{typevar:m}} {{class:Boolean}} {{op:->}} {{typevar:m}} {{var:a}} {{op:->}} {{typevar:m}} {{var:a}} {{op:->}} {{typevar:m}} {{var:a}}" -- Bind m => m Boolean -> m a -> m a -> m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceCl "Array"
        , i.instanceArrowR
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in bind