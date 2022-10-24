
let e = ./expr.dhall

let List/map =
    https://prelude.dhall-lang.org/List/map


let Id =
    < Id : Text
    >


let Parent = { id : Id, name : Text, vars : List e.Arg }


let Dependency = { from : List e.Arg, to : List e.Arg }


let Dependencies = List Dependency


let DataDef =
    { name : Text
    , id : Id
    , vars : List e.Arg
    , constraint : Optional e.Constraint
    }


let NewtypeDef =
    { name : Text
    , id : Id
    , vars : List e.Arg
    , constraint : Optional e.Constraint
    }


let ClassDef =
    { name : Text
    , id : Id
    , vars : List e.Arg
    , parents : List Parent
    , dependencies : Optional Dependencies
    , constraint : Optional e.Constraint
    }


let TypeDef =
    { name : Text
    , id : Id
    , vars : List e.Arg
    , expr : e.Expr
    , constraint : Optional e.Constraint
    }


let PackageDef =
    { name : Text
    , id : Id
    }


let InternalDef =
    { name : Text
    , id : Id
    }


-- id and name could be shared
-- add module, info, package
let Def = -- TODO: rename to `Spec`, we have `Def` in `typeclass.dhall`
    < Data_ : DataDef
    | Type_ : TypeDef
    | Newtype_ : NewtypeDef
    | Class_ : ClassDef
    | Package_ : PackageDef
    | Internal_ : InternalDef
    >


let ctype : e.CItem = e.CItem.CType


let cfn
    : List e.CItem -> e.CItem
    = \(items : List e.CItem) ->
    e.CItem.CFn (e.Expr/sealAll (List/map e.CItem e.Expr e.CItem/toExpr items))


let cfn_br
    : List e.CItem -> e.CItem
    = \(items : List e.CItem) ->
    e.CItem.CBr
        (e.Expr/seal
            (e.CItem/toExpr (cfn items) )
        )


let cctype : e.Constraint = [ ctype ]
let cctype2 : e.Constraint = [ ctype, ctype ]
let cctype3 : e.Constraint = [ ctype, ctype, ctype ]


let ccforall
    : List e.Arg -> e.Constraint -> e.Constraint
    = \(args : List e.Arg) -> \(body : e.Constraint) -> [ e.CItem.CForall { args, body = e.Expr/seal (e.Constraint/toExpr body) } ]


let id = Id.Id


let data
    : Id -> Text -> List e.Arg -> Def
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) ->
    Def.Data_ { id, name, vars, constraint = None e.Constraint }


let data_c
    : Id -> Text -> List e.Arg -> e.Constraint -> Def
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(constraint : e.Constraint) ->
    Def.Data_ { id, name, vars, constraint = Some constraint }


let data_e
    : Id -> Text -> Def
    = \(id : Id) -> \(name : Text) ->
    data id name ([] : List e.Arg)


let nt
    : Id -> Text -> List e.Arg -> Def
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) ->
    Def.Newtype_ { id, name, vars, constraint = None e.Constraint }


let nt_c
    : Id -> Text -> List e.Arg -> e.Constraint -> Def
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(constraint : e.Constraint) ->
    Def.Newtype_ { id, name, vars, constraint = Some constraint }


let nt_e
    : Id -> Text ->  Def
    = \(id : Id) -> \(name : Text) ->
    nt id name ([] : List e.Arg)


let t
    : Id -> Text -> List e.Arg -> e.Expr -> Def
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(expr : e.Expr) ->
    Def.Type_ { id, name, vars, expr, constraint = None e.Constraint }


let t_c
    : Id -> Text -> List e.Arg -> e.Expr -> e.Constraint -> Def
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(expr : e.Expr) -> \(constraint : e.Constraint) ->
    Def.Type_ { id, name, vars, expr, constraint = Some constraint }


let pkg
    : Id -> Text -> Def
    = \(id : Id) -> \(name : Text) ->
    Def.Package_ { id, name }


let int
    : Id -> Text -> Def
    = \(id : Id) -> \(name : Text) ->
    Def.Internal_ { id, name }


let p
    : Id -> Text -> List e.Arg -> Parent
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) ->
    { id, name, vars }


let pe
    : Id -> Text -> Parent
    = \(id : Id) -> \(name : Text) ->
    p id name ([] : List e.Arg)


let v
    : Text -> e.Arg
    = e.Arg.VarArg


let vn
    : Text -> e.Arg
    = e.Arg.VarNominal


let vp
    : Text -> e.Arg
    = e.Arg.VarPhantom


let cv
    : Text -> e.CItem
    = \(v_ : Text) -> e.CItem.CVar (v v_)


let ccon
    : e.CItem
    = e.CItem.CConstraint


let class
   : Id -> Text -> Def
    = \(id : Id) -> \(name : Text) ->
    Def.Class_
        { id, name
        , vars = [] : List e.Arg
        , parents = [] : List Parent
        , dependencies = None Dependencies
        , constraint = None e.Constraint
        }


let class_v
   : Id -> Text -> List e.Arg -> Def
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) ->
   Def.Class_
        { id, name, vars
        , parents = [] : List Parent
        , dependencies = None Dependencies
        , constraint = None e.Constraint
        }


let class_c
   : Id -> Text -> e.Constraint -> Def
   = \(id : Id) -> \(name : Text) -> \(cnst : e.Constraint) ->
   Def.Class_
        { id, name, vars = [] : List e.Arg
        , parents = [] : List Parent
        , dependencies = None Dependencies
        , constraint = Some cnst
        }


let class_vp
   : Id -> Text -> List e.Arg -> List Parent -> Def
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(parents : List Parent) ->
   Def.Class_
        { id, name, vars, parents
        , dependencies = None Dependencies
        , constraint = None e.Constraint
        }


let class_vc
   : Id -> Text -> List e.Arg -> e.Constraint -> Def
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(cnst : e.Constraint) ->
   Def.Class_
        { id, name, vars
        , parents = [] : List Parent
        , dependencies = None Dependencies
        , constraint = Some cnst
        }

let class_vd
   : Id -> Text -> List e.Arg -> Dependencies -> Def
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(deps : Dependencies) ->
   Def.Class_
        { id, name, vars
        , parents = [] : List Parent
        , dependencies = Some deps
        , constraint = None e.Constraint
        }


let class_vpd
   : Id -> Text -> List e.Arg -> List Parent -> Dependencies -> Def
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(parents : List Parent) -> \(deps : Dependencies) ->
   Def.Class_
        { id, name, vars, parents
        , dependencies = Some deps
        , constraint = None e.Constraint
        }


let class_vpc
   : Id -> Text -> List e.Arg -> List Parent -> e.Constraint -> Def
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(parents : List Parent) ->  \(cnst : e.Constraint) ->
   Def.Class_
        { id, name, vars, parents
        , dependencies = None Dependencies
        , constraint = Some cnst
        }


let class_vpdc
   : Id -> Text -> List e.Arg -> List Parent -> Dependencies -> e.Constraint -> Def
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(parents : List Parent) -> \(deps : Dependencies) -> \(cnst : e.Constraint) ->
   Def.Class_
        { id, name, vars, parents
        , dependencies = Some deps
        , constraint = Some cnst
        }


let dep
    : List e.Arg -> List e.Arg -> Dependency
    = \(from : List e.Arg) -> \(to : List e.Arg) -> { from, to }


let dep1
    : e.Arg -> e.Arg -> Dependency
    = \(from : e.Arg) -> \(to : e.Arg) -> dep [ from ] [ to ]


let deps1
    : e.Arg -> e.Arg -> Dependencies
    = \(from : e.Arg) -> \(to : e.Arg) -> [ dep1 from to ]


let test_c01 = assert : e.Constraint/render cctype ≡ "{{kw:Type}}"
let test_c02 = assert : e.Constraint/render cctype2 ≡ "{{kw:Type}} {{op:->}} {{kw:Type}}"
let test_c03 = assert : e.Constraint/render cctype3 ≡ "{{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}}"
let test_c04 = assert : e.Constraint/render [ ctype, cfn_br [ ctype, ctype ], ctype ] ≡ "{{kw:Type}} {{op:->}} ({{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Type}}"
let test_c05 = assert : e.Constraint/render [ ctype, cfn_br cctype2, ctype ] ≡ "{{kw:Type}} {{op:->}} ({{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Type}}"
let test_c06 = assert : e.Constraint/render (ccforall [ v "k" ] [ ctype, cfn_br cctype2, cv "k" ]) ≡ "{{kw:forall}} {{var:k}}. {{kw:Type}} {{op:->}} ({{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{var:k}}"
let test_c07 = assert : e.Constraint/render [ ctype, ctype, ccon ] ≡ "{{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Constraint}}"
let test_c08 = assert : e.Constraint/render [ cfn_br cctype3, ccon ] ≡ "({{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Constraint}}"


let Def/renderConstraint
    : Def -> Optional Text
    = \(def : Def) ->
    merge
                        -- TODO: render vars
        { Data_ = \(dd : DataDef) ->
            merge
                { Some = \(ct : e.Constraint) -> Some "{{kw:data}} {{class:${dd.name}}} {{op::}} ${e.Constraint/render ct}"
                , None = None Text
                }
                dd.constraint
        , Type_ = \(td : TypeDef) ->
            merge
                { Some = \(ct : e.Constraint) -> Some "{{kw:type}} {{type:${td.name}}} {{op::}} ${e.Constraint/render ct}"
                , None = None Text
                }
                td.constraint
        , Newtype_ = \(ntd : NewtypeDef) ->
            merge
                { Some = \(ct : e.Constraint) -> Some "{{kw:newtype}} {{type:${ntd.name}}} {{op::}} ${e.Constraint/render ct}"
                , None = None Text
                }
                ntd.constraint
        , Class_ = \(cd : ClassDef) ->
            merge
                { Some = \(ct : e.Constraint) -> Some "{{kw:class}} {{class:${cd.name}}} {{op::}} ${e.Constraint/render ct}"
                , None = None Text
                }
                cd.constraint
        , Package_ = \(pd : PackageDef) -> None Text
        , Internal_ = \(id : InternalDef) -> None Text
        }
        def


let Def/renderConstraintRaw
    : Def -> Optional Text
    = \(def : Def) -> None Text


let Def/renderSpec
    : Def -> Text
    = \(def : Def) -> ""


let Def/renderSpecRaw
    : Def -> Text
    = \(def : Def) -> ""


let DefText =
    { constraint : Optional Text
    , spec : Text
    }


let Def/render
    : Def -> DefText
    = \(td : Def) ->
    { constraint = Def/renderConstraint td
    , spec = Def/renderSpec td
    }


let Def/renderRaw
    : Def -> DefText
    = \(td : Def) ->
    { constraint = Def/renderConstraintRaw td
    , spec = Def/renderSpecRaw td
    }


{-
d.class_vpc
    (d.id "biapplicative")
    "Biapplicative"
    [ d.v "w" ]
    [ d.p (d.id "biapply") "Biapply" [ d.v "w" ] ]
    [ d.cfn_br d.cctype3, d.ccon ]

class Biapplicative :: (Type -> Type -> Type) -> Constraint
class (Biapply w) <= Biapplicative w where
-}

{-
d.class_vpc
    (d.id "decidable")
    "Decidable"
    [ d.v "f" ]
    [ d.p (d.id "decide") "Decide" [ d.v "f" ]
    , d.p (d.id "divisible") "Divisible" [ d.v "f" ]
    ]
    [ d.cfn_br d.cctype2, d.ccon ]

class Decidable :: (Type -> Type) -> Constraint
class (Decide f, Divisible f) <= Decidable f where
-}

{-
d.class_vc
    (d.id "bifunctor")
    "Bifunctor"
    [ d.v "w" ]
    [ d.cfn_br d.cctype3, d.ccon ]

class Bifunctor :: (Type -> Type -> Type) -> Constraint
class Bifunctor f where
-}

{-
d.class_v (d.id "lazy") "Lazy" [ d.v "l" ]

class Lazy l where
-}

{-
d.nt_c
    (d.id "alternate")
    "Alternate"
    [ d.v "f", d.v "a" ]
    (d.ccforall [ d.v "k" ] [ d.cfn_br [ d.cv "k", d.ctype ], d.cv "k", d.ctype ])

newtype Alternate :: forall k. (k -> Type) -> k -> Type
newtype Alternate f a
-}

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

-- (Type -> Type) -> Type -> Type -> Type
let t2t3 : e.Constraint = [ cfn_br cctype2, ctype, ctype, ctype ]

-- (Type -> Type -> Type) -> (Type -> Type -> Type) -> Type -> Type -> Type
let t3t3t3 : e.Constraint = [ cfn_br cctype3, cfn_br cctype3, ctype, ctype, ctype ]

-- (Type -> Type -> Type) -> Type -> Type -> Type -> Type
let t3t4 : e.Constraint = [ cfn_br cctype3, ctype, ctype, ctype, ctype ]

-- (Type -> Type -> Type) -> Type -> Type -> Type -> Type -> Type
let t3t5 : e.Constraint = [ cfn_br cctype3, ctype, ctype, ctype, ctype, ctype ]

-- (Type -> Type -> Type) -> Type -> Type -> Type -> Type -> Type -> Type
let t3t6 : e.Constraint = [ cfn_br cctype3, ctype, ctype, ctype, ctype, ctype, ctype ]

-- Type -> (Type -> Type) -> Type -> Type
let t_t2_t2 : e.Constraint = [ ctype, cfn_br cctype2, ctype, ctype ]

-- (Type -> Type) -> Constraint
let t2c : e.Constraint = [ cfn_br cctype2, ccon ]

-- (Type -> Type -> Type) -> Constraint
let t3c : e.Constraint = [ cfn_br cctype3, ccon ]

-- Type -> (Type -> Type) -> Constraint
let tt2c : e.Constraint = [ ctype, cfn_br cctype2, ccon ]

-- forall k. k -> Type
let kt : e.Constraint = ccforall [ v "k" ] [ cv "k", ctype ]

-- forall k. Type -> k -> Type
let tkt : e.Constraint = ccforall [ v "k" ] [ ctype, cv "k", ctype ]

-- forall k. (k -> Type) -> k -> Type
let kt_kt : e.Constraint = ccforall [ v "k" ] [ cfn_br [ cv "k", ctype ], cv "k", ctype ]

-- forall k. (k -> Type) -> Type -> k -> Type
let kt_tkt : e.Constraint = ccforall [ v "k" ] [ cfn_br [ cv "k", ctype ], cv "k", ctype ]

-- forall k. (k -> Type) -> (k -> Type) -> Type
let kt_kt_t : e.Constraint = ccforall [ v "k" ] [ cfn_br [ cv "k", ctype ], cfn_br [ cv "k", ctype ], ctype ]

-- forall k. (k -> Type) -> (k -> Type) -> k -> Type
let kt_kt_kt : e.Constraint = ccforall [ v "k" ] [ cfn_br [ cv "k", ctype ], cfn_br [ cv "k", ctype ], cv "k", ctype ]

-- forall k. (k -> k -> Type) -> k -> Type
let kkt_kt : e.Constraint = ccforall [ v "k" ] [ cfn_br [ cv "k", cv "k", ctype ], cv "k", ctype ]

-- forall k1 k2. (k2 -> Type) -> (k1 -> k2) -> k1 -> Type
let k12kt : e.Constraint = ccforall [ v "k1", v "k2" ] [ cfn_br [ cv "k2", ctype ], cfn_br [ cv "k1", cv "k2" ], cv "k1", ctype ]

-- forall k1 k2. (k1 -> k2 -> Type) -> k2 -> k1 -> Type
let kkt_kkt : e.Constraint = ccforall [ v "k1", v "k2" ] [ cfn_br [ cv "k1", cv "k2", ctype ], cv "k2", cv "k1", ctype ]

-- forall k. (k -> Type) -> (k -> Type) -> Constraint
let kt_kt_c : e.Constraint = ccforall [ v "k" ] [ cfn_br [ cv "k", ctype ], cfn_br [ cv "k", ctype ], ccon ]

-- forall k. (k -> k -> Type) -> Constraint
let kktc : e.Constraint = ccforall [ v "k" ] [ cfn_br [ cv "k", cv "k", ctype ], ccon ]

in
    { id
    , Def, DefText, Def/render, Def/renderRaw
    , ctype, cfn_br
    , cctype, cctype2, cctype3, ccon, ccforall
    , p, pe, v, vn, vp, cv
    , dep, dep1, deps1
    , data, data_c, data_e, t, t_c, nt, nt_c, nt_e, pkg, int, class, class_v, class_c, class_vp, class_vc, class_vd, class_vpd, class_vpc, class_vpdc
    , t2c, t3c, t3t3t3, t3t4, t3t5, t3t6, kt, tkt, t_t2_t2, kt_kt, kt_tkt, kt_kt_t, kt_kt_kt, tt2c, t2t3, k12kt, kkt_kkt, kt_kt_c, kktc, kkt_kt
    }