let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let cochoice : tc.TClass =
    { id = "cochoice"
    , name = "Cochoice"
    , what = tc.What.Class_
    , vars = [ "p" ]
    , parents = [ "profunctor" ]
    , info = "Provides the dual operations of the Choice class"
    , module = [ "Data", "Profunctor" ]
    , package = "purescript-profunctor"
    , link = "purescript-profunctor/5.0.0/docs/Data.Profunctor.Cochoice"
    , members =
        [
            { name = "unleft"
            , def = "{{typevar:p}} ({{class:Either}} {{var:a}} {{var:c}}) ({{class:Either}} {{var:b}} {{var:c}}) {{op:->}} {{typevar:p}} {{var:a}} {{var:b}}" -- p (Either a c) (Either b c) -> p a b
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "unright"
            , def = "{{typevar:p}} ({{class:Either}} {{var:a}} {{var:b}}) ({{class:Either}} {{var:a}} {{var:c}}) {{op:->}} {{typevar:p}} {{var:b}} {{var:c}}" -- p (Either a b) (Either a c) -> p b c
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instance "Function" "Closed"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in cochoice