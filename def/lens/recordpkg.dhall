let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e_ = ./../../expr.dhall
let e = ./../../build_expr.dhall


let recordpkg : tc.TClass =
    { id = "recordpkg"
    , name = "Lens.Record"
    , what = tc.What.Package_
    , info = "Lens for a record property, by providing a proxy for the Symbol which corresponds to the property label"
    , module = [ "Data", "Lens", "Record" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Record"
    , spec = d.pkg (d.id "recordpkg") "Lens.Record"
    , members =
        [
            { name = "prop"
            , def =
                e.reqseq
                    [ e.class1 "IsSymbol" (e.n "l")
                    , e.class "Cons" [ e.n "l", e.n "a", e.n "r", e.n "r1" ]
                    , e.class "Cons" [ e.n "l", e.n "b", e.n "r", e.n "r2" ]
                    ]
                    (e.fn2
                        (e.class1 "Proxy" (e.n "l"))
                        (e.class "Lens'" [ e.br (e.class1 "Record" (e.n "r1")), e.br (e.class1 "Record" (e.n "r2")), e.n "a", e.n "b" ])
                    )
                -- IsSymbol l => Cons l a r r1 => Cons l b r r2 => Proxy l -> Lens (Record r1) (Record r2) a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
            -- prop (Proxy :: Proxy "foo")
            --      :: forall a b r. Lens { foo :: a | r } { foo :: b | r } a b
        ]
    } /\ tc.noInstances /\ tc.noVars /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in recordpkg