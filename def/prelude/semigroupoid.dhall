let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let d = ./../../spec.dhall
let e = ./../../build_expr.dhall

-- class Semigroupoid :: forall k. (k -> k -> Type) -> Constraint
-- class Semigroupoid a where

let semigroupoid : tc.TClass =
    { spec =
        d.class_vc
            (d.id "semigroupoid")
            "Semigroupoid"
            [ d.v "a" ]
            d.kktc
    , info = "Category without identity"
    , module = [ "Control" ]
    , package = tc.pk "purescript-prelude" +5 +0 +1
    , members =
        [
            { name = "compose"
            , def =
                e.fn3
                    (e.ap3 (e.n "a") (e.n "c") (e.n "d"))
                    (e.ap3 (e.n "a") (e.n "b") (e.n "c"))
                    (e.ap3 (e.n "a") (e.n "b") (e.n "d"))
                 -- a c d -> a b c -> a b d
            , belongs = tc.Belongs.Yes
            , op = Some "<<<"
            , opEmoji = Some  "🔙"
            , laws =
                [
                    { law = "associativity"
                    , examples =
                        [ tc.lr
                            { left =
                                e.opc2
                                    (e.n "p")
                                    "<<<"
                                    (e.br (e.opc2 (e.n "q") "<<<" (e.n "r")))
                                -- p <<< (q <<< r)
                            , right =
                                e.opc2
                                    (e.br (e.opc2 (e.n "p") "<<<" (e.n "q")))
                                    "<<<"
                                    (e.n "r")
                                -- (p <<< q) <<< r
                            }
                        ]
                    }
                ]
            } /\ tc.noExamples
        ,
            { name = "composeFlipped"
            , def =
                e.req1
                    (e.subj1 "Semigtoupoid" (e.n "a"))
                    (e.fn3
                        (e.ap3 (e.n "a") (e.n "c") (e.n "c"))
                        (e.ap3 (e.n "a") (e.n "c") (e.n "d"))
                        (e.ap3 (e.n "a") (e.n "b") (e.n "d"))
                    )
                -- Semigroupoid a => a b c -> a c d -> a b d
            , belongs = tc.Belongs.No
            , op = Some ">>>"
            , opEmoji = Some "🔜"
            } /\ tc.noLaws /\ tc.noExamples
        ]

    } /\ tc.w 1.3 /\ tc.noLaws /\ tc.noInstances /\ tc.noValues /\ tc.noStatements

in semigroupoid