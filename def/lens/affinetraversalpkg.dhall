let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../typedef.dhall
let e = ./../../build_expr.dhall


let affinetraversalpkg : tc.TClass =
    { id = "affinetraversalpkg"
    , name = "Lens.AffineTraversal"
    , what = tc.What.Package_
    , info = "Lenses for Affine Traversals"
    , module = [ "Data", "Lens", "AffineTraversal" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.AffineTraversal"
    , def = d.pkg (d.id "affinetraversalpkg") "Lens.AffineTraversal"
    , members =
        [
            { name = "affineTraversal"
            , def =
                e.fn3
                    (e.br (e.fn3 (e.n "s") (e.n "b") (e.n "t")))
                    (e.br (e.fn2 (e.n "s") (e.class "Either" [ e.n "t", e.n "a" ])))
                    (e.class "AffineTraversal" [ e.n "s", e.n "t", e.n "a", e.n "b" ])
                -- (s -> b -> t) -> (s -> Either t a) -> AffineTraversal s t a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "affineTraversal'"
            , def =
                e.fn2
                    (e.br
                        (e.fn2
                            (e.n "s")
                            (e.class "Tuple"
                                [ e.br (e.fn2 (e.n "b") (e.n "t"))
                                , e.br (e.class "Tuple" [ e.n "t", e.n "a" ])
                                ]
                            )
                        )
                    )
                    (e.class "AffineTraversal" [ e.n "s", e.n "t", e.n "a", e.n "b" ])
                -- (s -> Tuple (b -> t) (Either t a)) -> AffineTraversal s t a b
            , belongs = tc.Belongs.No
            , op = Some "^.."
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "withAffineTraversal"
            , def =
                e.fn3
                    (e.class "AnAffineTraversal" [ e.n "s", e.n "t", e.n "a", e.n "b" ])
                    (e.br
                        (e.fn3
                            (e.br (e.fn3 (e.n "s") (e.n "b") (e.n "t")))
                            (e.br (e.fn2 (e.n "s") (e.class "Either" [ e.n "t", e.n "a" ])))
                            (e.n "r")
                        )
                    )
                    (e.n "r")
                -- AnAffineTraversal s t a b -> ((s -> b -> t) -> (s -> Either t a) -> r) -> r
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "cloneAffineTraversal"
            , def =
                e.fn2
                    (e.class "AnAffineTraversal" [ e.n "s", e.n "t", e.n "a", e.n "b" ])
                    (e.class "AffineTraversal" [ e.n "s", e.n "t", e.n "a", e.n "b" ])
                -- AnAffineTraversal s t a b -> AffineTraversal s t a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noVars /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in affinetraversalpkg