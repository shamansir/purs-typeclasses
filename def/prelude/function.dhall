let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

let function : tc.TClass =
    { spec = d.int (d.id "function") "Function"
    , info = "Helpers for the core functions"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , members =
        [
            { name = "flip"
            , def =
                e.fn
                    [ e.br (e.fn3 (e.n "a") (e.n "b") (e.n "c"))
                    , e.n "b"
                    , e.n "a"
                    , e.n "c"
                    ]
                -- (a -> b -> c) -> b -> a -> c
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "const"
            , def =
                e.fn3 (e.n "a") (e.n "b") (e.n "a")
                -- a -> b -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "apply"
            , def =
                e.fn3 (e.br (e.fn2 (e.n "a") (e.n "b"))) (e.n "a") (e.n "b")
                -- (a -> b) -> a -> b
            , belongs = tc.Belongs.No
            , op = Some "$"
            , opEmoji = Some "💨"
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "applyFlipped"
            , def =
                e.fn3 (e.n "a") (e.br (e.fn2 (e.n "a") (e.n "b"))) (e.n "b")
                -- a -> (a -> b) -> b
            , belongs = tc.Belongs.No
            , op = Some "#"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "on"
            , def =
                e.fn
                    [ e.br (e.fn3 (e.n "b") (e.n "b") (e.n "c"))
                    , e.br (e.fn2 (e.n "b") (e.n "b"))
                    , e.n "a"
                    , e.n "a"
                    , e.n "c"
                    ]
                -- (b -> b -> c) -> (a -> b) -> a -> a -> c
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]

    } /\ tc.aw /\ tc.noLaws /\ tc.noInstances /\ tc.noValues /\ tc.noStatements

in function