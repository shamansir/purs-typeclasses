let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let costar : tc.TClass =
    { id = "costar"
    , name = "Costar"
    , what = tc.What.Newtype_
    , vars = [ "f", "b", "a" ]
    , info = ""
    , module = [ "Data", "Functor" ]
    , package = tc.pk "purescript-functors" +4 +1 +1
    , link = "purescript-functors/4.1.1/docs/Data.Functor.Costar"
    , members =
        [
            { name = "Costar"
            , def =
                e.subj1 "Costar" (e.br (e.fn2 (e.ap2 (e.f "f") (e.n "b")) (e.n "a")))
                -- Costar (f b -> a)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "hoistCostar"
            , def =
                e.fn3
                    (e.br (e.opc2 (e.f "g") "~>" (e.f "f")))
                    (e.subj "Costar" [ e.f "f", e.n "a", e.n "b" ])
                    (e.subj "Costar" [ e.f "g", e.n "a", e.n "b" ])
                -- (g ~> f) -> Costar f a b -> Costar g a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
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

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in costar