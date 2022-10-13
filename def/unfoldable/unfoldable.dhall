-- class Unfoldable :: (Type -> Type) -> Constraint
-- class (Unfoldable1 t) <= Unfoldable t where

let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

let unfoldable : tc.TClass =
    { id = "unfoldable"
    , name = "Unfoldable"
    , what = tc.What.Class_
    , vars = [ "t" ]
    , parents = [ "unfoldable1" ]
    , info = "This class identifies (possibly empty) data structures which can be unfolded"
    , module = [ "Data" ]
    , package = tc.pkmj "purescript-unfoldable" +6
    , link = "purescript-unfoldable/6.0.0/docs/Data.Unfoldable"
    , members =
        [
            { name = "unfoldr"
            , def =
                e.fn3
                    (e.br
                        (e.fn2
                            (e.n "b")
                            (e.class1 "Maybe" (e.br (e.class "Tuple" [ e.n "a", e.n "b" ])))
                        ))
                    (e.n "b")
                    (e.ap2 (e.t "t") (e.n "a"))
                -- (b -> Maybe (Tuple a b)) -> b -> t a
            , belongs = tc.Belongs.Yes
            , laws =
                [
                    { law = "function"
                    -- If f b is Nothing, then unfoldr f b should be empty
                    -- If f b is Just (Tuple a b1), then unfoldr f b should consist of a appended to the result of unfoldr f b1.
                    , examples =
                        [ tc.lrc
                            { left = e.call "unfoldr" [ e.f "f", e.n "b" ] -- unfoldr f b
                            , right = e.callE "none" -- none
                            , conditions = [ e.opc2 (e.ap2 (e.f "f") (e.n "b")) "==" (e.classE "Nothing") ] -- f b == Nothing
                            }
                        , tc.lrc
                            { left = e.call "unfoldr" [ e.f "f", e.n "b" ] -- unfoldr f b
                            , right = e.opc2 (e.n "a") "::" (e.call "unfoldr" [ e.f "f", e.n "b1" ]) -- a :: unfoldr f b1
                            , conditions = [ e.opc2 (e.ap2 (e.f "f") (e.n "b")) "==" (e.class1 "Just" (e.br (e.class "Tuple" [ e.n "a", e.n "b1" ]))) ] -- f b == Just (Tuple a b1)
                            }
                        ]
                    }
                ]
            } /\ tc.noOps
        ,
            { name = "replicate"
            , def =
                e.req1
                    (e.subj1 "Unfoldable" (e.t "f"))
                    (e.fn3
                        (e.classE "Int")
                        (e.n "a")
                        (e.ap2 (e.t "f") (e.n "a"))
                    )
                -- Unfoldable f => Int -> a -> f a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "replicateA"
            , def =
                e.reqseq
                    [ e.class1 "Applicative" (e.t "m"), e.subj1 "Unfoldable" (e.t "f") ]
                    (e.fn3
                        (e.classE "Int")
                        (e.ap2 (e.t "m") (e.n "a"))
                        (e.ap2 (e.t "m") (e.br (e.ap2 (e.t "f") (e.n "a"))))
                    )
                -- Applicative m => Unfoldable f => Traversable f => Int -> m a -> m (f a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "none"
            , def =
                e.req1
                    (e.subj1 "Unfoldable" (e.t "f"))
                    (e.ap2 (e.t "f") (e.n "a"))
                -- Unfoldable f => f a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "fromMaybe"
            , def =
                e.req1
                    (e.subj1 "Unfoldable" (e.t "f"))
                    (e.fn2
                        (e.class1 "Maybe" (e.n "a"))
                        (e.ap2 (e.t "f") (e.n "a"))
                    )
                -- Unfoldable f => Maybe a -> f a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceSubj "Array" "Unfoldable"
        , i.instanceSubj "Maybe" "Unfoldable"
        ]

    } /\ tc.noStatements /\ tc.noValues /\ tc.noLaws

in unfoldable