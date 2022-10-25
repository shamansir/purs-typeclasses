let d = ./spec.dhall
let e = ./build_expr.dhall

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


let const =
    d.nt_c
        (d.id "const")
        "Const"
        [ d.v "a", d.v "b" ]
        (d.ccforall [ d.v "k" ] [ d.ctype, d.cv "k", d.ctype ])


let test_const_kind_raw =
    assert
    : d.Spec/renderKindRaw const
    ≡ Some "newtype Const :: forall k. Type -> k -> Type"
let test_const_kind =
    assert
    : d.Spec/renderKind const
    ≡ Some "{{kw:newtype}} {{type(const):Const}} {{op:::}} {{kw:forall}} {{var:k}}. {{kw:Type}} {{op:->}} {{var:k}} {{op:->}} {{kw:Type}}"
let test_const_header_raw =
    assert
    : d.Spec/renderHeaderRaw const
    ≡ "newtype Const a b"
let test_const_header =
    assert
    : d.Spec/renderHeader const
    ≡ "{{kw:newtype}} {{type(const):Const}} {{var:a}} {{var:b}}"


let op = d.nt (d.id "op") "Op" [ d.v "a", d.v "b" ]


let test_op_kind_raw =
    assert
    : d.Spec/renderKindRaw op
    ≡ None Text
let test_op_kind =
    assert
    : d.Spec/renderKind op
    ≡ None Text
let test_op_header_raw =
    assert
    : d.Spec/renderHeaderRaw op
    ≡ "newtype Op a b"
let test_op_header =
    assert
    : d.Spec/renderHeader op
    ≡ "{{kw:newtype}} {{type(op):Op}} {{var:a}} {{var:b}}"


let effect = d.data (d.id "effect") "Effect" [ d.v "t0" ]


let test_effect_kind_raw =
    assert
    : d.Spec/renderKindRaw effect
    ≡ None Text
let test_effect_kind =
    assert
    : d.Spec/renderKind effect
    ≡ None Text
let test_effect_header_raw =
    assert
    : d.Spec/renderHeaderRaw effect
    ≡ "data Effect t0"
let test_effect_header =
    assert
    : d.Spec/renderHeader effect
    ≡ "{{kw:data}} {{type(effect):Effect}} {{var:t0}}"


let exchange = d.data (d.id "exchange") "Exchange" [ d.v "a", d.v "b", d.v "s", d.v "t" ]


let test_exchange_kind_raw =
    assert
    : d.Spec/renderKindRaw exchange
    ≡ None Text
let test_exchange_kind =
    assert
    : d.Spec/renderKind exchange
    ≡ None Text
let test_exchange_header_raw =
    assert
    : d.Spec/renderHeaderRaw exchange
    ≡ "data Exchange a b s t"
let test_exchange_header =
    assert
    : d.Spec/renderHeader exchange
    ≡ "{{kw:data}} {{type(exchange):Exchange}} {{var:a}} {{var:b}} {{var:s}} {{var:t}}"


let foldablewithindex =
    d.class_vpdc
        (d.id "foldablewithindex")
        "FoldableWithIndex"
        [ d.v "i", d.v "f" ]
        [ d.p (d.id "foldable") "Foldable" [ d.v "f" ] ]
        (d.deps1 (d.v "f") (d.v "i"))
        d.tt2c


let test_foldablewithindex_kind_raw =
    assert
    : d.Spec/renderKindRaw foldablewithindex
    ≡ Some "class FoldableWithIndex :: Type -> (Type -> Type) -> Constraint"
let test_foldablewithindex_kind =
    assert
    : d.Spec/renderKind foldablewithindex
    ≡ Some "{{kw:class}} {{class(foldablewithindex):FoldableWithIndex}} {{op:::}} {{kw:Type}} {{op:->}} ({{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Constraint}}"
let test_foldablewithindex_header_raw =
    assert
    : d.Spec/renderHeaderRaw foldablewithindex
    ≡ "class (Foldable f) <= FoldableWithIndex i f | f -> i where"
let test_foldablewithindex_header =
    assert
    : d.Spec/renderHeader foldablewithindex
    ≡ "{{kw:class}} ({{class(foldable):Foldable}} {{var:f}}) {{op:<=}} {{subj(foldablewithindex):FoldableWithIndex}} {{var:i}} {{var:f}} {{op:|}} {{var:f}} {{op:->}} {{var:i}} {{kw:where}}"


let traversablewithindex =
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


let test_traversablewithindex_kind_raw =
    assert
    : d.Spec/renderKindRaw traversablewithindex
    ≡ Some "class TraversableWithIndex :: Type -> (Type -> Type) -> Constraint"
let test_traversablewithindex_kind =
    assert
    : d.Spec/renderKind traversablewithindex
    ≡ Some "{{kw:class}} {{class(traversablewithindex):TraversableWithIndex}} {{op:::}} {{kw:Type}} {{op:->}} ({{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Constraint}}"
let test_traversablewithindex_header_raw =
    assert
    : d.Spec/renderHeaderRaw traversablewithindex
    ≡ "class (FunctorWithIndex i t, FoldableWithIndex i t, Traversable t) <= TraversableWithIndex i t | t -> i where"
let test_traversablewithindex_header =
    assert
    : d.Spec/renderHeader traversablewithindex
    ≡ "{{kw:class}} ({{class(functorwithindex):FunctorWithIndex}} {{var:i}} {{var:t}}{{op:,}} {{class(foldablewithindex):FoldableWithIndex}} {{var:i}} {{var:t}}{{op:,}} {{class(traversable):Traversable}} {{var:t}}) {{op:<=}} {{subj(traversablewithindex):TraversableWithIndex}} {{var:i}} {{var:t}} {{op:|}} {{var:t}} {{op:->}} {{var:i}} {{kw:where}}"


let at =
    d.class_vpd
        (d.id "at")
        "At"
        [ d.v "m", d.v "a", d.v "b" ]
        [ d.p (d.id "index") "Index" [ d.v "m", d.v "a", d.v "b" ] ]
        [ d.dep1 (d.v "m") (d.v "a")
        , d.dep1 (d.v "m") (d.v "b")
        ]


let test_at_kind_raw =
    assert
    : d.Spec/renderKindRaw at
    ≡ None Text
let test_at_kind =
    assert
    : d.Spec/renderKind at
    ≡ None Text
let test_at_header_raw =
    assert
    : d.Spec/renderHeaderRaw at
    ≡ "class (Index m a b) <= At m a b | m -> a, m -> b where"
let test_at_header =
    assert
    : d.Spec/renderHeader at
    ≡ "{{kw:class}} ({{class(index):Index}} {{var:m}} {{var:a}} {{var:b}}) {{op:<=}} {{subj(at):At}} {{var:m}} {{var:a}} {{var:b}} {{op:|}} {{var:m}} {{op:->}} {{var:a}}{{op:,}} {{var:m}} {{op:->}} {{var:b}} {{kw:where}}"


let index =
    d.class_vd
        (d.id "index")
        "Index"
        [ d.v "m", d.v "a", d.v "b" ]
        [ d.dep1 (d.v "m") (d.v "a")
        , d.dep1 (d.v "m") (d.v "b")
        ]


let test_index_kind_raw =
    assert
    : d.Spec/renderKindRaw index
    ≡ None Text
let test_index_kind =
    assert
    : d.Spec/renderKind index
    ≡ None Text
let test_index_header_raw =
    assert
    : d.Spec/renderHeaderRaw index
    ≡ "class Index m a b | m -> a, m -> b where"
let test_index_header =
    assert
    : d.Spec/renderHeader index
    ≡ "{{kw:class}} {{subj(index):Index}} {{var:m}} {{var:a}} {{var:b}} {{op:|}} {{var:m}} {{op:->}} {{var:a}}{{op:,}} {{var:m}} {{op:->}} {{var:b}} {{kw:where}}"


let affinetraversal =
    d.t
        (d.id "affinetraversal")
        "AffineTraversal"
        [ d.v "s", d.v "t", d.v "a", d.v "b" ]
        (e.fall1
            (e.av "p")
            (e.reqseq
                [ e.class1 "Strong" (e.n "p"), e.class1 "Choice" (e.n "p") ]
                (e.class "Optic" [ e.n "p", e.n "s", e.n "t", e.n "a", e.n "b" ])
            )
        )


let test_affinetraversal_kind_raw =
    assert
    : d.Spec/renderKindRaw affinetraversal
    ≡ None Text
let test_affinetraversal_kind =
    assert
    : d.Spec/renderKind affinetraversal
    ≡ None Text
let test_affinetraversal_header_raw =
    assert
    : d.Spec/renderHeaderRaw affinetraversal
    ≡ "type AffineTraversal s t a b = forall p. Strong p => Choice p => Optic p s t a b"
let test_affinetraversal_header =
    assert
    : d.Spec/renderHeader affinetraversal
    ≡ "{{kw:type}} {{type(affinetraversal):AffineTraversal}} {{var:s}} {{var:t}} {{var:a}} {{var:b}} {{op:=}} {{kw:forall}} {{var:p}}. {{class:Strong}} {{var:p}} {{op:=>}} {{class:Choice}} {{var:p}} {{op:=>}} {{class:Optic}} {{var:p}} {{var:s}} {{var:t}} {{var:a}} {{var:b}}"


let indexed = d.nt_c (d.id "indexed") "Indexed" [ d.v "p", d.v "i", d.v "s", d.v "t" ] d.t3t4


let test_indexed_kind_raw =
    assert
    : d.Spec/renderKindRaw indexed
    ≡ Some "newtype Indexed :: (Type -> Type -> Type) -> Type -> Type -> Type -> Type"
let test_indexed_kind =
    assert
    : d.Spec/renderKind indexed
    ≡ Some "{{kw:newtype}} {{type(indexed):Indexed}} {{op:::}} ({{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}}"
let test_indexed_header_raw =
    assert
    : d.Spec/renderHeaderRaw indexed
    ≡ "newtype Indexed p i s t"
let test_indexed_header =
    assert
    : d.Spec/renderHeader indexed
    ≡ "{{kw:newtype}} {{type(indexed):Indexed}} {{var:p}} {{var:i}} {{var:s}} {{var:t}}"


let io_cexpr =
    e.fn2
        (e.class "Indexed" [ e.t "p", e.n "i", e.n "a", e.n "b" ])
        (e.ap3 (e.t "p") (e.n "s") (e.n "t"))
let indexedoptic = d.t_c (d.id "indexedoptic") "IndexedOptic" [ d.v "p", d.v "i", d.v "s", d.v "t", d.v "a", d.v "b" ] io_cexpr d.t3t6


let test_indexedoptic_kind_raw =
    assert
    : d.Spec/renderKindRaw indexedoptic
    ≡ Some "type IndexedOptic :: (Type -> Type -> Type) -> Type -> Type -> Type -> Type -> Type -> Type"
let test_indexedoptic_kind =
    assert
    : d.Spec/renderKind indexedoptic
    ≡ Some "{{kw:type}} {{type(indexedoptic):IndexedOptic}} {{op:::}} ({{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}}"
let test_indexedoptic_header_raw =
    assert
    : d.Spec/renderHeaderRaw indexedoptic
    ≡ "type IndexedOptic p i s t a b = Indexed p i a b -> p s t"
let test_indexedoptic_header =
    assert
    : d.Spec/renderHeader indexedoptic
    ≡ "{{kw:type}} {{type(indexedoptic):IndexedOptic}} {{var:p}} {{var:i}} {{var:s}} {{var:t}} {{var:a}} {{var:b}} {{op:=}} {{class:Indexed}} {{typevar:p}} {{var:i}} {{var:a}} {{var:b}} {{op:->}} {{typevar:p}} {{var:s}} {{var:t}}"


let re = d.nt_c (d.id "re") "Re" [ d.v "p", d.v "s", d.v "t", d.v "a", d.v "b" ] d.t3t5


let test_re_kind_raw =
    assert
    : d.Spec/renderKindRaw re
    ≡ Some "newtype Re :: (Type -> Type -> Type) -> Type -> Type -> Type -> Type -> Type"
let test_re_kind =
    assert
    : d.Spec/renderKind re
    ≡ Some "{{kw:newtype}} {{type(re):Re}} {{op:::}} ({{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}}"
let test_re_header_raw =
    assert
    : d.Spec/renderHeaderRaw re
    ≡ "newtype Re p s t a b"
let test_re_header =
    assert
    : d.Spec/renderHeader re
    ≡ "{{kw:newtype}} {{type(re):Re}} {{var:p}} {{var:s}} {{var:t}} {{var:a}} {{var:b}}"


let parseerror = d.data_e (d.id "parseerror") "ParseError"


let test_parseerror_kind_raw =
    assert
    : d.Spec/renderKindRaw parseerror
    ≡ None Text
let test_parseerror_kind =
    assert
    : d.Spec/renderKind parseerror
    ≡ None Text
let test_parseerror_header_raw =
    assert
    : d.Spec/renderHeaderRaw parseerror
    ≡ "data ParseError " -- FIXME: remove last space
let test_parseerror_header =
    assert
    : d.Spec/renderHeader parseerror
    ≡ "{{kw:data}} {{type(parseerror):ParseError}} " -- FIXME: remove last space


let position = d.nt_e (d.id "position") "Position"


let test_position_kind_raw =
    assert
    : d.Spec/renderKindRaw position
    ≡ None Text
let test_position_kind =
    assert
    : d.Spec/renderKind position
    ≡ None Text
let test_position_header_raw =
    assert
    : d.Spec/renderHeaderRaw position
    ≡ "newtype Position " -- FIXME: remove last space
let test_position_header =
    assert
    : d.Spec/renderHeader position
    ≡ "{{kw:newtype}} {{type(position):Position}} " -- FIXME: remove last space


let endo = d.nt_c (d.id "endo") "Endo" [ d.v "c", d.vn "a" ] d.kkt_kt


let test_endo_kind_raw =
    assert
    : d.Spec/renderKindRaw endo
    ≡ Some "newtype Endo :: forall k. (k -> k -> Type) -> k -> Type"
let test_endo_kind =
    assert
    : d.Spec/renderKind endo
    ≡ Some "{{kw:newtype}} {{type(endo):Endo}} {{op:::}} {{kw:forall}} {{var:k}}. ({{var:k}} {{op:->}} {{var:k}} {{op:->}} {{kw:Type}}) {{op:->}} {{var:k}} {{op:->}} {{kw:Type}}"
let test_endo_header_raw =
    assert
    : d.Spec/renderHeaderRaw endo
    -- ≡ "newtype Endo c {a}"
    ≡ "newtype Endo c a"
let test_endo_header =
    assert
    : d.Spec/renderHeader endo
    ≡ "{{kw:newtype}} {{type(endo):Endo}} {{var:c}} {{nominal:a}}"


let proxy = d.data_c (d.id "proxy") "Proxy" [ d.vp "a" ] d.kt


let test_proxy_kind_raw =
    assert
    : d.Spec/renderKindRaw proxy
    ≡ Some "data Proxy :: forall k. k -> Type"
let test_proxy_kind =
    assert
    : d.Spec/renderKind proxy
    ≡ Some "{{kw:data}} {{type(proxy):Proxy}} {{op:::}} {{kw:forall}} {{var:k}}. {{var:k}} {{op:->}} {{kw:Type}}"
let test_proxy_header_raw =
    assert
    : d.Spec/renderHeaderRaw proxy
    -- ≡ "data Proxy /a/"
    ≡ "data Proxy a"
let test_proxy_header =
    assert
    : d.Spec/renderHeader proxy
    ≡ "{{kw:data}} {{type(proxy):Proxy}} {{phantom:a}}"


in "passed"