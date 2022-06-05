let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let invariant : tc.TClass =
    { id = "invariant"
    , name = "Invariant"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , info = ""
    , module = [ "Data", "Functor" ]
    , package = "purescript-invariant"
    , link = "purescript-invariant/5.0.0/docs/Data.Functor.Invariant#t:Invariant"
    , members =
        [
            { name = "imap"
            , def = "({{var:a}} {{op:->}} {{var:b}}) {{op:->}} ({{var:b}} {{op:->}} {{var:a}}) {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{fvar:f}} {{var:b}}" -- (a -> b) -> (b -> a) -> f a -> f b
            , belongs = tc.Belongs.Yes
            } /\ tc.noLaws /\ tc.noOps
        ,
            { name = "imapF"
            , def = " {{class:Functor}} {{fvar:f}} {{op:=>}} ({{var:a}} {{op:->}} {{var:b}}) {{op:->}} ({{var:b}} {{op:->}} {{var:a}}) {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{fvar:f}} {{var:b}}" --  Functor f => (a -> b) -> (b -> a) -> f a -> f b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceSubjA "Function" "Invariant"
        , i.instanceSubj "Array" "Invariant"
        , i.instanceSubj "Additive" "Invariant"
        , i.instanceSubj "Conj" "Invariant"
        , i.instanceSubj "Disj" "Invariant"
        , i.instanceSubj "Dual" "Invariant"
        , i.instanceSubjA2 "Endo" "Function" "Invariant"
        , i.instanceSubj "Multiplicative" "Invariant"
        , i.instanceReqASubj "Alternate" "Invariant"
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in invariant