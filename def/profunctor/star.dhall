let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

-- newtype Star :: forall k. (k -> Type) -> Type -> k -> Type
-- newtype Star f a b

let star : tc.TClass =
    { id = "star"
    , name = "Star"
    , what = tc.What.Newtype_
    , vars = [ "f", "a", "b" ]
    , info = ""
    , module = [ "Data", "Profunctor" ]
    , package = tc.pkmj "purescript-profunctor" +5
    , link = "purescript-profunctor/5.0.0/docs/Data.Profunctor.Star"
    , members =
        [
            { name = "Star"
            , def = e.subj1 "Star" (e.br (e.fn2 (e.n "a") (e.ap2 (e.f "f") (e.n "b")))) -- Star (a -> f b)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "hoistStar"
            , def =
                e.fn3
                    (e.br (e.opc2 (e.f "f") "~>" (e.f "g")))
                    (e.subj "Star" [ e.f "f", e.n "a", e.n "a" ])
                    (e.subj "Star" [ e.f "g", e.n "a", e.n "a" ])
                -- (f ~> g) -> Star f a b -> Star g a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
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
    } /\ tc.noLaws /\ tc.noValues /\ tc.noParents /\ tc.noStatements

in star