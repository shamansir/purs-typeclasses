let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let split : tc.TClass =
    { id = "split"
    , name = "Split"
    , what = tc.What.Newtype_
    , vars = [ "f", "a", "b" ]
    , info = ""
    , module = [ "Data", "Profunctor" ]
    , package = tc.pkmj "purescript-profunctor" +5
    , link = "purescript-profunctor/5.0.0/docs/Data.Profunctor.Split"
    , members =
        [
            { name = "split"
            , def =
                e.fn
                    [ e.br (e.fn2 (e.n "a") (e.n "x"))
                    , e.br (e.fn2 (e.n "x") (e.n "b"))
                    , e.ap2 (e.f "f") (e.n "x")
                    , e.subj "Split" [ e.f "f", e.n "a", e.n "b" ]
                    ]
                -- (a -> x) -> (x -> b) -> f x -> Split f a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "unSplit"
            , def =
                e.fn3
                    (e.br ( e.fall1 (e.av "x")
                        (e.fn
                            [ e.br (e.fn2 (e.n "a") (e.n "x"))
                            , e.br (e.fn2 (e.n "x") (e.n "b"))
                            , e.ap2 (e.f "f") (e.n "x")
                            , e.n "r"
                            ]
                        )
                    ))
                    (e.subj "Split" [ e.f "f", e.n "a", e.n "b" ])
                    (e.n "r")
                 -- (forall x. (a -> x) -> (x -> b) -> f x -> r) -> Split f a b -> r
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "liftSplit"
            , def =
                e.fn2
                    (e.ap2 (e.f "f") (e.n "a"))
                    (e.subj "Split" [ e.f "f", e.n "a", e.n "a" ])
                -- f a -> Split f a a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "lowerSplit"
            , def =
                e.req1
                    (e.class1 "Invariant" (e.f "f"))
                    (e.fn2
                        (e.subj "Split" [ e.f "f", e.n "a", e.n "a" ])
                        (e.ap2 (e.f "f") (e.n "a"))
                    )
                -- Invariant f => Split f a a -> f a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "hoistSplit"
            , def =
                e.fn3
                    (e.br (e.opc2 (e.f "f") "~>" (e.f "g")))
                    (e.subj "Split" [ e.f "f", e.n "a", e.n "a" ])
                    (e.subj "Split" [ e.f "g", e.n "a", e.n "a" ])
                -- (f ~> g) -> Split f a b -> Split g a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceFA "Functor" "Split"
        , i.instanceF "Profunctor" "Split"
        ]

    } /\ tc.noLaws /\ tc.noValues /\ tc.noParents /\ tc.noStatements

in split