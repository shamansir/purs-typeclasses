let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- data Proxy :: forall k. k -> Type
-- data Proxy a // a is phantom

let proxy : tc.TClass =
    { id = "proxy"
    , name ="Proxy"
    , what = tc.What.Data_
    , vars = [ "a" ]
    , info = "Displaying values"
    , module = [ "Type" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , link = "purescript-prelude/5.0.1/docs/Type.Proxy"
    , spec = d.data_c (d.id "proxy") "Proxy" [ d.vp "a" ] d.kt
    , members =
        [
            { name = "Proxy"
            , def = e.fall1 (e.av "k") (e.fn2 (e.n "k") (e.kw "Type")) -- forall k. k -> Type
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples

        ]
    } /\ tc.aw /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements /\ tc.noInstances

in proxy