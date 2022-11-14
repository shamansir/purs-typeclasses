let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- data Proxy :: forall k. k -> Type
-- data Proxy a // a is phantom

let proxy : tc.TClass =
    { spec = d.data_c (d.id "proxy") "Proxy" [ d.vp "a" ] d.kt
    , info = "Displaying values"
    , module = [ "Type" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , members =
        [
            { name = "Proxy"
            , def = e.fall1 (e.av "k") (e.fn2 (e.n "k") (e.kw "Type")) -- forall k. k -> Type
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples

        ]
    } /\ tc.w 1.05 /\ tc.noLaws /\ tc.noValues /\ tc.noStatements /\ tc.noInstances

in proxy