let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let clown : tc.TClass =
    { id = "clown"
    , name = "Clown"
    , what = tc.What.Newtype_
    , vars = [ "f", "a", "b" ]
    , info = ""
    , module = [ "Data", "Functor" ]
    , package = "purescript-functors"
    , link = "purescript-functors/4.1.1/docs/Data.Functor.Clown"
    , members =
        [
            { name = "Clown"
            , def =
                e.class1 "Clown" (e.br (e.ap2 (e.t "f") (e.n "a")))
                -- Clown (f a)
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "hoistClown"
            , def =
                e.fn2
                    (e.br (e.opc2 (e.f "f") "~>" (e.f "g")))
                    (e.opc2
                        (e.subj "Clown" [ e.f "f", e.n "a", e.n "b" ])
                        "~>"
                        (e.subj "Clown" [ e.f "g", e.n "a", e.n "b" ])
                    )
                -- (f ~> g) -> Clown f a b -> Clown g a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceFAB_ "Newtype" "Clown"
        , i.instanceReqFAB_ "Eq" "Clown"
        , i.instanceReqFAB_ "Ord" "Clown"
        , i.instanceReqFAB_ "Show" "Clown"
        , i.instanceFA "Functor" "Clown"
        , i.instanceReqA2 "Functor" "Bifunctor" "Clown"
        , i.instanceReqA2 "Apply" "Biapply" "Clown"
        , i.instanceReqA2 "Applicative" "Applicative" "Clown"
        , i.instanceReqA2 "Contravariant" "Profunctor" "Clown"
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in clown