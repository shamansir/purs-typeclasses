let d = ./spec.dhall

let biapplicative =
    d.class_vpc
        (d.id "biapplicative")
        "Biapplicative"
        [ d.v "w" ]
        [ d.p (d.id "biapply") "Biapply" [ d.v "w" ] ]
        [ d.cfn_br d.cctype3, d.ccon ]


let test_biapplicative_kind_raw =
    assert
    : d.Spec/renderKindRaw biapplicative
    ≡ Some "class Biapplicative :: (Type -> Type -> Type) -> Constraint"
let test_biapplicative_kind =
    assert
    : d.Spec/renderKind biapplicative
    ≡ Some "{{kw:class}} {{class(biapplicative):Biapplicative}} {{op:::}} ({{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Constraint}}"
let test_biapplicative_header_raw =
    assert
    : d.Spec/renderHeaderRaw biapplicative
    ≡ "class (Biapply w) <= Biapplicative w where"
let test_biapplicative_header =
    assert
    : d.Spec/renderHeader biapplicative
    ≡ "{{kw:class}} ({{class(biapply):Biapply}} {{var:w}}) {{op:<=}} {{subj(biapplicative):Biapplicative}} {{var:w}} {{kw:where}}"


let decidable =
    d.class_vpc
        (d.id "decidable")
        "Decidable"
        [ d.v "f" ]
        [ d.p (d.id "decide") "Decide" [ d.v "f" ]
        , d.p (d.id "divisible") "Divisible" [ d.v "f" ]
        ]
        [ d.cfn_br d.cctype2, d.ccon ]


let test_decidable_kind_raw =
    assert
    : d.Spec/renderKindRaw decidable
    ≡ Some "class Decidable :: (Type -> Type) -> Constraint"
let test_decidable_kind =
    assert
    : d.Spec/renderKind decidable
    ≡ Some "{{kw:class}} {{class(decidable):Decidable}} {{op:::}} ({{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Constraint}}"
let test_decidable_header_raw =
    assert
    : d.Spec/renderHeaderRaw decidable
    ≡ "class (Decide f, Divisible f) <= Decidable f where"
let test_decidable_header =
    assert
    : d.Spec/renderHeader decidable
    ≡ "{{kw:class}} ({{class(decide):Decide}} {{var:f}}{{op:,}} {{class(divisible):Divisible}} {{var:f}}) {{op:<=}} {{subj(decidable):Decidable}} {{var:f}} {{kw:where}}"


let bifunctor =
    d.class_vc
        (d.id "bifunctor")
        "Bifunctor"
        [ d.v "f" ]
        [ d.cfn_br d.cctype3, d.ccon ]


let test_bifunctor_kind_raw =
    assert
    : d.Spec/renderKindRaw bifunctor
    ≡ Some "class Bifunctor :: (Type -> Type -> Type) -> Constraint"
let test_bifunctor_kind =
    assert
    : d.Spec/renderKind bifunctor
    ≡ Some "{{kw:class}} {{class(bifunctor):Bifunctor}} {{op:::}} ({{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Constraint}}"
let test_bifunctor_header_raw =
    assert
    : d.Spec/renderHeaderRaw bifunctor
    ≡ "class Bifunctor f where"
let test_bifunctor_header =
    assert
    : d.Spec/renderHeader bifunctor
    ≡ "{{kw:class}} {{subj(bifunctor):Bifunctor}} {{var:f}} {{kw:where}}"


let lazy = d.class_v (d.id "lazy") "Lazy" [ d.v "l" ]


let test_lazy_kind_raw =
    assert
    : d.Spec/renderKindRaw lazy
    ≡ None Text
let test_lazy_kind =
    assert
    : d.Spec/renderKind lazy
    ≡ None Text
let test_lazy_header_raw =
    assert
    : d.Spec/renderHeaderRaw lazy
    ≡ "class Lazy l where"
let test_lazy_header =
    assert
    : d.Spec/renderHeader lazy
    ≡ "{{kw:class}} {{subj(lazy):Lazy}} {{var:l}} {{kw:where}}"


let alternate =
    d.nt_c
        (d.id "alternate")
        "Alternate"
        [ d.v "f", d.v "a" ]
        (d.ccforall [ d.v "k" ] [ d.cfn_br [ d.cv "k", d.ctype ], d.cv "k", d.ctype ])


let test_alternate_kind_raw =
    assert
    : d.Spec/renderKindRaw alternate
    ≡ Some "newtype Alternate :: forall k. (k -> Type) -> k -> Type"
let test_alternate_kind =
    assert
    : d.Spec/renderKind alternate
    ≡ Some "{{kw:newtype}} {{type(alternate):Alternate}} {{op:::}} {{kw:forall}} {{var:k}}. ({{var:k}} {{op:->}} {{kw:Type}}) {{op:->}} {{var:k}} {{op:->}} {{kw:Type}}"
let test_alternate_header_raw =
    assert
    : d.Spec/renderHeaderRaw alternate
    ≡ "newtype Alternate f a"
let test_alternate_header =
    assert
    : d.Spec/renderHeader alternate
    ≡ "{{kw:newtype}} {{type(alternate):Alternate}} {{var:f}} {{var:a}}"

{-
d.nt_c
    (d.id "const")
    "Const"
    [ d.v "a", d.v "b" ]
    (d.ccforall [ d.v "k" ] [ d.ctype, d.cv "k", d.ctype ])

newtype Const :: forall k. Type -> k -> Type
newtype Const a b
-}

{-
d.nt (d.id "op") "Op" [ d.v "a", d.v "b" ]

newtype Op a b
-}

{-
d.data (d.id "effect") "Effect" [ d.v "t0" ]

data Effect t0
-}

{-
d.data (d.id "exchange") "Exchange" [ d.v "a", d.v "b", d.v "s", d.v "t" ]

data Exchange a b s t
-}

{-
d.class_vpdc
    (d.id "foldablewithindex")
    "FoldableWithIndex"
    [ d.v "i", d.v "f" ]
    [ d.p (d.id "foldable") "Foldable" [ d.v "f" ] ]
    (d.deps1 (d.v "f") (d.v "i"))
    d.tt2c

class FoldableWithIndex :: Type -> (Type -> Type) -> Constraint
class (Foldable f) <= FoldableWithIndex i f | f -> i where
-}

{-
d.class_vpdc
    (d.id "traversablewithindex")
    "TraversableWithIndex"
    [ d.v "i", d.v "t" ]
    [ d.p (d.id "functorwithindex") "FunctorWithIndex" [ d.v "i", d.v "t" ]
    , d.p (d.id "foldablewithindex") "FoldableWithIndex" [ d.v "i", d.v "t" ]
    , d.p (d.id "traversable") "Traversable" [ d.v "t" ]
    ]
    (d.deps1 (d.v "t") (d.v "i"))
    d.tt2c

class TraversableWithIndex :: Type -> (Type -> Type) -> Constraint
class (FunctorWithIndex i t, FoldableWithIndex i t, Traversable t) <= TraversableWithIndex i t | t -> i where
-}

{-
d.class_vpd
    (d.id "at")
    "At"
    [ d.v "m", d.v "a", d.v "b" ]
    [ d.p (d.id "index") "Index" [ d.v "m", d.v "a", d.v "b" ] ]
    [ d.dep1 (d.v "m") (d.v "a")
    , d.dep1 (d.v "m") (d.v "b")
    ]

class (Index m a b) <= At m a b | m -> a, m -> b where
-}

{-
d.class_vd
    (d.id "index")
    "Index"
    [ d.v "m", d.v "a", d.v "b" ]
    [ d.dep1 (d.v "m") (d.v "a")
    , d.dep1 (d.v "m") (d.v "b")
    ]

class Index m a b | m -> a, m -> b where
-}

{-
d.t (d.id "affinetraversal") "AffineTraversal" [ d.v "s", d.v "t", d.v "a", d.v "b" ]
    (e.reqseq
        [ e.class1 "Strong" (e.n "p"), e.class1 "Choice" (e.n "p") ]
        (e.class "Optic" [ e.n "p", e.n "s", e.n "t", e.n "a", e.n "b" ])
    )

type AffineTraversal s t a b = forall p. Strong p => Choice p => Optic p s t a b
-}

{-
d.class_vpd
    (d.id "at")
    "At"
    [ d.v "m", d.v "a", d.v "b" ]
    [ d.p (d.id "index") "Index" [ d.v "m", d.v "a", d.v "b" ] ]
    [ d.dep1 (d.v "m") (d.v "a")
    , d.dep1 (d.v "m") (d.v "b")
    ]

class (Index m a b) <= At m a b | m -> a, m -> b where
-}

{-
d.class_vd
    (d.id "index")
    "Index"
    [ d.v "m", d.v "a", d.v "b" ]
    [ d.dep1 (d.v "m") (d.v "a")
    , d.dep1 (d.v "m") (d.v "b")
    ]

class Index m a b | m -> a, m -> b where
-}

{-
d.nt_c (d.id "indexed") "Indexed" [ d.v "p", d.v "i", d.v "s", d.v "t" ] d.t3t4

newtype Indexed :: (Type -> Type -> Type) -> Type -> Type -> Type -> Type
newtype Indexed p i s t
-}

{-
let cexpr =
    e.fn2
        (e.class "Indexed" [ e.t "p", e.n "i", e.n "a", e.n "b" ])
        (e.ap3 (e.t "p") (e.n "s") (e.n "t"))
d.t_c (d.id "indexedoptic") "IndexedOptic" [ d.v "p", d.v "i", d.v "s", d.v "t", d.v "a", d.v "b" ] cexpr d.t3t6

type IndexedOptic :: (Type -> Type -> Type) -> Type -> Type -> Type -> Type -> Type -> Type
type IndexedOptic p i s t a b = Indexed p i a b -> p s t
-}

{-
d.nt_c (d.id "re") "Re" [ d.v "p", d.v "s", d.v "t", d.v "a", d.v "b" ] d.t3t5

newtype Re :: (Type -> Type -> Type) -> Type -> Type -> Type -> Type -> Type
newtype Re p s t a b
-}

{-
d.data_e (d.id "parseerror") "ParseError"

data ParseError
-}

{-
d.nt_e (d.id "position") "Position"

newtype Position
-}

{-
d.nt_c (d.id "endo") "Endo" [ d.v "c", d.vn "a" ] d.kkt_kt

newtype Endo :: forall k. (k -> k -> Type) -> k -> Type
newtype Endo c a // a is nominal
-}

{-
d.data_c (d.id "proxy") "Proxy" [ d.vp "a" ] d.kt

data Proxy :: forall k. k -> Type
data Proxy a // a is phantom
-}


in "passed"