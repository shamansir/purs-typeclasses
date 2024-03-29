
let e = ./expr.dhall

let Text/concatSep =
    https://prelude.dhall-lang.org/Text/concatSep

let List/map =
    https://prelude.dhall-lang.org/List/map

let List/null =
    https://prelude.dhall-lang.org/List/null

let tt = \(text : Text) -> Text/replace "  " " " text


let Id =
    < Id : Text
    >


let Id/render
    : Id -> Text
    = \(id : Id) ->
    merge
        { Id = \(txt : Text) -> txt }
        id


let Parent = { id : Id, name : Text, vars : List e.Arg }


let Dependency = { from : List e.Arg, to : List e.Arg }


let Dependencies = List Dependency


let DataSpec =
    { name : Text
    , id : Id
    , vars : List e.Arg
    , kindSeq : Optional e.KindSeq
    }


let NewtypeSpec =
    { name : Text
    , id : Id
    , vars : List e.Arg
    , kindSeq : Optional e.KindSeq
    }


let ClassSpec =
    { name : Text
    , id : Id
    , vars : List e.Arg
    , parents : List Parent
    , dependencies : Optional Dependencies
    , kindSeq : Optional e.KindSeq
    }


let TypeSpec =
    { name : Text
    , id : Id
    , vars : List e.Arg
    , expr : e.Expr
    , kindSeq : Optional e.KindSeq
    }


let PackageSpec =
    { name : Text
    , id : Id
    }


let InternalSpec =
    { name : Text
    , id : Id
    }


-- id and name could be shared
-- add module, info, package
let Spec =
    < Data_ : DataSpec
    | Type_ : TypeSpec
    | Newtype_ : NewtypeSpec
    | Class_ : ClassSpec
    | Package_ : PackageSpec
    | Internal_ : InternalSpec
    >


let ctype : e.KindItem = e.KindItem.CType


let cfn
    : List e.KindItem -> e.KindItem
    = \(items : List e.KindItem) ->
    e.KindItem.CFn (e.Expr/sealAll (List/map e.KindItem e.Expr e.KindItem/toExpr items))


let cfn_br
    : List e.KindItem -> e.KindItem
    = \(items : List e.KindItem) ->
    e.KindItem.CBr
        (e.Expr/seal
            (e.KindItem/toExpr (cfn items) )
        )


let cctype : e.KindSeq = [ ctype ]
let cctype2 : e.KindSeq = [ ctype, ctype ]
let cctype3 : e.KindSeq = [ ctype, ctype, ctype ]


let ccforall
    : List e.Arg -> e.KindSeq -> e.KindSeq
    = \(args : List e.Arg) -> \(body : e.KindSeq) -> [ e.KindItem.CForall { args, body = e.Expr/seal (e.KindSeq/toExpr body) } ]


let id = Id.Id


let data
    : Id -> Text -> List e.Arg -> Spec
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) ->
    Spec.Data_ { id, name, vars, kindSeq = None e.KindSeq }


let data_c
    : Id -> Text -> List e.Arg -> e.KindSeq -> Spec
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(kindSeq : e.KindSeq) ->
    Spec.Data_ { id, name, vars, kindSeq = Some kindSeq }


let data_e
    : Id -> Text -> Spec
    = \(id : Id) -> \(name : Text) ->
    data id name ([] : List e.Arg)


let data_ce
    : Id -> Text -> e.KindSeq ->Spec
    = \(id : Id) -> \(name : Text) -> \(kindSeq : e.KindSeq) ->
    data_c id name ([] : List e.Arg) kindSeq


let nt
    : Id -> Text -> List e.Arg -> Spec
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) ->
    Spec.Newtype_ { id, name, vars, kindSeq = None e.KindSeq }


let nt_c
    : Id -> Text -> List e.Arg -> e.KindSeq -> Spec
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(kindSeq : e.KindSeq) ->
    Spec.Newtype_ { id, name, vars, kindSeq = Some kindSeq }


let nt_e
    : Id -> Text ->  Spec
    = \(id : Id) -> \(name : Text) ->
    nt id name ([] : List e.Arg)


let t
    : Id -> Text -> List e.Arg -> e.Expr -> Spec
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(expr : e.Expr) ->
    Spec.Type_ { id, name, vars, expr, kindSeq = None e.KindSeq }


let t_c
    : Id -> Text -> List e.Arg -> e.Expr -> e.KindSeq -> Spec
    = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(expr : e.Expr) -> \(kindSeq : e.KindSeq) ->
    Spec.Type_ { id, name, vars, expr, kindSeq = Some kindSeq }


let pkg
    : Id -> Text -> Spec
    = \(id : Id) -> \(name : Text) ->
    Spec.Package_ { id, name }


let int
    : Id -> Text -> Spec
    = \(id : Id) -> \(name : Text) ->
    Spec.Internal_ { id, name }


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
    : Text -> e.KindItem
    = \(v_ : Text) -> e.KindItem.CVar (v v_)


let ccon
    : e.KindItem
    = e.KindItem.CConstraint


let class
   : Id -> Text -> Spec
    = \(id : Id) -> \(name : Text) ->
    Spec.Class_
        { id, name
        , vars = [] : List e.Arg
        , parents = [] : List Parent
        , dependencies = None Dependencies
        , kindSeq = None e.KindSeq
        }


let class_v
   : Id -> Text -> List e.Arg -> Spec
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) ->
   Spec.Class_
        { id, name, vars
        , parents = [] : List Parent
        , dependencies = None Dependencies
        , kindSeq = None e.KindSeq
        }


let class_c
   : Id -> Text -> e.KindSeq -> Spec
   = \(id : Id) -> \(name : Text) -> \(cnst : e.KindSeq) ->
   Spec.Class_
        { id, name, vars = [] : List e.Arg
        , parents = [] : List Parent
        , dependencies = None Dependencies
        , kindSeq = Some cnst
        }


let class_vp
   : Id -> Text -> List e.Arg -> List Parent -> Spec
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(parents : List Parent) ->
   Spec.Class_
        { id, name, vars, parents
        , dependencies = None Dependencies
        , kindSeq = None e.KindSeq
        }


let class_vc
   : Id -> Text -> List e.Arg -> e.KindSeq -> Spec
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(cnst : e.KindSeq) ->
   Spec.Class_
        { id, name, vars
        , parents = [] : List Parent
        , dependencies = None Dependencies
        , kindSeq = Some cnst
        }

let class_vd
   : Id -> Text -> List e.Arg -> Dependencies -> Spec
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(deps : Dependencies) ->
   Spec.Class_
        { id, name, vars
        , parents = [] : List Parent
        , dependencies = Some deps
        , kindSeq = None e.KindSeq
        }


let class_vpd
   : Id -> Text -> List e.Arg -> List Parent -> Dependencies -> Spec
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(parents : List Parent) -> \(deps : Dependencies) ->
   Spec.Class_
        { id, name, vars, parents
        , dependencies = Some deps
        , kindSeq = None e.KindSeq
        }


let class_vpc
   : Id -> Text -> List e.Arg -> List Parent -> e.KindSeq -> Spec
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(parents : List Parent) ->  \(cnst : e.KindSeq) ->
   Spec.Class_
        { id, name, vars, parents
        , dependencies = None Dependencies
        , kindSeq = Some cnst
        }


let class_vpdc
   : Id -> Text -> List e.Arg -> List Parent -> Dependencies -> e.KindSeq -> Spec
   = \(id : Id) -> \(name : Text) -> \(vars : List e.Arg) -> \(parents : List Parent) -> \(deps : Dependencies) -> \(cnst : e.KindSeq) ->
   Spec.Class_
        { id, name, vars, parents
        , dependencies = Some deps
        , kindSeq = Some cnst
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


let test_c01 = assert : e.KindSeq/render cctype ≡ "{{kw:Type}}"
let test_c02 = assert : e.KindSeq/render cctype2 ≡ "{{kw:Type}} {{op:->}} {{kw:Type}}"
let test_c03 = assert : e.KindSeq/render cctype3 ≡ "{{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}}"
let test_c04 = assert : e.KindSeq/render [ ctype, cfn_br [ ctype, ctype ], ctype ] ≡ "{{kw:Type}} {{op:->}} ({{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Type}}"
let test_c05 = assert : e.KindSeq/render [ ctype, cfn_br cctype2, ctype ] ≡ "{{kw:Type}} {{op:->}} ({{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Type}}"
let test_c06 = assert : e.KindSeq/render (ccforall [ v "k" ] [ ctype, cfn_br cctype2, cv "k" ]) ≡ "{{kw:forall}} {{var:k}}. {{kw:Type}} {{op:->}} ({{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{var:k}}"
let test_c07 = assert : e.KindSeq/render [ ctype, ctype, ccon ] ≡ "{{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Constraint}}"
let test_c08 = assert : e.KindSeq/render [ cfn_br cctype3, ccon ] ≡ "({{kw:Type}} {{op:->}} {{kw:Type}} {{op:->}} {{kw:Type}}) {{op:->}} {{kw:Constraint}}"


let Spec/renderKind
    : Spec -> Optional Text
    = \(spec : Spec) ->
    merge
        { Data_ = \(dd : DataSpec) ->
            merge
                { Some = \(ct : e.KindSeq) -> Some "{{kw:data}} {{type(${Id/render dd.id}):${dd.name}}} {{op:::}} ${e.KindSeq/render ct}"
                , None = None Text
                }
                dd.kindSeq
        , Type_ = \(td : TypeSpec) ->
            merge
                { Some = \(ct : e.KindSeq) -> Some "{{kw:type}} {{type(${Id/render td.id}):${td.name}}} {{op:::}} ${e.KindSeq/render ct}"
                , None = None Text
                }
                td.kindSeq
        , Newtype_ = \(ntd : NewtypeSpec) ->
            merge
                { Some = \(ct : e.KindSeq) -> Some "{{kw:newtype}} {{type(${Id/render ntd.id}):${ntd.name}}} {{op:::}} ${e.KindSeq/render ct}"
                , None = None Text
                }
                ntd.kindSeq
        , Class_ = \(cd : ClassSpec) ->
            merge
                { Some = \(ct : e.KindSeq) -> Some "{{kw:class}} {{class(${Id/render cd.id}):${cd.name}}} {{op:::}} ${e.KindSeq/render ct}"
                , None = None Text
                }
                cd.kindSeq
        , Package_ = \(pd : PackageSpec) -> None Text
        , Internal_ = \(id : InternalSpec) -> None Text
        }
        spec


let Spec/renderKindRaw
    : Spec -> Optional Text
    = \(spec : Spec) ->
    merge
        { Data_ = \(dd : DataSpec) ->
            merge
                { Some = \(ct : e.KindSeq) -> Some "data ${dd.name} :: ${e.KindSeq/renderRaw ct}"
                , None = None Text
                }
                dd.kindSeq
        , Type_ = \(td : TypeSpec) ->
            merge
                { Some = \(ct : e.KindSeq) -> Some "type ${td.name} :: ${e.KindSeq/renderRaw ct}"
                , None = None Text
                }
                td.kindSeq
        , Newtype_ = \(ntd : NewtypeSpec) ->
            merge
                { Some = \(ct : e.KindSeq) -> Some "newtype ${ntd.name} :: ${e.KindSeq/renderRaw ct}"
                , None = None Text
                }
                ntd.kindSeq
        , Class_ = \(cd : ClassSpec) ->
            merge
                { Some = \(ct : e.KindSeq) -> Some "class ${cd.name} :: ${e.KindSeq/renderRaw ct}"
                , None = None Text
                }
                cd.kindSeq
        , Package_ = \(pd : PackageSpec) -> None Text
        , Internal_ = \(id : InternalSpec) -> None Text
        }
        spec


let concatHelper
    : forall(a : Type) -> (a -> Text) -> Text -> List a -> Text
    = \(a : Type) -> \(render : a -> Text) -> \(sep : Text) -> \(res : List a) ->
        Text/concatSep sep (List/map a Text render res)


let concatArgs
    : Text -> List e.Arg -> Text
    = \(sep : Text) -> \(args : List e.Arg) ->
        concatHelper e.Arg e.Arg/render sep args


let concatArgsRaw
    : Text -> List e.Arg -> Text
    = \(sep : Text) -> \(args : List e.Arg) ->
        concatHelper e.Arg e.Arg/renderRaw sep args


let Parent/render
    : Parent -> Text
    = \(parent : Parent) ->
    tt "{{class(${Id/render parent.id}):${parent.name}}} ${concatArgs " " parent.vars}"


let Parent/renderRaw
    : Parent -> Text
    = \(parent : Parent) ->
    tt "${parent.name} ${concatArgsRaw " " parent.vars}"


let concatParents
    : Text -> List Parent -> Text
    = \(sep : Text) -> \(parents : List Parent) ->
        concatHelper Parent Parent/render sep parents


let concatParentsRaw
    : Text -> List Parent -> Text
    = \(sep : Text) -> \(parents : List Parent) ->
        concatHelper Parent Parent/renderRaw sep parents


let Dependency/render
    : Dependency -> Text
    = \(dep : Dependency) ->
    tt ((concatArgs "{{op:,}} " dep.from) ++ " {{op:->}} " ++ (concatArgs "{{op:,}} " dep.to))


let Dependency/renderRaw
    : Dependency -> Text
    = \(dep : Dependency) ->
    tt ((concatArgsRaw ", " dep.from) ++ " -> " ++ (concatArgsRaw ", " dep.to))


let Dependencies/render
    : Dependencies -> Text
    = \(deps : Dependencies) ->
    {-"{{op:|}} " ++ -} concatHelper Dependency Dependency/render "{{op:,}} " deps


let Dependencies/renderRaw
    : Dependencies -> Text
    = \(deps : Dependencies) ->
    {-"| " ++ -} concatHelper Dependency Dependency/renderRaw ", " deps


let Parents/render
    : List Parent -> Text
    = \(parents: List Parent) ->
    if List/null Parent parents then ""
    else "(${concatParents "{{op:,}} " parents}) {{op:<=}}"


let Parents/renderRaw
    : List Parent -> Text
    = \(parents: List Parent) ->
    if List/null Parent parents then ""
    else "(${concatParentsRaw ", " parents}) <="


let Spec/renderHeader
    : Spec -> Text
    = \(spec : Spec) ->
    merge
        { Data_ = \(dd : DataSpec) ->
            tt "{{kw:data}} {{type(${Id/render dd.id}):${dd.name}}} ${concatArgs " " dd.vars}"
        , Type_ = \(td : TypeSpec) ->
            tt "{{kw:type}} {{type(${Id/render td.id}):${td.name}}} ${concatArgs " " td.vars} {{op:=}} ${e.Expr/render td.expr}"
        , Newtype_ = \(ntd : NewtypeSpec) ->
            tt "{{kw:newtype}} {{type(${Id/render ntd.id}):${ntd.name}}} ${concatArgs " " ntd.vars}"
        , Class_ = \(cd : ClassSpec) ->
            tt ("{{kw:class}} ${Parents/render cd.parents} {{subj(${Id/render cd.id}):${cd.name}}} ${concatArgs " " cd.vars}" ++
                (merge
                    { Some = \(deps : Dependencies) -> " {{op:|}} " ++ Dependencies/render deps ++ " "
                    , None = " "
                    }
                    cd.dependencies
                )
            ) ++ "{{kw:where}}"
        , Package_ = \(pd : PackageSpec) ->
            -- "{{kw:package}} {{package:${pd.name}}}"
            "{{package(${Id/render pd.id}):${pd.name}}}"
        , Internal_ = \(id : InternalSpec) ->
            "{{internal(${Id/render id.id}):${id.name}}}"
        }
        spec


let Spec/renderHeaderRaw
    : Spec -> Text
    = \(spec : Spec) ->
    merge
        { Data_ = \(dd : DataSpec) ->
            tt "data ${dd.name} ${concatArgsRaw " " dd.vars}"
        , Type_ = \(td : TypeSpec) ->
            tt "type ${td.name} ${concatArgsRaw " " td.vars} = ${e.Expr/renderRaw td.expr}"
        , Newtype_ = \(ntd : NewtypeSpec) ->
            tt "newtype ${ntd.name} ${concatArgsRaw " " ntd.vars}"
        , Class_ = \(cd : ClassSpec) ->
            tt ("class ${Parents/renderRaw cd.parents} ${cd.name} ${concatArgsRaw " " cd.vars}" ++
                (merge
                    { Some = \(deps : Dependencies) -> " | " ++ Dependencies/renderRaw deps ++ " "
                    , None = " "
                    }
                    cd.dependencies
                )
            ) ++ "where"
        , Package_ = \(pd : PackageSpec) ->
            -- "package ${pd.name}"
            pd.name
        , Internal_ = \(id : InternalSpec) ->
            id.name
        }
        spec


let SpecText =
    { kind : Optional Text
    , header : Text
    }


let Spec/render
    : Spec -> SpecText
    = \(td : Spec) ->
    { kind = Spec/renderKind td
    , header = Spec/renderHeader td
    }


let Spec/renderRaw
    : Spec -> SpecText
    = \(td : Spec) ->
    { kind = Spec/renderKindRaw td
    , header = Spec/renderHeaderRaw td
    }


-- Type
let t1 : e.KindSeq = [ ctype ]

-- (Type -> Type) -> Type -> Type -> Type
let t2t3 : e.KindSeq = [ cfn_br cctype2, ctype, ctype, ctype ]

-- (Type -> Type -> Type) -> (Type -> Type -> Type) -> Type -> Type -> Type
let t3t3t3 : e.KindSeq = [ cfn_br cctype3, cfn_br cctype3, ctype, ctype, ctype ]

-- (Type -> Type -> Type) -> Type -> Type -> Type -> Type
let t3t4 : e.KindSeq = [ cfn_br cctype3, ctype, ctype, ctype, ctype ]

-- (Type -> Type -> Type) -> Type -> Type -> Type -> Type -> Type
let t3t5 : e.KindSeq = [ cfn_br cctype3, ctype, ctype, ctype, ctype, ctype ]

-- (Type -> Type -> Type) -> Type -> Type -> Type -> Type -> Type -> Type
let t3t6 : e.KindSeq = [ cfn_br cctype3, ctype, ctype, ctype, ctype, ctype, ctype ]

-- Type -> (Type -> Type) -> Type -> Type
let t_t2_t2 : e.KindSeq = [ ctype, cfn_br cctype2, ctype, ctype ]

-- (Type -> Type) -> Constraint
let t2c : e.KindSeq = [ cfn_br cctype2, ccon ]

-- (Type -> Type -> Type) -> Constraint
let t3c : e.KindSeq = [ cfn_br cctype3, ccon ]

-- Type -> (Type -> Type) -> Constraint
let tt2c : e.KindSeq = [ ctype, cfn_br cctype2, ccon ]

-- forall k. k -> Type
let kt : e.KindSeq = ccforall [ v "k" ] [ cv "k", ctype ]

-- forall k. Type -> k -> Type
let tkt : e.KindSeq = ccforall [ v "k" ] [ ctype, cv "k", ctype ]

-- forall k. (k -> Type) -> k -> Type
let kt_kt : e.KindSeq = ccforall [ v "k" ] [ cfn_br [ cv "k", ctype ], cv "k", ctype ]

-- forall k. (k -> Type) -> Type -> k -> Type
let kt_tkt : e.KindSeq = ccforall [ v "k" ] [ cfn_br [ cv "k", ctype ], cv "k", ctype ]

-- forall k. (k -> Type) -> (k -> Type) -> Type
let kt_kt_t : e.KindSeq = ccforall [ v "k" ] [ cfn_br [ cv "k", ctype ], cfn_br [ cv "k", ctype ], ctype ]

-- forall k. (k -> Type) -> (k -> Type) -> k -> Type
let kt_kt_kt : e.KindSeq = ccforall [ v "k" ] [ cfn_br [ cv "k", ctype ], cfn_br [ cv "k", ctype ], cv "k", ctype ]

-- forall k. (k -> k -> Type) -> k -> Type
let kkt_kt : e.KindSeq = ccforall [ v "k" ] [ cfn_br [ cv "k", cv "k", ctype ], cv "k", ctype ]

-- forall k1 k2. (k2 -> Type) -> (k1 -> k2) -> k1 -> Type
let k12kt : e.KindSeq = ccforall [ v "k1", v "k2" ] [ cfn_br [ cv "k2", ctype ], cfn_br [ cv "k1", cv "k2" ], cv "k1", ctype ]

-- forall k1 k2. (k1 -> k2 -> Type) -> k2 -> k1 -> Type
let kkt_kkt : e.KindSeq = ccforall [ v "k1", v "k2" ] [ cfn_br [ cv "k1", cv "k2", ctype ], cv "k2", cv "k1", ctype ]

-- forall k. (k -> Type) -> (k -> Type) -> Constraint
let kt_kt_c : e.KindSeq = ccforall [ v "k" ] [ cfn_br [ cv "k", ctype ], cfn_br [ cv "k", ctype ], ccon ]

-- forall k. (k -> k -> Type) -> Constraint
let kktc : e.KindSeq = ccforall [ v "k" ] [ cfn_br [ cv "k", cv "k", ctype ], ccon ]

in
    { id
    , DataSpec, NewtypeSpec, ClassSpec, TypeSpec, InternalSpec, PackageSpec
    , Spec, SpecText, Spec/render, Spec/renderRaw
    , Id/render, Spec/renderKind, Spec/renderKindRaw, Spec/renderHeader, Spec/renderHeaderRaw
    , Parent, Parent/render, Parent/renderRaw
    , ctype, cfn_br
    , cctype, cctype2, cctype3, ccon, ccforall
    , p, pe, v, vn, vp, cv
    , dep, dep1, deps1
    , data, data_c, data_e, data_ce, t, t_c, nt, nt_c, nt_e, pkg, int, class, class_v, class_c, class_vp, class_vc, class_vd, class_vpd, class_vpc, class_vpdc
    , t1, t2c, t3c, t3t3t3, t3t4, t3t5, t3t6, kt, tkt, t_t2_t2, kt_kt, kt_tkt, kt_kt_t, kt_kt_kt, tt2c, t2t3, k12kt, kkt_kkt, kt_kt_c, kktc, kkt_kt
    }