let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

let lazy : tc.TClass =
    { id = "lazy"
    , name = "Lazy"
    , what = tc.What.Class_
    , vars = [ "l" ]
    , info = "Deferred operations"
    , module = [ "Control" ]
    , package = "purescript-control"
    , link = "purescript-control/5.0.0/docs/Control.Lazy"
    , members =
        [
            { name = "defer"
            , def =
                -- (Unit -> l) -> l
                e.fn2
                    (e.br (e.fn2 (e.classE "Unit") (e.t "l")))
                    (e.t "l")
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
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
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceFn
        , i.instanceCl "Unit"
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in lazy