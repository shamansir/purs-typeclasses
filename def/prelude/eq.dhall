let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let eq : tc.TClass =
    { id = "eq"
    , name = "Eq"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , info = "Equality"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Eq"
    , members =
        [
            { name = "eq"
            , def = "{{var:a}} {{op:->}} {{var:a}} {{op:->}} {{class:Boolean}}" -- a -> a -> Boolean
            , op = Some "=="
            , opEmoji = tc.noOp
            , belongs = tc.Belongs.Yes
            , laws =
                [
                    { law = "reflexivity"
                    , examples =
                        [ tc.lr
                            { left = "{{var:x}} {{op:==}} {{var:x}}" -- x == x
                            , right = "{{val:true}}" -- true
                            }
                        ]
                    }
                ,
                    { law = "symmetry"
                    , examples =
                        [ tc.lr
                            { left = "{{var:x}} {{op:==}} {{var:y}}" -- x == y
                            , right = "{{var:y}} {{op:==}} {{var:x}}" -- y == x
                            }
                        ]
                    }
                ,
                    { law = "transitivity"
                    , examples =
                        [ tc.fc
                            { fact = "({{var:x}} {{op:==}} {{var:y}}) {{method:and}} ({{var:y}} {{op:==}} {{var:z}})" -- (x == y) and (y == z)
                            , conclusion = "{{var:y}} {{op:==}} {{var:x}}" -- y == x
                            }
                        ]
                    }
                ]
            }
        ,
            { name = "notEq"
            , def = "{{subj:Eq}} {{var:a}} {{op:=>}} {{var:a}} {{op:->}} {{var:a}} {{op:->}} {{class:Boolean}}" -- Eq a => a -> a -> Boolean
            , belongs = tc.Belongs.No
            , op = Some "/="
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ]
    , instances =
        [ i.instanceCl "Boolean"
        , i.instanceCl "Int"
        , i.instanceCl "Number"
        , i.instanceCl "Char"
        , i.instanceCl "String"
        , i.instanceCl "Unit"
        , i.instanceCl "Void"
        , i.instanceReqASubj "Array" "Eq"
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in eq