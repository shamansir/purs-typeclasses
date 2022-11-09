let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class Show a where

let show : tc.TClass =
    { spec =
        d.class_v
            (d.id "show")
            "Show"
            [ d.v "a" ]
    , info = "Displaying values"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , members =
        [
            { name = "show"
            , def = e.fn2 (e.n "a") (e.classE "String") -- a -> String
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples

        ]
    , instances =
        [ i.instanceSubj "Boolean" "Show"
        , i.instanceSubj "Int" "Show"
        , i.instanceSubj "Number" "Show"
        , i.instanceSubj "Char" "Show"
        , i.instanceSubj "String" "Show"
        , i.instanceReqASubj "Array" "Show"
        ]

    } /\ tc.aw /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in show