let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let costrong : tc.TClass =
    { id = "costrong"
    , name = "Costrong"
    , what = tc.What.Class_
    , vars = [ "p" ]
    , parents = [ "profunctor" ]
    , info = "Provides the dual operations of the Strong class"
    , module = [ "Data", "Profunctor" ]
    , package = "purescript-profunctor"
    , link = "purescript-profunctor/5.0.0/docs/Data.Profunctor.Costrong"
    , members =
        [
            { name = "unfirst"
            , def = "{{typevar:p}} ({{class:Tuple}} {{var:a}} {{var:c}}) ({{class:Tuple}} {{var:b}} {{var:c}}) {{op:->}} {{typevar:p}} {{var:a}} {{var:b}}" -- p (Tuple a c) (Tuple b c) -> p a b
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "unsecond"
            , def = "{{typevar:p}} ({{class:Tuple}} {{var:a}} {{var:b}}) ({{class:Tuple}} {{var:a}} {{var:c}}) {{op:->}} {{typevar:p}} {{var:b}} {{var:c}}" -- p (Tuple a b) (Tuple a c) -> p b c
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instance "Function" "Closed"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in costrong