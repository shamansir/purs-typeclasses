let tc = ./../../typeclass.dhall

let ord : tc.TClass =
    { id = "ord"
    , name = "Ord"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , parents = [ "eq" ]
    , info = "Ordering"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Ord"
    , members =
        [
            { name = "compart"
            , def = "{{var:a}} {{op:->}} {{var:a}} {{op:->}} {{class:Ordering}}" -- a -> a -> Ordering
            , belongs = tc.Belongs.Yes
            , op = Some "=="
            , opEmoji = tc.noOp
            , laws =
                [
                    { law = "reflexivity"
                    , examples =
                        [ tc.of
                            { fact = "{{var:a}} {{op:<=}} {{var:a}]" -- a <= a
                            }
                        ]
                    }
                ,
                    { law = "antisymmetry"
                    , examples =
                        [ tc.fc
                            { fact = "({{var:a}} {{op:<=}} {{var:b}}) {{method:and}} ({{var:b}} {{op:<=}} {{var:a}})" -- (a <= b) and (b <= a)
                            , conclusion = "{{var:a}} {{op:=}} {{var:b}}" -- a = b
                            }
                        ]
                    }
                ,
                    { law = "transitivity"
                    , examples =
                        [ tc.fc
                            { fact = "({{var:a}} {{op:<=}} {{var:b}}) {{method:and}} ({{var:b}} {{op:<=}} {{var:c}})" -- (a <= b) and (b <= c)
                            , conclusion = "{{var:a}} {{op:<=}} {{var:c}}" -- a <= c
                            }
                        ]
                    }
                ]
            }
        ,
            { name = "lessThan"
            , def = "{{subj:Ord}} {{var:a}} {{op:=>}} {{var:a}} {{op:->}} {{var:a}} {{op:->}} {{class:Boolean}}" -- Ord a => a -> a -> Boolean
            , belongs = tc.Belongs.No
            , op = Some "<"
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "greaterThan"
            , def = "{{subj:Ord}} {{var:a}} {{op:=>}} {{var:a}} {{op:->}} {{var:a}} {{op:->}} {{class:Boolean}}" -- Ord a => a -> a -> Boolean
            , belongs = tc.Belongs.No
            , op = Some ">"
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "lessThanOrEq"
            , def = "{{subj:Ord}} {{var:a}} {{op:=>}} {{var:a}} {{op:->}} {{var:a}} {{op:->}} {{class:Boolean}}" -- Ord a => a -> a -> Boolean
            , belongs = tc.Belongs.No
            , op = Some "<="
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "greaterThanOrEq"
            , def = "{{subj:Ord}} {{var:a}} {{op:=>}} {{var:a}} {{op:->}} {{var:a}} {{op:->}} {{class:Boolean}}" -- Ord a => a -> a -> Boolean
            , belongs = tc.Belongs.No
            , op = Some ">="
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "min"
            , def = "{{subj:Ord}} {{var:a}} {{op:=>}} {{var:a}} {{op:->}} {{var:a}} {{op:->}} {{var:a}}" -- Ord a => a -> a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "max"
            , def = "{{subj:Ord}} {{var:a}} {{op:=>}} {{var:a}} {{op:->}} {{var:a}} {{op:->}} {{var:a}}" -- Ord a => a -> a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "clamp"
            , def = "{{subj:Ord}} {{var:a}} {{op:=>}} {{var:a}} {{op:->}} {{var:a}} {{op:->}} {{var:a}} {{op:->}} {{var:a}}" -- Ord a => a -> a -> a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "between"
            , def = "{{subj:Ord}} {{var:a}} {{op:=>}} {{var:a}} {{op:->}} {{var:a}} {{op:->}} {{var:a}} {{op:->}} {{class:Boolean}}" -- Ord a => a -> a -> a -> Boolean
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "abs"
            , def = "({{subj:Ord}} {{var:a}}, {{class:Ring}} {{var:a}}) {{op:=>}} {{var:a}} {{op:->}} {{var:a}}" -- (Ord a, Ring a) => a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "signum"
            , def = "({{subj:Ord}} {{var:a}}, {{class:Ring}} {{var:a}}) {{op:=>}} {{var:a}} {{op:->}} {{var:a}}" -- (Ord a, Ring a) => a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "comparing"
            , def = "{{subj:Ord}} {{var:b}} {{op:=>}} ({{var:a}} {{op:->}} {{var:b}}) {{op:->}} ({{var:a}} {{op:->}} {{var:a}} {{op:->}} {{class:Ordering}})" -- Ord b => (a -> b) -> (a -> a -> Ordering)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]

    } /\ tc.noInstances /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in ord
