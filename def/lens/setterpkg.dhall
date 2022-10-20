let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e_ = ./../../expr.dhall
let e = ./../../build_expr.dhall


let sstab = e.class "Setter" [ e.n "s", e.n "t", e.n "a", e.n "b" ]   -- Setter s t a b
let sstaa = e.class "Setter" [ e.n "s", e.n "t", e.n "a", e.n "a" ]   -- Setter s t a a
let sssab = e.class "Setter" [ e.n "s", e.n "s", e.n "a", e.n "b" ]   -- Setter s s a b
let sstamb = e.class "Setter" [ e.n "s", e.n "t", e.n "a", e.br (e.class1 "Maybe" (e.n "b")) ]   -- Setter s t a (Maybe b)
let ssa = e.class "Setter'" [ e.n "s", e.n "a" ]   -- Setter' s a
let isistab = e.class "IndexedSetter" [ e.n "i", e.n "s", e.n "t", e.n "a", e.n "b" ]   -- IndexedSetter i s t a b

let setterpkg : tc.TClass =
    { id = "setterpkg"
    , name = "Lens.Setter"
    , what = tc.What.Package_
    , info = "Setters"
    , module = [ "Data", "Lens", "Setter" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Setter"
    , members =
        [
            { name = "over"
            , def = e.fn [ sstab, e.br (e.fn2 (e.n "a") (e.n "b")), e.n "s", e.n "t" ]
                -- Setter s t a b -> (a -> b) -> s -> t
            , belongs = tc.Belongs.No
            , op = Some "%~"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "iover"
            , def = e.fn [ isistab, e.br (e.fn3 (e.n "i") (e.n "a") (e.n "b")), e.n "s", e.n "t" ]
                -- IndexedSetter i s t a b -> (i -> a -> b) -> s -> t
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "set"
            , def = e.fn [ sstab, e.n "b", e.n "s", e.n "t" ]
                -- Setter s t a b -> b -> s -> t
            , belongs = tc.Belongs.No
            , op = Some ".~"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "addOver"
            , def = e.req1 (e.class1 "Semiring" (e.n "a")) (e.fn [ sstaa, e.n "a", e.n "s", e.n "t" ])
                -- Semiring a => Setter s t a a -> a -> s -> t
            , belongs = tc.Belongs.No
            , op = Some "+~"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "subOver"
            , def = e.req1 (e.class1 "Ring" (e.n "a")) (e.fn [ sstaa, e.n "a", e.n "s", e.n "t" ])
                -- Ring a => Setter s t a a -> a -> s -> t
            , belongs = tc.Belongs.No
            , op = Some "-~"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "mulOver"
            , def = e.req1 (e.class1 "Semiring" (e.n "a")) (e.fn [ sstaa, e.n "a", e.n "s", e.n "t" ])
                -- Semiring a => Setter s t a a -> a -> s -> t
            , belongs = tc.Belongs.No
            , op = Some "*~"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "divOver"
            , def = e.req1 (e.class1 "EuclideanRing" (e.n "a")) (e.fn [ sstaa, e.n "a", e.n "s", e.n "t" ])
                -- EuclideanRing a => Setter s t a a -> a -> s -> t
            , belongs = tc.Belongs.No
            , op = Some "//~"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "disjOver"
            , def = e.req1 (e.class1 "HeytingAlgebra" (e.n "a")) (e.fn [ sstaa, e.n "a", e.n "s", e.n "t" ])
                -- HeytingAlgebra a => Setter s t a a -> a -> s -> t
            , belongs = tc.Belongs.No
            , op = Some "||~"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "conjOver"
            , def = e.req1 (e.class1 "HeytingAlgebra" (e.n "a")) (e.fn [ sstaa, e.n "a", e.n "s", e.n "t" ])
                -- HeytingAlgebra a => Setter s t a a -> a -> s -> t
            , belongs = tc.Belongs.No
            , op = Some "&&~"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "appendOver"
            , def = e.req1 (e.class1 "Semigroup" (e.n "a")) (e.fn [ sstaa, e.n "a", e.n "s", e.n "t" ])
                -- Semigroup a => Setter s t a a -> a -> s -> t
            , belongs = tc.Belongs.No
            , op = Some "<>~"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "setJust"
            , def = e.fn [ sstamb, e.n "b", e.n "s", e.n "t" ]
                -- Setter s t a (Maybe b) -> b -> s -> t
            , belongs = tc.Belongs.No
            , op = Some "?~"
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "assign"
            , def = e.req1 (e.class "MonadState" [ e.n "s", e.t "m" ]) (e.fn [ sssab, e.n "b", e.ap2 (e.n "m") (e.classE "Unit") ])
                -- MonadState s m => Setter s s a b -> b -> m Unit
            , belongs = tc.Belongs.No
            , op = Some ".="
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "modifying"
            , def = e.req1 (e.class "MonadState" [ e.n "s", e.t "m" ]) (e.fn [ sssab, e.br (e.fn2 (e.n "a") (e.n "b")), e.ap2 (e.n "m") (e.classE "Unit") ])
                -- MonadState s m => Setter s s a b -> (a -> b) -> m Unit
            , belongs = tc.Belongs.No
            , op = Some "%="
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "addModifying"
            , def =
                e.reqseq
                    [ e.class "MonadState" [ e.n "s", e.t "m" ], e.class1 "Semiring" (e.n "a") ]
                    (e.fn [ ssa, e.n "a", e.ap2 (e.n "m") (e.classE "Unit") ])
                -- MonadState s m => Semiring a => Setter' s a -> a -> m Unit
            , belongs = tc.Belongs.No
            , op = Some "+="
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "mulModifying"
            , def =
                e.reqseq
                    [ e.class "MonadState" [ e.n "s", e.t "m" ], e.class1 "Semiring" (e.n "a") ]
                    (e.fn [ ssa, e.n "a", e.ap2 (e.n "m") (e.classE "Unit") ])
                -- MonadState s m => Semiring a => Setter' s a -> a -> m Unit
            , belongs = tc.Belongs.No
            , op = Some "+="
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "subModifying"
            , def =
                e.reqseq
                    [ e.class "MonadState" [ e.n "s", e.t "m" ], e.class1 "Ring" (e.n "a") ]
                    (e.fn [ ssa, e.n "a", e.ap2 (e.n "m") (e.classE "Unit") ])
                -- MonadState s m => Ring a => Setter' s a -> a -> m Unit
            , belongs = tc.Belongs.No
            , op = Some "-="
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "divModifying"
            , def =
                e.reqseq
                    [ e.class "MonadState" [ e.n "s", e.t "m" ], e.class1 "EuclideanRing" (e.n "a") ]
                    (e.fn [ ssa, e.n "a", e.ap2 (e.n "m") (e.classE "Unit") ])
                -- MonadState s m => EuclideanRing a => Setter' s a -> a -> m Unit
            , belongs = tc.Belongs.No
            , op = Some "//="
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "disjModifying"
            , def =
                e.reqseq
                    [ e.class "MonadState" [ e.n "s", e.t "m" ], e.class1 "HeytingAlgebra" (e.n "a") ]
                    (e.fn [ ssa, e.n "a", e.ap2 (e.n "m") (e.classE "Unit") ])
                -- MonadState s m => HeytingAlgebra a => Setter' s a -> a -> m Unit
            , belongs = tc.Belongs.No
            , op = Some "||="
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "conjModifying"
            , def =
                e.reqseq
                    [ e.class "MonadState" [ e.n "s", e.t "m" ], e.class1 "HeytingAlgebra" (e.n "a") ]
                    (e.fn [ ssa, e.n "a", e.ap2 (e.n "m") (e.classE "Unit") ])
                -- MonadState s m => HeytingAlgebra a => Setter' s a -> a -> m Unit
            , belongs = tc.Belongs.No
            , op = Some "&&="
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "appendModifying"
            , def =
                e.reqseq
                    [ e.class "MonadState" [ e.n "s", e.t "m" ], e.class1 "Semigroup" (e.n "a") ]
                    (e.fn [ ssa, e.n "a", e.ap2 (e.n "m") (e.classE "Unit") ])
                -- MonadState s m => Semigroup a => Setter' s a -> a -> m Unit
            , belongs = tc.Belongs.No
            , op = Some "<>="
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "assignJust"
            , def =
                e.req1
                    (e.class "MonadState" [ e.n "s", e.t "m" ])
                    (e.fn [ sstamb, e.n "b", e.n "s", e.ap2 (e.n "m") (e.classE "Unit") ])
                -- MonadState s m => Setter s s a (Maybe b) -> b -> m Unit
            , belongs = tc.Belongs.No
            , op = Some "?="
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noVars /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in setterpkg