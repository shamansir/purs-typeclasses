let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall


-- newtype Costar :: (Type -> Type) -> Type -> Type -> Type
-- newtype Costar f b a

let costar : tc.TClass =
    { id = "costar"
    , name = "Costar"
    , what = tc.What.Newtype_
    , vars = [ "f", "b", "a" ]
    , info = ""
    , module = [ "Data", "Functor" ]
    , package = tc.pk "purescript-functors" +4 +1 +1
    , link = "purescript-functors/4.1.1/docs/Data.Functor.Costar"
    , spec = d.nt_c (d.id "costar") "Costar" [ d.v "f", d.v "b", d.v "a" ] d.t2t3
    , members =
        [
            { name = "Costar"
            , def =
                e.subj1 "Costar" (e.br (e.fn2 (e.ap2 (e.f "f") (e.n "b")) (e.n "a")))
                -- Costar (f b -> a)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "hoistCostar"
            , def =
                e.fn3
                    (e.br (e.opc2 (e.f "g") "~>" (e.f "f")))
                    (e.subj "Costar" [ e.f "f", e.n "a", e.n "b" ])
                    (e.subj "Costar" [ e.f "g", e.n "a", e.n "b" ])
                -- (g ~> f) -> Costar f a b -> Costar g a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    , instances =
        [ i.instanceFAB_ "Newtype" "Costar"
        , i.instanceReqF2 "Extend" "Semigroupoid" "Costar"
        , i.instanceReqF2 "Comonad" "Category" "Costar"
        , i.instanceFA "Functor" "Costar"
        , i.instanceFA "Invariant" "Costar"
        , i.instanceFA "Apply" "Costar"
        , i.instanceFA "Applicative" "Costar"
        , i.instanceFA "Bind" "Costar"
        , i.instanceFA "Monad" "Costar"
        , i.instanceFA "Distributive" "Costar"
        , i.instanceReqF2 "Contravariant" "Bifunctor" "Costar"
        , i.instanceReqF2 "Functor" "Profunctor" "Costar"
        , i.instanceReqF2 "Comonad" "Strong" "Costar"
        , i.instanceReqF2 "Functor" "Closed" "Costar"
        ]

    } /\ tc.aw /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in costar