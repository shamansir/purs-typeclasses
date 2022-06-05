let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let category : tc.TClass =
    { id = "category"
    , name = "Category"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , parents = [ "semigroupoid" ]
    , info = "Objects and composable morphisms with their identity"
    , module = [ "Control" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Control.Category#t:Category"
    , members =
        [
            { name = "identity"
            , def = "{{var:a}} {{typevar:t}} {{typevar:t}}" -- a t t
            , belongs = tc.Belongs.Yes
            , laws =
                [
                    { law = "identity"
                    , examples =
                        [ tc.lmr
                            { left = "{{method:identity}} {{op:<<<}} {{var:p}}" -- id <<< p
                            , middle = "{{var:p}} {{op:<<<}} {{method:identity}}" -- p <<< id
                            , right = "{{var:p}}" -- p
                            }
                        ]
                    }
                ]
            } /\ tc.noOps
        ]
    , instances =
        [ i.instanceArrow
        , i.instance "Function" "Category"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in category