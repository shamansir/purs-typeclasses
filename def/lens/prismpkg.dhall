let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e_ = ./../../expr.dhall
let e = ./../../build_expr.dhall


let pstab = e.class "Prism" [ e.n "s", e.n "t", e.n "a", e.n "b" ] -- Prism s t a b
let apstab = e.class "APrism" [ e.n "s", e.n "t", e.n "a", e.n "b" ] -- APrism s t a b

let prismpkg : tc.TClass =
    { spec = d.pkg (d.id "prismpkg") "Lens.Prism"
    , info = "Prisms are used for selecting cases of a type, most often a sum type"
    , module = [ "Data", "Lens", "Prism" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , members =
        [
            { name = "prism'"
            , def =
                e.fn3
                    (e.br (e.fn2 (e.n "a") (e.n "s")))
                    (e.br (e.fn2 (e.n "s") (e.class1 "Maybe" (e.n "a"))))
                    (e.class "Prism'" [ e.n "s", e.n "a" ])
                -- (a -> s) -> (s -> Maybe a) -> Prism' s a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- solidFocus :: Prism' Fill Color
            -- solidFocus = prism' Solid case _ of
            --     Solid color -> Just color
            --     _ -> Nothing
        ,
            { name = "prism"
            , def =
                e.fn3
                    (e.br (e.fn2 (e.n "b") (e.n "t")))
                    (e.br (e.fn2 (e.n "s") (e.class "Either" [ e.n "t", e.n "a" ])))
                    pstab
                -- (b -> t) -> (s -> Either t a) -> Prism s t a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- solidFocus :: Prism' Fill Color
            -- solidFocus = prism Solid case _ of
            --     Solid color -> Right color
            --     anotherCase -> Left anotherCase
        ,
            { name = "only"
            , def =
                e.req1
                    (e.class1 "Eq" (e.n "a"))
                    (e.fn2
                        (e.n "a")
                        (e.class "Prism'" [ e.n "a", e.classE "Unit" ])
                        -- (e.class "Prism" [ e.n "a", e.n "a", e.classE "Unit", e.classE "Unit" ]) -- Prism' a Unit ?
                    )
                -- Eq a => a -> Prism a a Unit Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- solidWhiteFocus :: Prism' Fill Unit
            -- solidWhiteFocus = only $ Solid Color.white

            -- is      solidWhiteFocus (Solid Color.white) == true
            -- preview solidWhiteFocus (Solid Color.white) == Just unit
            -- review  solidWhiteFocus unit                == Solid Color.white
        ,
            { name = "nearly"
            , def =
                e.fn3
                    (e.n "a")
                    (e.br (e.fn2 (e.n "a") (e.classE "Boolean")))
                    (e.class "Prism'" [ e.n "a", e.classE "Unit" ])
                -- a -> (a -> Boolean) -> Prism' a Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- solidWhiteFocus :: Prism' Fill Unit
            -- solidWhiteFocus = nearly (Solid Color.white) predicate
            --     where
            --         predicate candidate =
            --             color.toHexString == Color.white.toHexString
        ,
            { name = "review"
            , def =
                e.fn3
                    (e.class "Review" [ e.n "s", e.n "t", e.n "a", e.n "b" ])
                    (e.n "b")
                    (e.n "t")
                -- Review s t a b -> b -> t
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- review solidFocus Color.white == Solid Color.white
        ,
            { name = "is"
            , def =
                e.req1
                    (e.class1 "HeytingAlgebra" (e.n "r"))
                    (e.fn3 apstab (e.n "s") (e.n "r"))
                -- HeytingAlgebra r => APrism s t a b -> s -> r
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "isn't"
            , def =
                e.req1
                    (e.class1 "HeytingAlgebra" (e.n "r"))
                    (e.fn3 apstab (e.n "s") (e.n "r"))
                -- HeytingAlgebra r => APrism s t a b -> s -> r
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "matching"
            , def = e.fn3 apstab (e.n "s") (e.class "Either" [ e.n "t", e.n "a" ])
                -- APrism s t a b -> s -> Either t a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "clonePrism"
            , def = e.fn2 apstab pstab
                -- APrism s t a b -> Prism s t a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "withPrism"
            , def =
                e.fn3
                    apstab
                    (e.br (e.fn3
                        (e.br (e.fn2 (e.n "b") (e.n "t")))
                        (e.br (e.fn2 (e.n "s") (e.class "Either" [ e.n "t", e.n "a" ])))
                        (e.n "r")
                    ))
                    (e.n "r")
                -- APrism s t a b -> ((b -> t) -> (s -> Either t a) -> r) -> r
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "below"
            , def =
                e.req1
                    (e.class1 "Traversable" (e.f "f"))
                    (e.fn2
                        (e.class "APrism'" [ e.n "s", e.n "a" ])
                        (e.class "Prism'"
                            [ e.br (e.ap2 (e.f "f") (e.n "s"))
                            , e.br (e.ap2 (e.f "f") (e.n "a"))
                            ]
                        )
                    )
                -- Traversable f => APrism' s a -> Prism' (f s) (f a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.aw /\ tc.noInstances /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in prismpkg