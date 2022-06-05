let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

let monadzero : tc.TClass =
    { id = "monadzero"
    , name = "MonadZero"
    , what = tc.What.Class_
    , vars = [ "m" ]
    , parents = [ "monad", "alternative" ]
    , info = "Compose computations"
    , module = [ "Control" ]
    , package = "purescript-control"
    , link = "purescript-control/5.0.0/docs/Control.MonadZero"
    , laws =
        [
            { law = "annihilation"
            , examples =
                [ tc.lr
                    { left =
                        -- empty >>= f
                        e.inf
                            ">>="
                            (e.callE "empty")
                            (e.vf "f")
                    , right =
                        -- empty
                        e.val (e.callE "empty")
                    }
                ]
            }
        ]
    , members =
        [
            { name = "guard" -- FIXME: moved to `Alternative`
            , def =
                --  MonadZero m => Boolean -> m Unit
                e.req1
                    (e.subj_ "MonadZero" [ e.t "m" ])
                    (e.rtv
                        (e.fn
                            (e.classE "Boolean")
                            (e.ap_ (e.t "m") [ e.rv (e.classE "Unit") ])
                        )
                    )
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceCl "Array"
        ]

    } /\ tc.noValues /\ tc.noStatements

in monadzero