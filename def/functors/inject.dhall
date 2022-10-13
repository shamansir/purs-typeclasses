let tc = ./../../typeclass.dhall
let e = ./../../build_expr.dhall
let i = ./../../instances.dhall

-- class Inject :: forall k. (k -> Type) -> (k -> Type) -> Constraint
-- class Inject f g where

let inject : tc.TClass =
    { id = "inject"
    , name = "Inject"
    , what = tc.What.Class_
    , vars = [ "f", "g" ]
    , info = ""
    , module = [ "Data", "Functor", "Coproduct" ]
    , package = tc.pk "purescript-functors" +4 +1 +1
    , link = "purescript-functors/4.1.1/docs/Data.Functor.Coproduct.Inject"
    , members =
        [
            { name = "inj"
            , def =
                e.fn2 (e.ap2 (e.f "f") (e.n "a")) (e.ap2 (e.f "g") (e.n "a"))
                -- f a -> g a
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "prj"
            , def =
                e.fn2 (e.ap2 (e.f "g") (e.n "a")) (e.class1 "Maybe" (e.ap2 (e.f "f") (e.n "a")))
                -- g a -> Maybe (f a)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ e.subj "Inject" [ e.f "f", e.f "f" ] -- Inject f f
        , e.subj "Inject" [ e.f "f", e.br (e.class "Coproduct" [ e.n "f", e.n "g" ]) ]  -- Inject f (Coproduct f g)
        , e.req1
            (e.br (e.class "Inject" [ e.f "f", e.f "g" ]))
            (e.subj "Inject" [ e.f "f", e.br (e.class "Coproduct" [ e.n "h", e.n "g" ]) ])
            -- (Inject f g) => Inject f (Coproduct h g)
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in inject