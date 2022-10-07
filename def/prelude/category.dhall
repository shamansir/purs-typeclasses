let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
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
            , def = e.ap3 (e.n "a") (e.t "t") (e.t "t") -- a t t
            , belongs = tc.Belongs.Yes
            , laws =
                [
                    { law = "identity"
                    , examples =
                        [ tc.lmr
                            { left = e.opc2 (e.callE "id") "<<<" (e.n "p") -- id <<< p
                            , middle = e.opc2 (e.n "p") "<<<" (e.callE "id") -- p <<< id
                            , right = e.n "p"
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