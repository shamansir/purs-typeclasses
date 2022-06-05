let tc = ./../../typeclass.dhall

let function : tc.TClass =
    { id = "function"
    , name = "Function"
    , what = tc.What.Internal_
    , info = "Helpers for the core functions"
    , module = [ "Data" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Data.Function"
    , members =
        [
            { name = "flip"
            , def = "({{var:a}} {{op:->}} {{var:b}} {{op:->}} {{var:c}}){{op:->}} {{var:b}} {{op:->}} {{var:a}} {{op:->}} {{var:c}}" -- (a -> b -> c) -> b -> a -> c
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "const"
            , def = "{{var:a}} {{op:->}} {{var:b}} {{op:->}} {{var:a}}" -- a -> b -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "apply"
            , def = "({{var:a}} {{op:->}} {{var:b}}) {{op:->}} {{var:a}} {{op:->}} {{var:b}}" -- (a -> b) -> a -> b
            , belongs = tc.Belongs.No
            , op = Some "$"
            , opEmoji = Some "💨"
            } /\ tc.noLaws
        ,
            { name = "applyFlipped"
            , def = "{{var:a}} {{op:->}} ({{var:a}} {{op:->}} {{var:b}}) {{op:->}} {{var:b}}" -- a -> (a -> b) -> b
            , belongs = tc.Belongs.No
            , op = Some "#"
            , opEmoji = tc.noOp
            } /\ tc.noLaws
        ,
            { name = "on"
            , def = "({{var:b}} {{op:->}} {{var:b}} {{op:->}} {{var:c}}) {{op:->}} ({{var:a}} {{op:->}} {{var:b}}) {{op:->}} {{var:a}} {{op:->}} {{var:a}} {{op:->}} {{var:c}}" -- (b -> b -> c) -> (a -> b) -> a -> a -> c
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]

    } /\ tc.noLaws /\ tc.noParents /\ tc.noInstances /\ tc.noValues /\ tc.noStatements /\ tc.noVars

in function