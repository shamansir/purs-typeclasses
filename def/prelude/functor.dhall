let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let functor : tc.TClass =
    { id = "functor"
    , name = "Functor"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , info = "Convert and forget"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Functor"
    , members =
        [
            { name = "map"
            , def = "({{var:a}} {{op:->}} {{var:b}}) {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{fvar:f}} {{var:b}}" -- (a -> b) -> f a -> f b
            , belongs = tc.Belongs.Yes
            , op = Some "<$>"
            , opEmoji = Some "🚂"
            , laws =
                [
                    { law = "identity"
                    , examples =
                        [ tc.lr
                            { left = "({{op:<$>}}) {{method:identity}}" -- (<$>) id
                            , right = "{{method:identity}}" -- id
                            }
                        ]
                    }
                ,
                    { law = "composition"
                    , examples =
                        [ tc.lr
                            { left = "({{op:<$>}}) ({{fvar:f}} {{op:<<<}} {{fvar:g}})" -- (<$>) (f <<< g)
                            , right = "({{fvar:f}} {{op:<$>}}) {{op:<<<}} ({{fvar:g}} {{op:<$>}})" -- (f <$>) <<< (g <$>)
                            }
                        ]
                    }
                ]
            }
        ,
            { name = "mapFlipped"
            , def = "{{subj:Functor}} {{fvar:f}} {{op:=>}} {{fvar:f}} {{var:a}} {{op:->}} ({{var:a}} {{op:->}} {{var:b}}) {{op:->}} {{fvar:f}} {{var:b}}" -- Functor f => f a -> (a -> b) -> f b
            , belongs = tc.Belongs.No
            , op = Some "<#>"
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "void"
            , def = "{{subj:Functor}} {{fvar:f}} {{op:=>}} {{fvar:f}} {{var:a}} {{op:->}} {{fvar:f}} {{class:Unit}}" -- Functor f => f a -> f Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "voidRight"
            , op = Some "<$"
            , def = "{{subj:Functor}} {{fvar:f}} {{op:=>}} {{var:a}} {{op:->}} {{fvar:f}} {{var:b}} {{op:->}} {{fvar:f}} {{var:a}}" -- Functor f => a -> f b -> f a
            , belongs = tc.Belongs.No
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "voidLeft"
            , op = Some "$>"
            , def = "{{subj:Functor}} {{fvar:f}} {{op:=>}} {{fvar:f}} {[var:a}} {{op:->}} {{var:b}} {{op:->}} {{fvar:f}} {{var:b}}" -- Functor f => f a -> b -> f b
            , belongs = tc.Belongs.No
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "flap"
            , op = Some "<@>"
            , def = "{{subj:Functor}} {{fvar:f}} {{op:=>}} {{fvar:f}} ({{var:a}} {{op:->}} {{var:b}}) {{op:->}} {{var:a}} {{op:->}} {{fvar:f}} {{var:b}}" -- Functor f => f (a -> b) -> a -> f b
            , belongs = tc.Belongs.No
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ]
    , instances =
        [ i.instanceCl "Array"
        , i.instanceArrowR
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in functor