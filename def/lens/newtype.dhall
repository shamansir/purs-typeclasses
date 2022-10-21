let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- _Newtype :: forall t a s b. Newtype t a => Newtype s b => Iso t s a b

let _newtype : tc.TClass =
    { id = "_newtype"
    , name = "_Newtype"
    , what = tc.What.Package_
    , info = "An Iso between a newtype and its inner type."
    , module = [ "Data", "Lens", "Iso", "Newtype"]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Iso.Newtype"
    , members =
        [
            { name = "_Newtype"
            , def =
                e.fall
                    [ e.av "t", e.av "a", e.av "s", e.av "b" ]
                    (e.reqseq
                        [ e.class "Newtype" [ e.n "t", e.n "a" ],  e.class "Newtype" [ e.n "s", e.n "b" ] ]
                        (e.class "Iso" [ e.n "t", e.n "s", e.n "a", e.n "b" ])
                    )
                -- forall t a s b. Newtype t a => Newtype s b => Iso t s a b
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "unto"
            , def =
                e.fall
                    [ e.av "n", e.av "o" ]
                    (e.req1
                        (e.class "Newtype" [ e.n "n", e.n "o" ])
                        (e.fn2
                            (e.br (e.fn2 (e.n "o") (e.n "n")))
                            (e.class "Iso'" [ e.n "n", e.n "o" ])
                        )
                    )
                -- forall n o. Newtype n o => (o -> n) -> Iso' n o
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noVars /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in _newtype