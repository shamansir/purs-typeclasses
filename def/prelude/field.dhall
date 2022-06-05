let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let field : tc.TClass =
    { id = "field"
    , info = "Commutative fields"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , parents = [ "euclidianring", "divisionring" ]
    , name = "Field"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Field"
    , laws =
        [
            { law = "non-zero multiplicative inverse"
            , examples = [
                tc.lr
                    { left = "{{val:0}}" -- 0
                    , right = "{{var:a}} {{method:`mod`}} {{var:b}}"  -- a `mod` b
                    }  --
                ]
            }
        ]
    , instances =
        [ i.instanceCl "Int"
        , i.instanceCl "Number"
        ]

    } /\ tc.noValues /\ tc.noMembers /\ tc.noStatements

in field