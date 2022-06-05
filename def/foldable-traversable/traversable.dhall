let tc = ./../../typeclass.dhall

let i = ./../../instances.dhall

let traversable : tc.TClass =
    { id = "traversable"
    , name = "Traversable"
    , what = tc.What.Class_
    , vars = [ "t" ]
    , parents = [ "functor", "foldable" ]
    , info = "Data structures which can be traversed, accumulate in Applicative Functor"
    , module = [ "Data" ]
    , package = "purescript-foldable-traversable"
    , link = "purescript-foldable-traversable/5.0.1/docs/Data.Traversable"
    , statements =
        [
            { left = "{{method:traverse}} {{fvar:f}} {{var:xs}}" -- traverse f xs
            , right = "{{method:sequence}} ({{fvar:f}} {{op:<$>}} {{var:xs}})" -- sequence (f <$> xs)
            }
        ,
            { left = "{{method:sequence}}" -- sequence
            , right = "{{method:traverse}} {{method:identity}}" -- traverse identity
            }
        ,
            { left = "{{method:foldMap}} {{fvar:f}}" -- foldMap f
            , right = "{{method:runConst}} {{op:<<<}} {{method:traverse}} ({{class:Const}} {{op:<<<}} {{fvar:f}})" -- runConst <<< traverse (Const <<< f)
            }
        ]
    , members =
        [
            { name = "traverse"
            , def = "{{class:Applicative}} {{typevar:m}} {{op:=>}} ({{var:a}} {{op:->}} {{typevar:m}} {{var:b}}) {{op:->}} {{fvar:t}} {{var:a}} {{op:->}} {{typevar:m}} ({{fvar:t}} {{var:b}})" -- Applicative m => (a -> m b) -> t a -> m (t b)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "sequence"
            , def = "{{class:Applicative}} {{typevar:m}} {{op:=>}} {{fvar:t}} ({{typevar:m}} {{var:a}}) {{op:->}} {{typevar:m}} ({{fvar:t}} {{var:a}})" -- Applicative m => t (m a) -> m (t a)
            , belongs = tc.Belongs.Yes
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "traverseDefault"
            , def = "{{subj:Traversable}} {{fvar:t}} {{op:=>}} {{class:Applicative}} {{typevar:m}} {{op:=>}} ({{var:a}} {{op:->}} {{typevar:m}} {{var:b}}) {{op:->}} {{fvar:t}} {{var:a}} {{op:->}} {{typevar:m}} ({{fvar:t}} {{var:b}})" -- Traversable t => Applicative m => (a -> m b) -> t a -> m (t b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "sequenceDefault"
            , def = "{{subj:Traversable}} {{fvar:t}} {{op:=>}} {{class:Applicative}} {{typevar:m}} {{op:=>}} {{fvar:t}} ({{typevar:m}} {{var:a}}) {{op:->}} {{typevar:m}} ({{fvar:t}} {{var:a}})" -- Traversable t => Applicative m => t (m a) -> m (t a)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "for"
            , def = "{{class:Applicative}} {{typevar:m}} {{op:=>}} {{subj:Traversable}} {{fvar:t}} {{op:=>}} {{fvar:t}} {{var:a}} {{op:->}} ({{var:a}} {{op:->}} {{typevar:m}} {{var:b}}) {{op:->}} {{typevar:m}} ({{fvar:t}} {{var:b}})" -- Applicative m => Traversable t => t a -> (a -> m b) -> m (t b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "scanl"
            , def = "{{subj:Traversable}} {{fvar:f}} {{op:=>}} ({{var:b}} {{op:->}} {{var:a}} {{op:->}} {{var:b}}) {{op:->}} {{var:b}} {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{fvar:f}} {{var:b}}" -- Traversable f => (b -> a -> b) -> b -> f a -> f b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "scanr"
            , def = "{{subj:Traversable}} {{fvar:f}} {{op:=>}} ({{var:a}} {{op:->}} {{var:b}} {{op:->}} {{var:b}}) {{op:->}} {{var:b}} {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{fvar:f}} {{var:b}}" -- Traversable f => (a -> b -> b) -> b -> f a -> f b
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "mapAccumL"
            , def = "{{subj:Traversable}} {{fvar:f}} {{op:=>}} ({{var:s}} {{op:->}} {{var:a}} {{op:->}} {{class:Accum}} {{var:s}} {{var:b}}) {{op:->}} {{var:s}} {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{class:Accum}} {{var:s}} ({{fvar:f}} {{var:b}})" -- Traversable f => (s -> a -> Accum s b) -> s -> f a -> Accum s (f b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ,
            { name = "mapAccumR"
            , def = "{{subj:Traversable}} {{fvar:f}} {{op:=>}} ({{var:s}} {{op:->}} {{var:a}} {{op:->}} {{class:Accum}} {{var:s}} {{var:b}}) {{op:->}} {{var:s}} {{op:->}} {{fvar:f}} {{var:a}} {{op:->}} {{class:Accum}} {{var:s}} ({{fvar:f}} {{var:b}})" -- Traversable f => (s -> a -> Accum s b) -> s -> f a -> Accum s (f b)
            , belongs = tc.Belongs.No
            } /\ tc.noOps /\ tc.noLaws
        ]
    , instances =
        [ i.instanceSubj "Array" "Traversable"
        , i.instanceSubj "Maybe" "Traversable"
        , i.instanceSubj "First" "Traversable"
        , i.instanceSubj "Last" "Traversable"
        , i.instanceSubj "Additive" "Traversable"
        , i.instanceSubj "Dual" "Traversable"
        , i.instanceSubj "Disj" "Traversable"
        , i.instanceSubj "Conj" "Traversable"
        , i.instanceSubj "Multiplicative" "Traversable"
        , i.instanceSubjA "Either" "Traversable"
        , i.instanceSubjA "Tuple" "Traversable"
        , i.instanceSubj "Identity" "Traversable"
        , i.instanceSubjA "Const" "Traversable"
        , i.instanceReqFG "Product" "Traversable"
        , i.instanceReqFG "Coproduct" "Traversable"
        , i.instanceReqFG "Compose" "Traversable"
        , i.instanceReqASubj "App" "Traversable"
        ]

    } /\ tc.noValues /\ tc.noLaws

in traversable