let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e_ = ./../../expr.dhall
let e = ./../../build_expr.dhall


let lstab = e.class "Lens" [ e.n "s", e.n "t", e.n "a", e.n "b" ] -- Lens s t a b
let alstab = e.class "ALens" [ e.n "s", e.n "t", e.n "a", e.n "b" ] -- ALens s t a b
let ilistab = e.class "IndexedLens" [ e.n "i", e.n "s", e.n "t", e.n "a", e.n "b" ] -- IndexedLens i s t a b
let anilistab = e.class "AnIndexedLens" [ e.n "i", e.n "s", e.n "t", e.n "a", e.n "b" ] -- AnIndexedLens i s t a b

let lenspkg : tc.TClass =
    { spec = d.pkg (d.id "lenspkg") "Lens.Lens"
    , info = "Functions for working with lenses"
    , module = [ "Data", "Lens", "Lens" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , members =
        [
            { name = "lens"
            , def =
                e.fn3
                    (e.br (e.fn2 (e.n "s") (e.n "a")))
                    (e.br (e.fn3 (e.n "s") (e.n "b") (e.n "t")))
                    lstab
                -- (s -> a) -> (s -> b -> t) -> Lens s t a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- > species = lens _.species $ _ {species = _}
            -- > view species {species : "bovine"}
            -- "bovine"

            -- > _2 = lens Tuple.snd $ \(Tuple keep _) new -> Tuple keep new
        ,
            { name = "lens'"
            , def =
                e.fn2
                    (e.br (e.fn2 (e.n "s") (e.class "Tuple" [ e.n "a", e.br (e.fn3 (e.n "s") (e.n "b") (e.n "t")) ])))
                    lstab
                -- (s -> Tuple a (b -> t)) -> Lens s t a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "withLens"
            , def =
                e.fn3
                    alstab
                    (e.br (e.fn3
                        (e.br (e.fn2 (e.n "s") (e.n "a")))
                        (e.br (e.fn3 (e.n "s") (e.n "b") (e.n "t")))
                        (e.n "r")
                    ))
                    (e.n "r")
                -- ALens s t a b -> ((s -> a) -> (s -> b -> t) -> r) -> r
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "cloneLens"
            , def = e.fn2 alstab lstab
                -- ALens s t a b -> Lens s t a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "ilens"
            , def =
                e.fn3
                    (e.br (e.fn2 (e.n "s") (e.class "Tuple" [ e.n "i", e.n "a" ])))
                    (e.br (e.fn3 (e.n "s") (e.n "b") (e.n "t")))
                    ilistab
                -- (s -> Tuple i a) -> (s -> b -> t) -> IndexedLens i s t a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "ilens'"
            , def =
                e.fn2
                    (e.br (e.fn2
                        (e.n "s")
                        (e.class "Tuple"
                            [ e.br (e.class "Tuple" [ e.n "i", e.n "a" ])
                            , e.br (e.fn2 (e.n "b") (e.n "t"))
                            ]
                        )
                    ))
                    ilistab
                -- (s -> Tuple (Tuple i a) (b -> t)) -> IndexedLens i s t a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "withIndexedLens"
            , def =
                e.fn3
                    anilistab
                    (e.br (e.fn3
                        (e.br (e.fn2 (e.n "s") (e.class "Tuple" [ e.n "i", e.n "a" ])))
                        (e.br (e.fn3 (e.n "s") (e.n "b") (e.n "t")))
                        (e.n "r")
                    ))
                    (e.n "r")
                -- (AnIndexedLens i s t a b) -> ((s -> (Tuple i a)) -> (s -> b -> t) -> r) -> r
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "cloneIndexedLens"
            , def = e.fn2 anilistab ilistab
                -- AnIndexedLens i s t a b -> IndexedLens i s t a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "lensStore"
            , def =
                e.fn2
                    alstab
                    (e.class "Tuple" [ e.n "i", e.br (e.fn2 (e.n "b") (e.n "t")) ])
                -- ALens s t a b -> s -> Tuple a (b -> t)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- data LensStoreExample = LensStoreA Int | LensStoreB (Tuple Boolean Int)

            -- lensStoreExampleInt :: Lens' LensStoreExample Int
            -- lensStoreExampleInt = lens' case _ of
            --      LensStoreA i -> map LensStoreA <$> lensStore identity i
            --      LensStoreB i -> map LensStoreB <$> lensStore _2 i
        ]
    } /\ tc.aw /\ tc.noInstances /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in lenspkg