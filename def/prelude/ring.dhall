let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let ring : tc.TClass =
    { id = "ring"
    , name = "Ring"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , parents = [ "semiring" ]
    , info = "Subtraction"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Ring"
    , members =
        [
            { name = "sub"
            , def = "{{var:a}} {{op:->}} {{var:a}} {{op:->}} {{var:a}}" -- a -> a -> a
            , belongs = tc.Belongs.Yes
            , op = Some "-"
            , opEmoji = tc.noOp
            , laws =
                [
                    { law = "Additive inverse"
                    , examples =
                        [ tc.lmr
                            { left = "{{var:a}} {{op:-}} {{var:a}}" -- a - a
                            , middle = "{{method:zero}} {{op:-}} {{var:a}}" -- zero - a
                            , right = "{{method:zero}}" -- zero
                            }
                        ]
                    }
                ]
            }
        ,
            { name = "negate"
            , def = "{{subj:Ring}} {{var:a}} {{op:=>}} {{var:a}} {{op:->}} {{var:a}}" -- Ring a => a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceCl "Int"
        , i.instanceCl "Number"
        , i.instanceCl "Unit"
        , i.instanceReqSubjArrow "Ring"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in ring