let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let strong : tc.TClass =
    { id = "strong"
    , name = "Strong"
    , what = tc.What.Class_
    , vars = [ "p" ]
    , parents = [ "profunctor" ]
    , info = "Extends Profunctor with combinators for working with product types"
    , module = [ "Data", "Profunctor" ]
    , package = "purescript-profunctor"
    , link = "purescript-profunctor/5.0.0/docs/Data.Profunctor.Strong"
    , members =
        [
            { name = "first"
            , def = "{{typevar:p}} {{var:a}} {{var:b}} {{op:->}} {{typevar:p}} ({{class:Tuple}} {{var:a}} {{var:c}}) ({{class:Tuple}} {{var:b}} {{var:c}})" -- p a b -> p (Tuple a c) (Tuple b c)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "second"
            , def = "{{typevar:p}} {{var:b}} {{var:c}} {{op:->}} {{typevar:p}} ({{class:Tuple}} {{var:a}} {{var:b}}) ({{class:Tuple}} {{var:a}} {{var:c}})" -- p b c -> p (Tuple a b) (Tuple a c)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "splitStrong"
            , def = "{{class:Category}} {{typevar:p}} {{op:=>}} {{subj:Strong}} {{typevar:p}} {{op:=>}} {{typevar:p}} {{var:a}} {{var:b}} {{op:->}} {{typevar:p}} {{var:c}} {{var:d}} {{op:->}} {{typevar:p}} ({{class:Tuple}} {{var:a}} {{var:c}}) ({{class:Tuple}} {{var:b}} {{var:d}})" -- Category p => Strong p => p a b -> p c d -> p (Tuple a c) (Tuple b d)
            , belongs = tc.Belongs.No
            , op = Some "***"
            , opEmoji = tc.noOp
            , laws =
                [
                    { law = "for function"
                    , examples =
                        [ tc.of
                            { fact = "({{op:***}}) {{op:::}} ({{var:a}} {{op:->}} {{var:b}}) {{op:->}} ({{var:c}} {{op:->}} {{var:d}}) {{op:->}} ({{class:Tuple}} {{var:a}} {{var:c}}) {{op:->}} ({{class:Tuple}} {{var:b}} {{var:d}})" -- (***) :: (a -> b) -> (c -> d) -> (Tuple a c) -> (Tuple b d)
                            }
                        ]
                    }
                ]
            }
        ,
            { name = "fanout"
            , def = "{{class:Category}} {{typevar:p}} {{op:=>}} {{subj:Strong}} {{typevar:p}} {{op:=>}} {{typevar:p}} {{var:a}} {{var:b}} {{op:->}} {{typevar:p}} {{var:a}} {{var:c}} {{op:->}} {{typevar:p}} {{var:a}} ({{class:Tuple}} {{var:b}} {{var:c}})" -- Category p => Strong p => p a b -> p a c -> p a (Tuple b c)
            , belongs = tc.Belongs.No
            , op = Some "&&&"
            , opEmoji = tc.noOp
            , laws =
                [
                    { law = "for function"
                    , examples =
                        [ tc.of
                            { fact = "({{op:&&&}}) {{op:::}} ({{var:a}} {{op:->}} {{var:b}}) {{op:->}} ({{var:a}} {{op:->}} {{var:c}}) {{op:->}} ({{var:a}} {{op:->}} ({{class:Tuple}} {{var:b}} {{var:c}}))" -- (&&&) :: (a -> b) -> (a -> c) -> (a -> (Tuple b c))
                            }
                        ]
                    }
                ]
            }
        ]
    , instances =
        [ i.instance "Function" "Strong"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in strong