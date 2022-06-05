let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let profunctor : tc.TClass =
    { id = "profunctor"
    , name = "Profunctor"
    , what = tc.What.Class_
    , vars = [ "p" ]
    , info = "Functor from the pair category"
    , module = [ "Data" ]
    , package = "purescript-profunctor"
    , link = "purescript-profunctor/5.0.0/docs/Data.Profunctor"
    , laws =
        [
            { law = "identity"
            , examples =
                [ tc.lr
                    { left = "{{method:dimap}} {{method:identity}} {{method:identity}}" -- dimap identity identity
                    , right = "{{method:identity}}" -- identity
                    }
                ]
            }
        ,
            { law = "composition"
            , examples =
                [ tc.lr
                    { left = "{{method:dimap}} {{fvar:f1}} {{fvar:g1}} {{op:<<<}} {{method:dimap}} {{fvar:f2}} {{fvar:g2}}" -- dimap f1 g1 <<< dimap f2 g2
                    , right = "{{method:dimap}} ({{fvar:f1}} {{op:>>>}} {{fvar:f2}}) ({{fvar:g1}} {{op:<<<}} {{fvar:g2}})" -- dimap (f1 >>> f2) (g1 <<< g2)
                    }
                ]
            }
        ]
    , members =
        [
            { name = "dimap"
            , def = "({{var:a}} {{op:->}} {{var:b}}) {{op:->}} ({{var:c}} {{op:->}} {{var:d}}) {{op:->}} {{typevar:p}} {{var:b}} {{var:c}} {{op:->}} {{typevar:p}} {{var:a}} {{var:d}}" -- (a -> b) -> (c -> d) -> p b c -> p a d
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "lcmap"
            , def = "{{subj:Profunctor}} {{typevar:p}} {{op:=>}} ({{var:a}} {{op:->}} {{var:b}}) {{op:->}} {{typevar:p}} {{var:b}} {{var:c}} {{op:->}} {{typevar:p}} {{var:a}} {{var:c}}" -- Profunctor p => (a -> b) -> p b c -> p a c
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "rmap"
            , def = "{{subj:Profunctor}} {{typevar:p}} {{op:=>}} ({{var:b}} {{op:->}} {{var:c}}) {{op:->}} {{typevar:p}} {{var:a}} {{var:b}} {{op:->}} {{typevar:p}} {{var:a}} {{var:c}}" -- Profunctor p => (b -> c) -> p a b -> p a c
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "arr"
            , def = "{{class:Category}} {{typevar:p}} {{op:=>}} {{subj:Profunctor}} {{typevar:p}} {{op:=>}} ({{var:a}} {{op:->}} {{var:b}}) {{op:->}} {{typevar:p}} {{var:a}} {{var:b}}" -- Category p => Profunctor p => (a -> b) -> p a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "unwrapIso"
            , def = "{{subj:Profunctor}} {{typevar:p}} {{op:=>}} {{class:Newtype}} {{var:t}} {{var:a}} {{op:=>}} {{typevar:p}} {{var:t}} {{var:t}} {{op:->}} {{typevar:p}} {{var:a}} {{var:a}}" -- Profunctor p => Newtype t a => p t t -> p a a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "wrapIso"
            , def = "{{subj:Profunctor}} {{typevar:p}} {{op:=>}} {{class:Newtype}} {{var:t}} {{var:a}} {{op:=>}} ({{var:a}} {{op:->}} {{var:t}}) {{op:->}} {{typevar:p}} {{var:a}} {{var:a}} {{op:->}} {{typevar:p}} {{var:t}} {{var:t}}" -- Profunctor p => Newtype t a => (a -> t) -> p a a -> p t t
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instance "Function" "Profunctor"
        ]

    } /\ tc.noParents /\ tc.noValues /\ tc.noStatements

in profunctor