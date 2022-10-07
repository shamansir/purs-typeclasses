let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let bounded : tc.TClass =
    { id = "bounded"
    , name = "Bounded"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , parents = [ "ord" ]
    , info = "Have upper and lower boundary"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Bounded"
    , laws =
        [
            { law = "bounded"
            , examples =
                [ tc.of
                    { fact =
                        e.opc3 (e.callE "bottom") "<=" (e.n "a") "<=" (e.callE "top")
                        -- bottom <= a <= top
                    }
                ]
            }

        ]
    , members =
        [
            { name = "top"
            , def = e.n "a"
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "bottom"
            , def = e.n "a"
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceCl "Boolean"
        , i.instanceCl "Int"
        , i.instanceCl "Char"
        , i.instanceCl "Ordering"
        , i.instanceCl "Unit"
        ]

    } /\ tc.noValues /\ tc.noStatements

in bounded