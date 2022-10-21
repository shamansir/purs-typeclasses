let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- type IndexedOptic :: (Type -> Type -> Type) -> Type -> Type -> Type -> Type -> Type -> Type
-- type IndexedOptic p i s t a b = Indexed p i a b -> p s t

-- type IndexedOptic' :: (Type -> Type -> Type) -> Type -> Type -> Type -> Type
-- type IndexedOptic' p i s a = IndexedOptic p i s s a a


let indexedoptic : tc.TClass =
    { id = "indexedoptic"
    , name = "IndexedOptic"
    , what = tc.What.Type_
    , vars = [ "p", "i", "s", "t", "a", "b" ]
    , info = "An indexed optic."
    , module = [ "Data", "Lens", "Types" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Types"
    , members =
        [
            { name = "IndexedOptic"
            , def =
                e.fn2
                    (e.class "Indexed" [ e.t "p", e.n "i", e.n "a", e.n "b" ])
                    (e.ap3 (e.t "p") (e.n "s") (e.n "t"))
                -- Indexed p i a b -> p s t
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "IndexedOptic'"
            , def =
                e.opc2
                    (e.class "IndexedOptic'" [ e.n "p", e.n "i", e.n "s", e.n "a" ])
                    "="
                    (e.class "IndexedOptic" [ e.n "p", e.n "i", e.n "s", e.n "s", e.n "a", e.n "a" ])
                -- type IndexedOptic' p i s a = IndexedOptic p i s s a a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in indexedoptic