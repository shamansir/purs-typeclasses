let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../typedef.dhall
let e = ./../../build_expr.dhall

-- type Lens s t a b = forall p. Strong p => Optic p s t a b

let commonpkg : tc.TClass =
    { id = "lenscommonpkg"
    , name = "Lens.Common"
    , what = tc.What.Package_
    , info = "Common set of lenses"
    , module = [ "Data", "Lens", "Common" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Common"
    , def = d.pkg (d.id "lenscommonpkg") "Lens.Common"
    , members =
        [
            { name = "simple"
            , def =
                e.fn2
                    (e.class "Optic'" [ e.n "p", e.n "s", e.n "a" ])
                    (e.class "Optic'" [ e.n "p", e.n "s", e.n "a" ])
                -- Optic' p s a -> Optic' p s a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            --  X 42 ^. simple _Newtype
        ,
            { name = "_1"
            , def =
                e.class "Lens"
                    [ e.br (e.class "Tuple" [ e.n "a", e.n "c" ])
                    , e.br (e.class "Tuple" [ e.n "b", e.n "c" ])
                    , e.n "a"
                    , e.n "b"
                    ]
                -- Lens (Tuple a c) (Tuple b c) a b
            , belongs = tc.Belongs.Export [ "Data", "Lens", "Lens", "Tuple" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "_2"
            , def =
                e.class "Lens"
                    [ e.br (e.class "Tuple" [ e.n "c", e.n "a" ])
                    , e.br (e.class "Tuple" [ e.n "c", e.n "b" ])
                    , e.n "a"
                    , e.n "b"
                    ]
                -- Lens (Tuple c a) (Tuple c b) a b
            , belongs = tc.Belongs.Export [ "Data", "Lens", "Lens", "Tuple" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "first"
            , def =
                e.req1
                    (e.class1 "Strong" (e.t "p"))
                    (e.fn2
                        (e.ap3 (e.t "p") (e.n "a") (e.n "b"))
                        (e.ap3 (e.t "p") (e.br (e.class "Tuple" [ e.n "a", e.n "c" ])) (e.br (e.class "Tuple" [ e.n "b", e.n "c" ])))
                    )
                -- Strong p => p a b -> p (Tuple a c) (Tuple b c)
            , belongs = tc.Belongs.Export [ "Data", "Profunctor", "Strong" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "second"
            , def =
                e.req1
                    (e.class1 "Strong" (e.t "p"))
                    (e.fn2
                        (e.ap3 (e.t "p") (e.n "b") (e.n "c"))
                        (e.ap3 (e.t "p") (e.br (e.class "Tuple" [ e.n "a", e.n "b" ])) (e.br (e.class "Tuple" [ e.n "a", e.n "c" ])))
                    )
                -- Strong p => p b c -> p (Tuple a b) (Tuple a c)
            , belongs = tc.Belongs.Export [ "Data", "Profunctor", "Strong" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "united"
            , def =
                e.class "Lens'" [ e.n "a", e.classE "Unit" ]
                -- Lens' a Unit
            , belongs = tc.Belongs.Export [ "Data", "Lens", "Lens", "Unit" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- > view united [1,2,3]
            -- unit
            -- > over united (\a -> a :: Unit) [1,2,3]
            -- [1 2 3]
        ,
            { name = "devoid"
            , def =
                e.class "Lens'" [ e.classE "Void", e.n "a" ]
                -- Lens' Void a
            , belongs = tc.Belongs.Export [ "Data", "Lens", "Lens", "Void" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- > view united [1,2,3]
            -- unit
            -- > over united (\a -> a :: Unit) [1,2,3]
            -- [1 2 3]
        ,
            { name = "right"
            , def =
                e.req1
                    (e.class1 "Choice" (e.t "p"))
                    (e.fn2
                        (e.ap3 (e.t "p") (e.n "b") (e.n "c"))
                        (e.ap3 (e.t "p") (e.br (e.class "Either" [ e.n "a", e.n "b" ])) (e.br (e.class "Either" [ e.n "a", e.n "c" ])))
                    )
                -- Choice p => p b c -> p (Either a b) (Either a c)
            , belongs = tc.Belongs.Export [ "Data", "Lens", "Prism", "Either" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "left"
            , def =
                e.req1
                    (e.class1 "Choice" (e.t "p"))
                    (e.fn2
                        (e.ap3 (e.t "p") (e.n "a") (e.n "b"))
                        (e.ap3 (e.t "p") (e.br (e.class "Either" [ e.n "a", e.n "c" ])) (e.br (e.class "Either" [ e.n "b", e.n "c" ])))
                    )
                -- Choice p => p a b -> p (Either a c) (Either b c)
            , belongs = tc.Belongs.Export [ "Data", "Lens", "Prism", "Either" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "_Right"
            , def =
                e.class "Prism"
                    [ e.br (e.class "Either" [ e.n "c", e.n "a" ])
                    , e.br (e.class "Either" [ e.n "c", e.n "b" ])
                    , e.n "a"
                    , e.n "b"
                    ]
                -- Prism (Either c a) (Either b c) a b
            , belongs = tc.Belongs.Export [ "Data", "Lens", "Prism", "Either" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "_Left"
            , def =
                e.class "Prism"
                    [ e.br (e.class "Either" [ e.n "a", e.n "c" ])
                    , e.br (e.class "Either" [ e.n "b", e.n "c" ])
                    , e.n "a"
                    , e.n "b"
                    ]
                -- Prism (Either a c) (Either b c) a b
            , belongs = tc.Belongs.Export [ "Data", "Lens", "Prism", "Either" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "_Nothing"
            , def =
                e.class "Prism"
                    [ e.br (e.class1 "Maybe" (e.n "a"))
                    , e.br (e.class1 "Maybe" (e.n "b"))
                    , e.classE "Unit"
                    , e.classE "Unit"
                    ]
                -- Prism (Maybe a) (Maybe b) Unit Unit
            , belongs = tc.Belongs.Export [ "Data", "Lens", "Prism", "Maybe" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "_Just"
            , def =
                e.class "Prism"
                    [ e.br (e.class1 "Maybe" (e.n "a"))
                    , e.br (e.class1 "Maybe" (e.n "b"))
                    , e.n "a"
                    , e.n "b"
                    ]
                -- Prism (Maybe a) (Maybe b) a b
            , belongs = tc.Belongs.Export [ "Data", "Lens", "Prism", "Maybe" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "_1*"
            , def =
                e.class "Lens"
                    [ e.br (e.class "Product" [ e.f "f", e.f "g", e.n "a" ])
                    , e.br (e.class "Product" [ e.f "h", e.f "g", e.n "a" ])
                    , e.br (e.ap2 (e.f "f") (e.n "a"))
                    , e.br (e.ap2 (e.f "h") (e.n "a"))
                    ]
                -- Lens (Product f g a) (Product h g a) (f a) (h a)
            , belongs = tc.Belongs.Export [ "Data", "Lens", "Lens", "Product" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "_2*"
            , def =
                e.class "Lens"
                    [ e.br (e.class "Product" [ e.f "f", e.f "g", e.n "a" ])
                    , e.br (e.class "Product" [ e.f "f", e.f "h", e.n "a" ])
                    , e.br (e.ap2 (e.f "g") (e.n "a"))
                    , e.br (e.ap2 (e.f "h") (e.n "a"))
                    ]
                -- Lens (Product f g a) (Product f h a) (g a) (h a)
            , belongs = tc.Belongs.Export [ "Data", "Lens", "Lens", "Product" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "_Left*"
            , def =
                e.class "Prism"
                    [ e.br (e.class "Coproduct" [ e.f "f", e.f "g", e.n "a" ])
                    , e.br (e.class "Coproduct" [ e.f "h", e.f "g", e.n "a" ])
                    , e.br (e.ap2 (e.f "f") (e.n "a"))
                    , e.br (e.ap2 (e.f "h") (e.n "a"))
                    ]
                -- Prism (Coproduct f g a) (Coproduct h g a) (f a) (h a)
            , belongs = tc.Belongs.Export [ "Data", "Lens", "Prism", "Coproduct" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "_Right*"
            , def =
                e.class "Prism"
                    [ e.br (e.class "Product" [ e.f "f", e.f "g", e.n "a" ])
                    , e.br (e.class "Product" [ e.f "f", e.f "h", e.n "a" ])
                    , e.br (e.ap2 (e.f "g") (e.n "a"))
                    , e.br (e.ap2 (e.f "h") (e.n "a"))
                    ]
                -- Prism (Coproduct f g a) (Coproduct f h a) (g a) (h a)
            , belongs = tc.Belongs.Export [ "Data", "Lens", "Prism", "Coproduct" ]
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noVars /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in commonpkg