let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../typedef.dhall
let e = ./../../build_expr.dhall

-- class (Monad m, Alternative m, MonadZeroIsDeprecated) <= MonadZero m

let monadzero : tc.TClass =
    { id = "monadzero"
    , name = "MonadZero"
    , what = tc.What.Class_
    , vars = [ "m" ]
    , parents = [ "monad", "alternative" ]
    , info = "Compose computations"
    , module = [ "Control" ]
    , package = tc.pkmj "purescript-control" +5
    , link = "purescript-control/5.0.0/docs/Control.MonadZero"
    , def =
        d.class_vp
            (d.id "monadzero")
            "MonadZero"
            [ d.v "m" ]
            [ d.p (d.id "monad") "Monad" [ d.v "m" ]
            , d.p (d.id "alternative") "Alternative" [ d.v "m" ]
            , d.pe (d.id "monadzeroisdeprecated") "MonadZeroIsDeprecated"
            ]
    , laws =
        [
            { law = "annihilation"
            , examples =
                [ tc.lr
                    { left =
                        -- empty >>= f
                        e.opc2
                            (e.callE "empty")
                            ">>="
                            (e.f "f")
                    , right =
                        -- empty
                        e.callE "empty"
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
                    (e.subj1 "MonadZero" (e.t "m"))
                    (e.fn2
                        (e.classE "Boolean")
                        (e.ap2 (e.t "m") (e.classE "Unit"))
                    )
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceCl "Array"
        ]

    } /\ tc.noValues /\ tc.noStatements

in monadzero