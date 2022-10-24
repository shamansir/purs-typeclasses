let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../typedef.dhall
let e = ./../../build_expr.dhall

-- class Index m a b | m -> a, m -> b where


let index : tc.TClass =
    { id = "index"
    , name = "Index"
    , what = tc.What.Class_
    , vars = [ "m", "a", "b" ]
    , info = "Index is a type class whose instances are optics used when there might be no focus or you cannot add/delete elements"
    , module = [ "Data", "Lens", "Index" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Index"
    , def =
        d.class_vd
            (d.id "index")
            "Index"
            [ d.v "m", d.v "a", d.v "b" ]
            [ d.dep1 (d.v "m") (d.v "a")
            , d.dep1 (d.v "m") (d.v "b")
            ]
    , members =
        [
            { name = "ix"
            , def =
                e.fn2
                    (e.n "a")
                    (e.class "AffineTraversal'" [ e.t "m", e.n "b" ])
                -- ix :: a -> AffineTraversal' m b
            , belongs = tc.Belongs.Yes
                    -- preview (ix 1) [0, 1, 2] == Just 1
                    -- set (ix 1) 8888 [0, 1, 2] == [0,8888,2]
                    -- (set (ix "k") "new" $ Map.singleton "k" "old") == Map.singleton "k" "new"
                    -- (set (ix "k") "new" $ Map.empty) == Map.empty
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues



in index

-- (Eq i) => Index (i -> a) i a
-- Index (Maybe a) Unit a
-- Index (Identity a) Unit a
-- Index (Array a) Int a
-- Index (NonEmptyArray a) Int a
-- Index (List a) Int a
-- (Ord a) => Index (Set a) a Unit
-- (Ord k) => Index (Map k v) k v
-- Index (Object v) String v