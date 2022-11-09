let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- type NaturalTransformation :: forall k. (k -> Type) -> (k -> Type) -> Type
-- type NaturalTransformation f g = forall a. f a -> g a

let cexpr =
    e.fall1
        (e.av "a")
        (e.fn2
            (e.ap2 (e.f "f") (e.n "a"))
            (e.ap2 (e.f "g") (e.n "a"))
        )
    -- forall a. f a -> g a

let naturalTransformation : tc.TClass =
    { spec = d.t_c (d.id "ntransform") "NaturalTransformation" [ d.v "f", d.v "g" ] cexpr d.kt_kt_t
    , info = "Mapping b/w type constructors with no manipulation on inner value"
    , module = [ "Data" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , members =
        [
            { name = "NaturalTransformation"
            , def = cexpr
            , belongs = tc.Belongs.Yes
            , op = Some "~>"
            , opEmoji = Some "🐛"
            } /\ tc.noLaws /\ tc.noExamples
        ]

    } /\ tc.aw /\ tc.noLaws /\ tc.noInstances /\ tc.noValues /\ tc.noStatements

in naturalTransformation