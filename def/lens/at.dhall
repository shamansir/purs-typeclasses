let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class (Index m a b) <= At m a b | m -> a, m -> b where


let at : tc.TClass =
    { spec =
        d.class_vpd
            (d.id "at")
            "At"
            [ d.v "m", d.v "a", d.v "b" ]
            [ d.p (d.id "index") "Index" [ d.v "m", d.v "a", d.v "b" ] ]
            [ d.dep1 (d.v "m") (d.v "a")
            , d.dep1 (d.v "m") (d.v "b")
            ]
    , info = "Type class whose instances let you add new elements or delete old ones from \"container-like\" types"
    , module = [ "Data", "Lens", "At" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , members =
        [
            { name = "at"
            , def =
                e.fn2
                    (e.n "a")
                    (e.class "Lens''" [ e.t "m", e.br (e.class1 "Maybe" (e.n "b")) ])
                -- at :: a -> Lens' m (Maybe b)
            , belongs = tc.Belongs.Yes
                    -- whole = Map.singleton "key" "value"
                    -- optic = at "key"

                    -- view optic whole == Just "value"

                    -- set optic (Just "NEW") whole == Map.singleton "key" "NEW"

                    -- set optic Nothing whole == Map.empty
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "sans"
            , def =
                e.req1
                    (e.subj "At" [ e.t "m", e.n "a", e.n "b" ])
                    (e.fn3 (e.n "a") (e.t "m") (e.t "m"))
                -- At m a b => a -> m -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.aw /\ tc.noInstances /\ tc.noLaws /\ tc.noStatements /\ tc.noValues



in at

-- At (Identity a) Unit a
-- At (Maybe a) Unit a
-- (Ord v) => At (Set v) v Unit
-- (Ord k) => At (Map k v) k v
-- At (Object v) String v