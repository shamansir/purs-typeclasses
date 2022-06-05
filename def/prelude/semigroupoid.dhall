let tc = ./../../typeclass.dhall

let semigroupoid : tc.TClass =
    { id = "semigroupoid"
    , name = "Semigroupoid"
    , what = tc.What.Class_
    , vars = [ "a" ]
    , info = "Category without identity"
    , module = [ "Control" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Control.Semigroupoid"
    , members =
        [
            { name = "compose"
            , def = "{{var:a}} {{var:c}} {{var:d}} {{op:->}} {{var:a}} {{var:b}} {{var:c}} {{op:->}} {{var:a}} {{var:b}} {{var:d}}" -- a c d -> a b c -> a b d
            , belongs = tc.Belongs.Yes
            , op = Some "<<<"
            , opEmoji = Some  "🔙"
            , laws =
                [
                    { law = "associativity"
                    , examples =
                        [ tc.lr
                            { left = "{{var:p}} {{op:<<<}} ({{var:q}} {{op:<<<}} {{var:r}})" -- p <<< (q <<< r)
                            , right = "({{var:p}} {{op:<<<}} {{var:q}}) {{op:<<<}} {{var:r}}" -- (p <<< q) <<< r
                            }
                        ]
                    }
                ]
            }
        ,
            { name = "composeFlipped"
            , def = "{{subj:Semigroupoid}} {{var:a}} {{op:=>}} {{var:a}} {{var:b}} {{var:c}} {{op:->}} {{var:a}} {{var:c}} {{var:d}} {{op:->}} {{var:a}} {{var:b}} {{var:d}}" -- Semigroupoid a => a b c -> a c d -> a b d
            , belongs = tc.Belongs.No
            , op = Some ">>>"
            , opEmoji = Some "🔜"
            } /\ tc.noLaws
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noInstances /\ tc.noValues /\ tc.noStatements

in semigroupoid