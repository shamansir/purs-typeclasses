let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let choice : tc.TClass =
    { id = "choice"
    , name = "Choice"
    , what = tc.What.Class_
    , vars = [ "p" ]
    , parents = [ "profunctor" ]
    , info = "Extends Profunctor with combinators for working with sum types"
    , module = [ "Data", "Profunctor" ]
    , package = "purescript-profunctor"
    , link = "purescript-profunctor/5.0.0/docs/Data.Profunctor.Choice"
    , members =
        [
            { name = "left"
            , def = "{{typevar:p}} {{var:a}} {{var:b}} {{op:->}} {{typevar:p}} ({{class:Either}} {{var:a}} {{var:c}}) ({{class:Either}} {{var:b}} {{var:c}})" -- p a b -> p (Either a c) (Either b c)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "right"
            , def = "{{typevar:p}} {{var:b}} {{var:c}} {{op:->}} {{typevar:p}} ({{class:Either}} {{var:a}} {{var:b}}) ({{class:Either}} {{var:a}} {{var:c}})" --  p b c -> p (Either a b) (Either a c)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "splitChoice"
            , def = "{{class:Category}} {{typevar:p}} {{op:=>}} {{subj:Choice}} {{typevar:p}} {{op:=>}} {{typevar:p}} {{var:a}} {{var:b}} {{op:->}} {{typevar:p}} {{var:c}} {{var:d}} {{op:->}} {{typevar:p}} ({{class:Either}} {{var:a}} {{var:c}}) ({{class:Either}} {{var:b}} {{var:d}})" -- Category p => Choice p => p a b -> p c d -> p (Either a c) (Either b d)
            , belongs = tc.Belongs.No
            , op = Some "+++"
            , opEmoji = tc.noOp
            , laws =
                [
                    { law = "for function"
                    , examples =
                        [ tc.of
                            { fact = "({{op:+++}}) {{op:::}} ({{var:a}} {{op:->}} {{var:b}}) {{op:->}} ({{var:c}} {{op:->}} {{var:d}}) {{op:->}} ({{class:Either}} {{var:a}} {{var:c}}) {{op:->}} ({{class:Either}} {{var:b}} {{var:d}})" -- (+++) :: (a -> b) -> (c -> d) -> (Either a c) -> (Either b d)
                            }
                        ]
                    }
                ]
            }
        ,
            { name = "fanin"
            , def = "{{class:Category}} {{typevar:p}} {{op:=>}} {{subj:Choice}} {{typevar:p}} {{op:=>}} {{typevar:p}} {{var:a}} {{var:c}} {{op:->}} {{typevar:p}} {{var:b}} {{var:c}} {{op:->}} {{typevar:p}} ({{class:Either}} {{var:a}} {{var:b}}) {{var:c}}" -- Category p => Choice p => p a c -> p b c -> p (Either a b) c
            , belongs = tc.Belongs.No
            , op = Some "|||"
            , opEmoji = tc.noOp
            , laws =
                [
                    { law = "for function"
                    , examples =
                        [ tc.of
                            { fact = "({{op:|||}}) {{op:::}} ({{var:a}} {{op:->}} {{var:c}}) {{op:->}} ({{var:b}} {{op:->}} {{var:c}}) {{op:->}} {{class:Either}} {{var:a}} {{var:b}} {{op:->}} {{var:c}}" -- (|||) :: (a -> c) -> (b -> c) -> Either a b -> c
                            }
                        ]
                    }
                ]
            }
        ]
    , instances =
        [ i.instance "Function" "Choice"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in choice