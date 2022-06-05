let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let applicative : tc.TClass =
    { id = "applicative"
    , name = "Applicative"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , parents = [ "apply" ]
    , info = "Lift with zero arguments, wrap values"
    , module = [ "Control" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Control.Applicative#t:Applicative"
    , members =
        [
            { name = "pure"
            , def = "{{var:a}} {{op:->}} {{fvar:f}} {{var:a}}" -- a -> f a
            , belongs = tc.Belongs.Yes
            , laws =
                [
                    { law = "identity"
                    , examples =
                        [ tc.lr
                            { left = "({{method:pure}} {{method:identity}}) {{op:<*>}} {{var:v}}" -- (pure id) <*> v
                            , right = "{{var:v}}" -- v
                            }
                        ]
                    }
                ,
                    { law = "composition"
                    , examples =
                        [ tc.lr
                            { left = "({{method:pure}} {{op:<<<}}) {{op:<*>}} {{fvar:f}} {{op:<*>}} {{fvar:g}} {{op:<*>}} {{fvar:h}}" -- (pure <<<) <*> f <*> g <*> h
                            , right = "{{fvar:f}} {{op:<*>}} ({{fvar:g}} {{op:<*>}} {{fvar:h}})" -- f <*> (g <*> h)
                            }
                        ]
                    }
                ,
                    { law = "homomorphism"
                    , examples =
                        [ tc.lr
                            { left = "({{method:pure}} {{fvar:f}}) {{op:<*>}} ({{method:pure}} {{var:x}})" -- (pure f) <*> (pure x)
                            , right = "{{method:pure}} ({{fvar:f}} {{var:x}})" -- pure (f x)
                            }
                        ]
                    }
                ,
                    { law = "interchange"
                    , examples =
                        [ tc.lr
                            { left = "{{var:u}} {{op:<*>}} ({{method:pure}} {{var:y}})" -- u <*> (pure y)
                            , right = "({{method:pure}}  ({{op:$}} {{var:y}})) {{op:<*>}} {{var:u}}" -- (pure ($ y)) <*> u
                            }
                        ]
                    }
                ]
            } /\ tc.noOps
        ,
            { name = "liftA1"
            , def = "{{subj:Applicative}} {{fvar:f}} {{op:=>}} ({{var:a}} {{op:->}} {{var:b}}) {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{fvar:f}} {{var:b}}" -- Applicative f => (a -> b) -> f a -> f b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "when"
            , def = "{{subj:Applicative}} {{typevar:m}} {{op:=>}} {{class:Boolean}} {{op:->}} {{typevar:m}} {{class:Unit}} {{op:->}} {{typevar:m}} {{class:Unit}}" -- Applicative m => Boolean -> m Unit -> m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "unless"
            , def = "{{subj:Applicative}}  {{typevar:m}} {{op:=>}} {{class:Boolean}} {{op:->}} {{typevar:m}} {{class:Unit}} {{op:->}} {{typevar:m}} {{class:Unit}}" -- Applicative m => Boolean -> m Unit -> m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceCl "Array"
        , i.instanceArrowR
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in applicative