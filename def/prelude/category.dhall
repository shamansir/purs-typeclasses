let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class Category :: forall k. (k -> k -> Type) -> Constraint
-- class (Semigroupoid a) <= Category a where

let category : tc.TClass =
    { spec =
        d.class_vpc
            (d.id "category")
            "Category"
            [ d.v "a" ]
            [ d.p (d.id "semigroupoid") "Semigroupoid" [ d.v "a" ] ]
            d.kktc
    , info = "Objects and composable morphisms with their identity"
    , module = [ "Control" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
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
                            { left = e.opc2 (e.callE "identity") "<<<" (e.n "p") -- id <<< p
                            , middle = e.opc2 (e.n "p") "<<<" (e.callE "identity") -- p <<< id
                            , right = e.n "p"
                            }
                        ]
                    }
                ]
            } /\ tc.noOps /\ tc.noExamples
        ]
    , instances =
        [ i.instanceArrow
        , i.instance "Function" "Category"
        ]

    } /\ tc.w 1.6 /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in category