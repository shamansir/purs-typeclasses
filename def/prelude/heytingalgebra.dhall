let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let heytingAlgebra : tc.TClass =
    { id = "heytingalgebra"
    , name = "HeytingAlgebra"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , info = "Bounded lattices, boolean starters"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.HeytingAlgebra"
    , members =
        [
            { name = "ff"
            , def = "{{var:a}}" -- a
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "tt"
            , def = "{{var:a}}" -- a
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "implies"
            , def = "{{var:a}} {{op:->}} {{var:a}} {{op:->}} {{var:a}}" -- a -> a -> a
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "conj"
            , def = "{{var:a}} {{op:->}} {{var:a}} {{op:->}} {{var:a}}" -- a -> a -> a
            , belongs = tc.Belongs.Yes
            , op = Some "&&"
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "disj"
            , def = "{{var:a}} {{op:->}} {{var:a}} {{op:->}} {{var:a}}" -- a -> a -> a
            , belongs = tc.Belongs.Yes
            , op = Some "||"
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "not"
            , def = "{{var:a}}" -- a
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ]
    , laws =
        [
            { law = "associativity"
            , examples =
                [ tc.lr
                    { left = "{{var:a}} {{op:||}} ({{var:b}} {{op:||}} {{var:c}})" -- a || (b || c)
                    , right = "({{var:a}} {{op:||}} {{var:b}}) {{op:||}} {{var:c}}" -- (a || b) || c
                    }
                , tc.lr
                    { left = "{{var:a}} {{op:&&}} ({{var:b}} {{op:&&}} {{var:c}})" -- a && (b && c)
                    , right = "({{var:a}} {{op:&&}} {{var:b}}) {{op:&&}} {{var:c}}" -- (a && b) && c
                    }
                ]
            }
        ,
            { law = "commutativity"
            , examples =
                [ tc.lr
                    { left = "{{var:a}} {{op:||}} {{var:b}}" -- a || b
                    , right = "{{var:b}} {{op:||}} {{var:a}}" -- b || a
                    }
                , tc.lr
                    { left = "{{var:a}} {{op:&&}} {{var:b}}" -- a && b
                    , right = "{{var:b}} {{op:&&}} {{var:a}}" -- b && a
                    }
                ]
            }
        ,
            { law = "absorption"
            , examples =
                [ tc.lr
                    { left = "{{var:a}} {{op:||}} ({{var:a}} {{op:&&}} {{var:b}})" -- a || (a && b)
                    , right = "{{var:a}}" -- a
                    }
                , tc.lr
                    { left = "{{var:a}} {{op:&&}} {{var:a}}" -- a && a
                    , right = "{{var:a}}" -- a
                    }
                ]
            }
        ,
            { law = "idempotent"
            , examples =
                [ tc.lr
                    { left = "{{var:a}} {{op:||}} {{var:a}}" -- a || a
                    , right = "{{var:a}}" -- a
                    }
                , tc.lr
                    { left = "{{var:a}} && ({{var:a}} {{op:||}} {{var:b}})" -- a && (a || b)
                    , right = "{{var:a}}" -- a
                    }
                ]
            }
        ,
            { law = "identity"
            , examples =
                [ tc.lr
                    { left = "{{var:a}} {{op:||}} {{method:ff}}" -- a || ff
                    , right = "{{var:a}}"
                    }
                , tc.lr
                    { left = "{{var:a}} {{op:&&}} {{method:tt}}" -- a && tt
                    , right = "{{var:a}}"
                    }
                ]
            }
        ,
            { law = "implication"
            , examples =
                [ tc.lr
                    { left = "{{var:a}} {{method:`implies`}} {{var:a}}" -- a `implies` a
                    , right = "{{method:tt}}" -- tt
                    }
                , tc.lr
                    { left = "{{var:a}} {{op:&&}} ({{var:a}} {{method:`implies`}} {{var:b}})" -- a && (a `implies` b)
                    , right = "{{var:a}} {{op:&&}} {{var:b}}" -- a && b
                    }
                , tc.lr
                    { left = "{{var:b}} {{op:&&}} ({{var:a}} {{method:`implies`}} {{var:b}})" -- b && (a `implies` b)
                    , right = "{{var:b}}" -- b
                    }
                , tc.lr
                    { left = "{{var:a}} {{method:`implies`}} ({{var:b}} {{op:&&}} {{var:c}})" -- a `implies` (b && c)
                    , right = "({{var:a}} {{method:`implies`}} {{var:b}}) {{op:&&}} ({{var:a}} {{method:`implies`}} {{var:c}})" -- (a `implies` b) && (a `implies` c)
                    }
                ]
            }
        ,
            { law = "complemented"
            , examples =
                [ tc.lr
                    { left = "{{method:not}} {{var:a}}" -- not a
                    , right = "{{var:a}} {{method:`implies`}} {{method:ff}}" -- a `implies` ff
                    }
                    ]
            }
        ]
    , instances =
        [ i.instanceCl "Boolean"
        , i.instanceCl "Unit"
        , i.instanceFn
        ]

    } /\ tc.noParents /\ tc.noValues /\ tc.noStatements

in heytingAlgebra