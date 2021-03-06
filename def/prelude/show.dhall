let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let show : tc.TClass =
    { id = "show"
    , name ="Show"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , info = "Displaying values"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Show"
    , members =
        [
            { name = "show"
            , def = "{{var:a}} {{op:->}} {{class:String}}" -- a -> String
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws

        ]
    , instances =
        [ i.instanceSubj "Boolean" "Show"
        , i.instanceSubj "Int" "Show"
        , i.instanceSubj "Number" "Show"
        , i.instanceSubj "Char" "Show"
        , i.instanceSubj "String" "Show"
        , i.instanceReqASubj "Array" "Show"
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in show