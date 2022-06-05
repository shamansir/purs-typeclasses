let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let closed : tc.TClass =
    { id = "closed"
    , name = "Closed"
    , what = tc.What.Class_
    , vars = [ "p" ]
    , parents = [ "profunctor" ]
    , info = "Extends Profunctor to work with functions"
    , module = [ "Data", "Profunctor" ]
    , package = "purescript-profunctor"
    , link = "purescript-profunctor/5.0.0/docs/Data.Profunctor.Closed"
    , members =
        [
            { name = "closed"
            , def = "{{typevar:p}} {{var:a}} {{var:b}} {{op:->}} {{typevar:p}} ({{var:x}} {{op:->}} {{var:a}}) ({{var:x}} {{op:->}} {{var:b}})" -- p a b -> p (x -> a) (x -> b)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instance "Function" "Closed"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in closed