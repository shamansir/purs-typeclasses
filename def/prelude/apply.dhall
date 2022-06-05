let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let apply =
    { id = "apply"
    , name = "Apply"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , parents = [ "functor" ]
    , info = "Unwrap, convert, and wrap again"
    , module = [ "Control" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Control.Apply#t:Apply"
    , members =
        [
            { name = "apply"
            , def = "{{fvar:f}} ({{var:a}} {{op:->}} {{var:b}}) {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{fvar:f}} {{var:b}}" -- f (a -> b) -> f a -> f b
            , op = Some "<*>"
            , opEmoji = Some "🚋"
            , belongs = tc.Belongs.Yes
            , laws =
                [
                    { law = "ap. composition"
                    , examples =
                        [ tc.lr
                            { left = "({{op:<<<}}) {{op:<$>}} {{fvar:f}} {{op:<*>}} {{fvar:g}} {{op:<*>}} {{fvar:h}}" -- (<<<) <$> f <*> g <*> h
                            , right = "{{fvar:f}} {{op:<*>}} ({{fvar:g}} {{op:<*>}} {{fvar:h}})" -- f <*> (g <*> h)
                            }
                        ]
                    }
                ]
            }
        ,
            { name = "applyFirst"
            , def = "{{subj:Apply}} {{fvar:f}} {{op:=>}} {{fvar:f}} {{var:a}} {{op:->}} {{fvar:f}} {{var:b}} {{op:->}} {{fvar:f}} {{var:a}}" -- Apply f => f a -> f b -> f a
            , belongs = tc.Belongs.No
            , op = Some "<*"
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "applySecond"
            , def = "{{subj:Apply}} {{fvar:f}} {{op:=>}} {{fvar:f}} {{var:a}} {{op:->}} {{fvar:f}} {{var:b}} {{op:->}} {{fvar:f}} {{var:b}}" -- Apply f => f a -> f b -> f b
            , belongs = tc.Belongs.No
            , op = Some "*>"
            , opEmoji = Some "👉"
            } /\ tc.noLaws
        ,
            { name = "lift2"
            , def = "{{subj:Apply}} {{fvar:f}} {{op:=>}} ({{var:a}} {{op:->}} {{var:b}} {{op:->}} {{var:c}}) {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{fvar:f}} {{var:b}} {{op:->}} {{fvar:f}} {{var:c}}" -- Apply f => (a -> b -> c) -> f a -> f b -> f c
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "lift3"
            , def = "{{subj:Apply}} {{fvar:f}} {{op:=>}} ({{var:a}} {{op:->}} {{var:b}} {{op:->}} {{var:b}} {{op:->}} {{var:d}}) {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{fvar:f}} {{var:b}} {{op:->}} {{fvar:f}} {{var:c}} {{op:->}} {{fvar:f}} {{var:d}}" -- Apply f => (a -> b -> c -> d) -> f a -> f b -> f c -> f d
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "lift4"
            , def = "{{subj:Apply}} {{fvar:f}} {{op:=>}} ({{var:a}} {{op:->}} {{var:b}} {{op:->}} {{var:c}} {{op:->}} {{var:d}} {{op:->}} {{var:e}}) {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{fvar:f}} {{var:b}} {{op:->}} {{fvar:f}} {{var:c}} {{op:->}} {{fvar:f}} {{var:d}} {{op:->}} {{fvar:f}} {{var:e}}" -- Apply f => (a -> b -> c -> d -> e) -> f a -> f b -> f c -> f d -> f e
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "lift5"
            , def = "{{subj:Apply}} {{fvar:f}} {{op:=>}} ({{var:a}} {{op:->}} {{var:b}} {{op:->}} {{var:c}} {{op:->}} {{var:d}} {{op:->}} {{var:e}} {{op:->}} {{var:g}}) {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{fvar:f}} {{var:b}} {{op:->}} {{fvar:f}} {{var:c}} {{op:->}} {{fvar:f}} {{var:d}} {{op:->}} {{fvar:f}} {{var:e}} {{op:->}} {{fvar:f}} {{var:g}}" -- Apply f => (a -> b -> c -> d -> e -> g) -> f a -> f b -> f c -> f d -> f e -> f g
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceCl "Array"
        , i.instanceArrowR
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in apply