let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class Lazy l where

let lazy : tc.TClass =
    { id = "lazy"
    , name = "Lazy"
    , what = tc.What.Class_
    , vars = [ "l" ]
    , info = "Deferred operations"
    , module = [ "Control" ]
    , package = tc.pkmj "purescript-control" +5
    , link = "purescript-control/5.0.0/docs/Control.Lazy"
    , spec = d.class_v (d.id "lazy") "Lazy" [ d.v "l" ]
    , members =
        [
            { name = "defer"
            , def =
                -- (Unit -> l) -> l
                e.fn2
                    (e.br (e.fn2 (e.classE "Unit") (e.t "l")))
                    (e.t "l")
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "fix"
            , def =
                -- Lazy l => (l -> l) -> l
                e.req1
                    (e.subj1 "Lazy" (e.t "l"))
                    (e.fn2
                        (e.br (e.fn2 (e.t "l") (e.t "l")))
                        (e.t "l")
                    )
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceFn
        , i.instanceCl "Unit"
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in lazy