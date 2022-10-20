let tc = ./../../typeclass.dhall
let i = ./../../instances.dhall
let e = ./../../build_expr.dhall

-- type AffineTraversal s t a b = forall p. Strong p => Choice p => Optic p s t a b

let affinetraversal : tc.TClass =
    { id = "affinetraversal"
    , name = "AffineTraversal"
    , what = tc.What.Type_
    , vars = [ "s", "t", "a", "b" ]
    , info = "An affine traversal (has at most one focus, but is not a prism)."
    , module = [ "Data", "Lens", "AffineTraversal" ]
    , package = tc.pkmj "purescript-profunctor-lenses" +8
    , link = "purescript-profunctor-lenses/8.0.0/docs/Data.Lens.AffineTraversal"
    , members =
        [
            { name = "AffineTraversal"
            , def =
                e.reqseq
                    [ e.class1 "Strong" (e.n "p"), e.class1 "Choice" (e.n "p") ]
                    (e.class "Optic" [ e.n "p", e.n "s", e.n "t", e.n "a", e.n "b" ])
                -- Strong p => Choice p => Optic p s t a b
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ,
            { name = "AffineTraversal'"
            , def =
                e.opc2
                    (e.class "AffineTraversal'" [ e.n "s", e.n "a" ])
                    "="
                    (e.class "AffineTraversal" [ e.n "s", e.n "s", e.n "a", e.n "a" ])
                -- type AffineTraversal' s a = AffineTraversal s s a a
            , belongs = tc.Belongs.Constructor
            } /\ tc.noOps /\ tc.noLaws /\ tc.noExamples
        ]
    } /\ tc.noInstances /\ tc.noParents /\ tc.noLaws /\ tc.noStatements /\ tc.noValues

in affinetraversal