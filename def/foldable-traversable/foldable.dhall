let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let foldable : tc.TClass =
    { id = "foldable"
    , name = "Foldable"
    , what = tc.What.Class_
    , vars = [ "f" ]
    , info = "Represents data structures which can be folded."
    , module = [ "Data" ]
    , package = "purescript-foldable-traversable"
    , link = "purescript-foldable-traversable/5.0.1/docs/Data.Foldable"
    , members =
        [
            { name = "foldr"
            , def = "({{var:a}} {{op:->}} {{var:b}} {{op:->}} {{var:b}}) {{op:->}} {{var:b}} {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{var:b}}" -- (a -> b -> b) -> b -> f a -> b
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "foldl"
            , def = "({{var:b}} {{op:->}} {{var:a}} {{op:->}} {{var:b}}) {{op:->}} {{var:b}} {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{var:b}}" -- (b -> a -> b) -> b -> f a -> b
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "foldMap"
            , def = "{{class:Monoid}} {{typevar:m}} {{op:=>}} ({{var:a}} {{op:->}} {{typevar:m}}) {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{typevar:m}}" -- Monoid m => (a -> m) -> f a -> m
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "foldrDefault"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} ({{var:a}} {{op:->}} {{var:b}} {{op:->}} {{var:b}}) {{op:->}} {{var:b}} {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{var:b}}" -- Foldable f => (a -> b -> b) -> b -> f a -> b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "foldlDefault"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} ({{var:b}} {{op:->}} {{var:a}} {{op:->}} {{var:b}}) {{op:->}} {{var:b}} {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{var:b}}" -- Foldable f => (b -> a -> b) -> b -> f a -> b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "foldMapDefaultL"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{class:Monoid}} {{typevar:m}} {{op:=>}} ({{var:a}} {{op:->}} {{typevar:m}}) {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{typevar:m}}" --  Foldable f => Monoid m => (a -> m) -> f a -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "foldMapDefaultR"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{class:Monoid}} {{typevar:m}} {{op:=>}} ({{var:a}} {{op:->}} {{typevar:m}}) {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{typevar:m}}" --  Foldable f => Monoid m => (a -> m) -> f a -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "fold"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{class:Monoid}} {{typevar:m}} {{op:=>}} {{fvar:f}} {{typevar:m}} {{op:->}} {{typevar:m}}" --  Foldable f => Monoid m => f m -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "foldM"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{class:Monoid}} {{typevar:m}} {{op:=>}} ({{var:b}} {{op:->}} {{var:a}} {{op:->}} {{typevar:m}} {{var:b}})" -- Foldable f => Monoid m => (b -> a -> m b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "traverse_"
            , def = "{{class:Applicative}} {{typevar:m}} {{op:=>}} {{subj:Foldable}} {{fvar:f}} {{op:=>}} ({{var:a}} {{op:->}} {{typevar:m}} {{var:b}}) {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{typevar:m}} {{class:Unit}}" -- Applicative m => Foldable f => (a -> m b) -> f a -> m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "for_"
            , def = "{{class:Applicative}} {{typevar:m}} {{op:=>}} {{subj:Foldable}} {{fvar:f}} {{op:=>}} {{fvar:f}} {{var:a}} {{op:->}} ({{var:a}} {{op:->}} {{typevar:m}} {{var:b}}) {{op:->}} {{typevar:m}} {{class:Unit}}" -- Applicative m => Foldable f => f a -> (a -> m b) -> m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "sequence_"
            , def = "{{class:Applicative}} {{typevar:m}} {{op:=>}} {{subj:Foldable}} {{fvar:f}} {{op:=>}} {fvar:f}} ({{typevar:m}} {{var:a}} {{op:->}} {{typevar:m}} {{class:Unit}}" -- Applicative m => Foldable f => f (m a) -> m Unit
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "oneOf"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{class:Plus}} {{fvar::g}} {{op:=>}} {{fvar:f}} ({{fvar:g}} {{var:a}}) {{op:->}} {{fvar:g}} {{var:a}}" -- Foldable f => Plus g => f (g a) -> g a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "oneOfMap"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{class:Plus}} {{fvar::g}} {{op:=>}} ({{var:a}} {{op:->}} {{fvar:g}} {{var:b}}) {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{fvar:g}} {{var:b}}" -- Foldable f => Plus g => (a -> g b) -> f a -> g b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "intercalate"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{class:Monoid}} {{typevar:m}} {{op:=>}} {{typevar:m}} {{op:->}} {{fvar:f}} {{typevar:m}} {{op:->}} {{typevar:m}}" -- Foldable f => Monoid m => m -> f m -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "surroundMap"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{class:Semigroup}} {{typevar:m}} {{op:=>}} {{typevar:m}} {{op:->}} ({{var:a}} {{op:->}} {{typevar:m}}) {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{typevar:m}}" -- Foldable f => Semigroup m => m -> (a -> m) -> f a -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "surround"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{class:Semigroup}} {{typevar:m}} {{op:=>}} {{typevar:m}}  {{op:->}} {{fvar:f}} {{typevar:m}} {{op:->}} {{typevar:m}}" -- Foldable f => Semigroup m => m -> f m -> m
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "and"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{class:HeytingAlgebra}} {{var:a}} {{op:=>}} {{fvar:f}} {{var:a}} {{op:->}} {{var:a}}" -- Foldable f => HeytingAlgebra a => f a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "or"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{class:HeytingAlgebra}} {{var:a}} {{op:=>}} {{fvar:f}} {{var:a}} {{op:->}} {{var:a}}" -- Foldable f => HeytingAlgebra a => f a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "all"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{class:HeytingAlgebra}} {{var:b}} {{op:=>}} ({{var:a}} {{op:->}} {{var:b}}) {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{var:b}}" -- Foldable f => HeytingAlgebra b => (a -> b) -> f a -> b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "any"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{class:HeytingAlgebra}} {{var:b}} {{op:=>}} ({{var:a}} {{op:->}} {{var:b}}) {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{var:b}}" -- Foldable f => HeytingAlgebra b => (a -> b) -> f a -> b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "sum"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{class:Semiring}} {{var:a}} {{op:=>}} {{fvar:f}} {{var:a}} {{op:->}} {{var:a}}" -- Foldable f => Semiring a => f a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "product"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{class:Semiring}} {{var:a}} {{op:=>}} {{fvar:f}} {{var:a}} {{op:->}} {{var:a}}" -- Foldable f => Semiring a => f a -> a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "elem"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{class:Eq}} {{var:a}} {{op:=>}} {{var:a}} {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{class:Boolean}}" -- Foldable f => Eq a => a -> f a -> Boolean
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "notElem"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{class:Eq}} {{var:a}} {{op:=>}} {{var:a}} {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{class:Boolean}}" -- Foldable f => Eq a => a -> f a -> Boolean
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "indexl"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{class:Int}} {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{class:Maybe}} {{var:a}}" -- Foldable f => Int -> f a -> Maybe a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "indexr"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{class:Int}} {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{class:Maybe}} {{var:a}}" -- Foldable f => Int -> f a -> Maybe a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "find"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} ({{var:a}} {{op:->}} {{class:Boolean}}) {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{class:Maybe}} {{var:a}}" -- Foldable f => (a -> Boolean) -> f a -> Maybe a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "findMap"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} ({{var:a}} {{op:->}} {{class:Maybe}} {{var:b}}) {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{class:Maybe}} {{var:b}}" -- Foldable f => (a -> Maybe b) -> f a -> Maybe b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "maximum"
            , def = "{{class:Ord}} {{var:a}} {{op:=>}} {{subj:Foldable}} {{fvar:f}} {{op:=>}} {{fvar:f}} {{var:a}} {{op:->}} {{class:Maybe}} {{var:a}}" -- Ord a => Foldable f => f a -> Maybe a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "maximumBy"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} ({{var:a}} {{op:->}} {{var:a}} {{op:->}} {{class:Ordering}}) {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{class:Maybe}} {{var:a}}" -- Foldable f => (a -> a -> Ordering) -> f a -> Maybe a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "minimum"
            , def = "{{class:Ord}} {{var:a}} {{op:=>}} {{subj:Foldable}} {{fvar:f}} {{op:=>}} {{fvar:f}} {{var:a}} {{op:->}} {{class:Maybe}} {{var:a}}" -- Ord a => Foldable f => f a -> Maybe a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "minimumBy"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} ({{var:a}} {{op:->}} {{var:a}} {{op:->}} {{class:Ordering}}) {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{class:Maybe}} {{var:a}}" -- Foldable f => (a -> a -> Ordering) -> f a -> Maybe a
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "null"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{fvar:f}} {{var:a}} {{op:->}} {{class:Boolean}}" -- Foldable f => f a -> Boolean
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "length"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{class:Semiring}} {{var:b}} {{op:=>}} {{fvar:f}} {{var:a}} {{op:->}} {{var:b}}" -- Foldable f => Semiring b => f a -> b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "lookup"
            , def = "{{subj:Foldable}} {{fvar:f}} {{op:=>}} {{class:Eq}} {{var:a}} {{op:=>}} {{var:a}} {{op:->}} {{fvar:f}} ({{class:Tuple}} {{var:a}} {{var:b}}) {{op:->}} {{class:Maybe}} {{var:b}}" -- Foldable f => Eq a => a -> f (Tuple a b) -> Maybe b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceSubj "Array" "Foldable"
        , i.instanceSubj "Maybe" "Foldable"
        , i.instanceSubj "First" "Foldable"
        , i.instanceSubj "Last" "Foldable"
        , i.instanceSubj "Additive" "Foldable"
        , i.instanceSubj "Dual" "Foldable"
        , i.instanceSubj "Disj" "Foldable"
        , i.instanceSubj "Conj" "Foldable"
        , i.instanceSubj "Multiplicative" "Foldable"
        , i.instanceSubjA "Either" "Foldable"
        , i.instanceSubjA "Tuple" "Foldable"
        , i.instanceSubj "Identity" "Foldable"
        , i.instanceSubjA "Const" "Foldable"
        , i.instanceReqFG "Product" "Foldable"
        , i.instanceReqFG "Coproduct" "Foldable"
        , i.instanceReqFG "Compose" "Foldable"
        , i.instanceReqASubj "App" "Foldable"
        ]

    } /\ tc.noParents /\ tc.noLaws /\ tc.noValues /\ tc.noStatements

in foldable