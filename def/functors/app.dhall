let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let d = ./../../spec.dhall
let i = ./../../instances.dhall

-- newtype App :: forall k. (k -> Type) -> k -> Type
-- newtype App f a

let app : tc.TClass =
    { id = "app"
    , name = "App"
    , what = tc.What.Newtype_
    , vars = [ "f", "a" ]
    , info = ""
    , module = [ "Data", "Functor" ]
    , package = tc.pk "purescript-functors" +4 +1 +1
    , link = "purescript-functors/4.1.1/docs/Data.Functor.App"
    , spec = d.nt_c (d.id "app") "App" [ d.v "f", d.v "a" ] d.kt_kt
    , members =
        [
            { name = "App"
            , def = e.subj1 "App" (e.br (e.ap2 (e.f "f") (e.n "a"))) -- App (f a)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "hoistApp"
            , def =
                e.fn2
                    (e.br (e.opc2 (e.f "f") "~>" (e.f "g")))
                    (e.opc2
                        (e.br (e.subj1 "App" (e.f "f")))
                        "~>"
                        (e.br (e.subj1 "App" (e.f "g")))
                    )
                -- (f ~> g) -> (App f) ~> (App g)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "hoistLiftApp"
            , def =
                e.fn2
                    (e.ap2 (e.f "f") (e.br (e.ap2 (e.f "g") (e.n "a"))))
                    (e.ap2 (e.f "f") (e.br (e.subj "App" [ e.f "g", e.n "a" ])))
                -- f (g a) -> f (App g a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "hoistLowerApp"
            , def =
                e.fn2
                    (e.ap2 (e.f "f") (e.br (e.subj "App" [ e.f "g", e.n "a" ])))
                    (e.ap2 (e.f "f") (e.br (e.ap2 (e.f "g") (e.n "a"))))
                -- f (App g a) -> f (g a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceFA_ "Newtype" "App"
        , i.instanceReqFA2 "Eq" "Eq1" "App"
        , i.instanceReqF "Eq" "App"
        , i.instanceReqFA2 "Ord" "Ord1" "App"
        , i.instanceReqF "Ord" "App"
        , i.instanceReqFA_ "Show" "App"
        , i.instanceReqFA2 "Semigroup" "Apply" "App"
        , i.instanceReqFA2 "Monoid" "Applicative" "App"
        , i.instanceReqF "MonadZero" "App"
        , i.instanceReqF "Functor" "App"
        , i.instanceReqF "Apply" "App"
        , i.instanceReqF "Applicative" "App"
        , i.instanceReqF "Bind" "App"
        , i.instanceReqF "Monad" "App"
        , i.instanceReqF "Alt" "App"
        , i.instanceReqF "Plus" "App"
        , i.instanceReqF "Alternative" "App"
        , i.instanceReqF "MonadPlus" "App"
        , i.instanceReqFA_ "Lazy" "App"
        , i.instanceReqF "Extend" "App"
        , i.instanceReqF "Comonad" "App"
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in app