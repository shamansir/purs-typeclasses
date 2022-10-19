let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- type Lens s t a b = forall p. Strong p => Optic p s t a b

let lens : tc.TClass =
    { id = "lens"
    , name = "Lens"
    , what = tc.What.Type_
    , vars = [ "s", "t", "a", "b" ]
    , info = "Given a type whose \"focus element\" always exists, a lens provides a convenient way to view, set, and transform that element."
    , module = [ "Data", "Lens" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens"
    , members =
        [
            { name = "Lens"
            , def =
                e.req1
                    (e.class1 "Strong" (e.n "p"))
                    (e.class "Optic" [ e.n "p", e.n "s", e.n "p", e.n "p", e.n "p" ] )
                -- Strong p => Optic p s t a b
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "simple"
            , def =
                e.fn2
                    (e.class "Optic'" [ e.n "p", e.n "s", e.n "a" ])
                    (e.class "Optic'" [ e.n "p", e.n "s", e.n "a" ])
                -- Optic' p s a -> Optic' p s a
            , belongs = tc.Belongs.Export [ "Data", "Lens", "Common" ]
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
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in lens