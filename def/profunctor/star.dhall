let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- newtype Star :: forall k. (k -> Type) -> Type -> k -> Type
-- newtype Star f a b

let star : tc.TClass =
    { spec = d.nt_c (d.id "star") "Star" [ d.v "f", d.v "a", d.v "b" ] d.kt_tkt
    , info = ""
    , module = [ "Data", "Profunctor" ]
    , package = tc.pkmj "purescript-profunctor" +5
    , members =
        [
            { name = "Star"
            , def = e.subj1 "Star" (e.br (e.fn2 (e.n "a") (e.ap2 (e.f "f") (e.n "b")))) -- Star (a -> f b)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "hoistStar"
            , def =
                e.fn3
                    (e.br (e.opc2 (e.f "f") "~>" (e.f "g")))
                    (e.subj "Star" [ e.f "f", e.n "a", e.n "a" ])
                    (e.subj "Star" [ e.f "g", e.n "a", e.n "a" ])
                -- (f ~> g) -> Star f a b -> Star g a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ e.class "Newtype" [ e.br (e.class "Star" [ e.t "f", e.n "a", e.n "b" ]), e.ph ] -- Newtype (Star f a b) _
        , i.instanceReqF2 "Bind" "Semigroupoid" "Star"
        , i.instanceReqF2 "Monad" "Category" "Star"
        , i.instanceReqFA "Functor" "Star"
        , i.instanceReqFA "Invariant" "Star"
        , i.instanceReqFA "Apply" "Star"
        , i.instanceReqFA "Applicative" "Star"
        , i.instanceReqFA "Bind" "Star"
        , i.instanceReqFA "Monad" "Star"
        , i.instanceReqFA "Alt" "Star"
        , i.instanceReqFA "Plus" "Star"
        , i.instanceReqFA "Alternative" "Star"
        , i.instanceReqFA "MonadZero" "Star"
        , i.instanceReqFA "MonadPlus" "Star"
        , i.instanceReqFA "Distributive" "Star"
        , i.instanceReqF2 "Functor" "Profunctor" "Star"
        , i.instanceReqF2 "Functor" "Strong" "Star"
        , i.instanceReqF2 "Applicative" "Choice" "Star"
        , i.instanceReqF2 "Distributive" "Closed" "Star"
        ]
    } /\ tc.aw /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in star