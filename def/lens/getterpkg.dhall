let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e_ = ./../../expr.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall


let gstab = e.class "Getter" [ e.n "s", e.n "t", e.n "a", e.n "b" ]   -- Getter s t a b
let agstab = e.class "AGetter" [ e.n "s", e.n "t", e.n "a", e.n "b" ] -- AGetter s t a b
let agstcd = e.class "AGetter" [ e.n "s", e.n "t", e.n "c", e.n "d" ] -- AGetter s t c d
let ifistab_br = \(first : e_.Expr) -> e.class "IndexedFold" [ e.br first, e.n "i", e.n "s", e.n "t", e.n "a", e.n "b" ] -- IndexedFold (<first>) i s t a b

let getterpkg : tc.TClass =
    { id = "getterpkg"
    , name = "Lens.Getter"
    , what = tc.What.Package_
    , info = "Getters"
    , module = [ "Data", "Lens", "Getter" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.Getter"
    , spec = d.pkg (d.id "getterpkg") "Lens.Getter"
    , members =
        [
            { name = "viewOn"
            , def = e.fn3 (e.n "s") agstab (e.n "a")
                -- s -> AGetter s t a b -> a
            , belongs = tc.Belongs.No
            , op = Some "^."
            , opEmoji = tc.noOp
            } /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "view"
            , def = e.fn3 agstab (e.n "s") (e.n "a")
                -- AGetter s t a b -> s -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "to"
            , def = e.fn2 (e.br (e.fn2 (e.n "s") (e.n "a"))) gstab
                -- (s -> a) -> Getter s t a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "takeBoth"
            , def =
                e.fn
                    [ agstab
                    , agstcd
                    , e.class "Getter"
                        [ e.n "s"
                        , e.n "t"
                        , e.br (e.class "Tuple" [ e.n "a", e.n "c" ])
                        , e.br (e.class "Tuple" [ e.n "b", e.n "d" ])
                        ]
                    ]
                -- AGetter s t a b -> AGetter s t c d -> Getter s t (Tuple a c) (Tuple b d)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "use"
            , def =
                e.req1
                    (e.class "MonadState" [ e.n "s", e.t "m" ])
                    (e.fn2 gstab (e.ap2 (e.t "m") (e.n "a")) )
                -- MonadState s m => Getter s t a b -> m a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "iview"
            , def =
                e.fn3
                    (ifistab_br (e.class "Tuple" [ e.n "i", e.n "a" ]))
                    (e.n "s")
                    (e.class "Tuple" [ e.n "i", e.n "a" ])
                -- IndexedFold (Tuple i a) i s t a b -> s -> Tuple i a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "iuse"
            , def =
                e.req1
                    (ifistab_br (e.class "Tuple" [ e.n "i", e.n "a" ]))
                    (e.ap2 (e.t "m") (e.br (e.class "Tuple" [ e.n "i", e.n "a" ])))
                -- MonadState s m => IndexedFold (Tuple i a) i s t a b -> m (Tuple i a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "cloneGetter"
            , def = e.fn2 agstab gstab
                -- AGetter s t a b -> Getter s t a b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.aw /\ tc.noInstances /\ tc.noVars /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in getterpkg