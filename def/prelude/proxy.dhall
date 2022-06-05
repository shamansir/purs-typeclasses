let tc = ./../../typeclass.dhall

let proxy : tc.TClass =
    { id = "proxy"
    , name ="Proxy"
    , what = tc.What.Data_
    , vars = [ "a" ]
    , info = "Displaying values"
    , module = [ "Type" ]
    , package = "purescript-prelude"
    , link = "purescript-prelude/5.0.1/docs/Type.Proxy"
    , members =
        [
            { name = "Proxy"
            , def = "{{kw:forall}} {{var:k}}. {{var:k}} {{op:->}} {{class:Type}}" -- forall k. k -> Type
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws

        ]
    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements /\ tc.noInstances

in proxy