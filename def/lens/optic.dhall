let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- type Optic :: (Type -> Type -> Type) -> Type -> Type -> Type -> Type -> Type
-- type Optic p s t a b = p a b -> p s t


let optic : tc.TClass =
    { id = "optic"
    , name = "Optic"
    , what = tc.What.Type_
    , vars = [ "p", "s", "t", "a", "b" ]
    , info = "A general-purpose Data.Lens."
    , module = [ "Data", "Lens", "Getter" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Getter"
    , members =
        [
            { name = "Optic"
            , def =
                e.fn2
                    (e.ap3 (e.t "p") (e.n "a") (e.n "b"))
                    (e.ap3 (e.t "p") (e.n "s") (e.n "t"))
                -- p a b -> p s t
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in optic