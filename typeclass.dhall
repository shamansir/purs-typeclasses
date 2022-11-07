let List/map =
    https://prelude.dhall-lang.org/List/map
let Text/concatSep =
    https://prelude.dhall-lang.org/Text/concatSep

let e = ./expr.dhall
let d = ./spec.dhall

-- let List/length =
--       https://prelude.dhall-lang.org/List/length


{- Types -}

let Id = Text

let Package = { name : Text, version : List Integer }

let Module = List Text

let Def = e.Expr

let DefText = Text -- TODO: e.SealedSource

let Example = e.Expr

let ExampleText = Text -- TODO: e.SealedSource

let Value = Text

let Var = Text -- TODO: e.What?

let VarWithKind = { name : Text, kind : Text }

let Instance = e.Expr

let InstanceText = Text -- TODO: e.SealedSource

let Def/toText = e.Expr/render

let Example/toText = e.Expr/render

let Instance/toText = e.Expr/render

let LawExample =
    < LR : { left : e.Expr, right : e.Expr }
    | LMR : { left : e.Expr, middle : e.Expr, right : e.Expr }
    | LRC : { left : e.Expr, right : e.Expr, conditions : List e.Expr }
    | FC : { fact : e.Expr, conclusion : e.Expr }
    | OF : { fact : e.Expr }
    >

let LawExampleText =
    < LR : { left : Text, right : Text }
    | LMR : { left : Text, middle : Text, right : Text }
    | LRC : { left : Text, right : Text, conditions : List Text }
    | FC : { fact : Text, conclusion : Text }
    | OF : { fact : Text }
    >

let LawExample/toText
    : LawExample -> LawExampleText
    = \(le : LawExample) ->
    merge
        { LR = \(lr : { left : e.Expr, right : e.Expr }) ->
            LawExampleText.LR { left = e.Expr/render lr.left, right = e.Expr/render lr.right }
        , LMR = \(lmr : { left : e.Expr, middle : e.Expr, right : e.Expr }) ->
            LawExampleText.LMR { left = e.Expr/render lmr.left, middle = e.Expr/render lmr.middle, right = e.Expr/render lmr.right }
        , LRC = \(lrc : { left : e.Expr, right : e.Expr, conditions : List e.Expr }) ->
            LawExampleText.LRC { left = e.Expr/render lrc.left, right = e.Expr/render lrc.right, conditions = List/map e.Expr Text e.Expr/render lrc.conditions }
        , FC = \(fc : { fact : e.Expr, conclusion : e.Expr }) ->
            LawExampleText.FC { fact = e.Expr/render fc.fact, conclusion = e.Expr/render fc.conclusion }
        , OF = \(of : { fact : e.Expr }) ->
            LawExampleText.OF { fact = e.Expr/render of.fact }
        }
        le


let Statement =
    { left : e.Expr, right : e.Expr }

let StatementText =
    { left : Text, right : Text }

let Statement/toText
    : Statement -> StatementText
    = \(s : Statement) ->
    { left = e.Expr/render s.left
    , right = e.Expr/render s.right
    }

let Law =
    { law : Id
    , examples : List { type : Text, v : LawExample }
    }

let LawText =
    { law : Id
    , examples : List { type : Text, v : LawExampleText }
    }

let Law/toText
    : Law -> LawText
    = \(l : Law) ->
    { law = l.law
    , examples =
        List/map
            { type : Text, v : LawExample }
            { type : Text, v : LawExampleText }
            (\(le : { type : Text, v : LawExample }) ->
                { type = le.type, v = LawExample/toText le.v }
            )
            l.examples
    }

let Belongs =
    < Yes
    | No
    | Constructor
    | Export : Module
    >

let Member =
    { name : Text
    , def : Def
    , op : Optional Text
    , opEmoji : Optional Text
    , laws : List Law
    , belongs : Belongs
    , examples : List Example
    }

let MemberText =
    { name : Text
    , def : DefText
    , op : Optional Text
    , opEmoji : Optional Text
    , laws : List LawText
    , belongs : Belongs
    , examples : List ExampleText
    }

let Member/toText
    : Member -> MemberText
    = \(m : Member) ->
    { name = m.name
    , def = Def/toText m.def
    , op = m.op
    , opEmoji = m.opEmoji
    , laws =
        List/map
            Law
            LawText
            Law/toText
            m.laws
    , belongs = m.belongs
    , examples =
        List/map
            Example
            ExampleText
            Example/toText
            m.examples
    }

let What =
    < Class_
    | Newtype_
    | Type_
    | Internal_
    | Data_
    | Package_
    >


let Connection =
    { parent : { id : Id, name : Text }, vars : List VarWithKind }


let Parent/toConnection
    : d.Parent -> Connection
    = \(p : d.Parent) ->
    { parent = { id = d.Id/render p.id, name = p.name }
    , vars =
        List/map
            e.Arg
            VarWithKind
            (\(arg : e.Arg) ->
                { name = e.Arg/varName arg, kind = e.Arg/kindText arg }
            )
            p.vars
    }


let Weight =
    < Auto
    | Custom : Double
    >


let Weight/toValue
    = \(w : Weight)
    -> merge
        { Auto = 1.0
        , Custom = \(n : Double) -> n
        }
        w


let TClass =
    { id : Id -- TODO: remove in favor of Spec
    , what : What -- TODO: remove in favor of Spec
    , vars : List Var -- TODO: remove in favor of Spec
    , link : Text -- TODO: version -- TODO: remove, contained in Package + Version
    , name : Text -- TODO: remove in favor of Spec
    , info  : Text -- TODO: support multiline
    , parents : List Id -- TODO: remove in favor of Spec
    , weight : Weight
    , spec : d.Spec
    , package : Package
    , module : Module
    , laws : List Law
    , members : List Member
    , instances : List Instance
    , values : List Value
    , statements : List Statement
    }

let Spec/getId
    : d.Spec -> Id
    = \(spec : d.Spec) ->
    d.Id/render (merge
        { Data_ = \(ds : d.DataSpec) -> ds.id
        , Type_ = \(ts : d.TypeSpec) -> ts.id
        , Newtype_ = \(nts : d.NewtypeSpec) -> nts.id
        , Class_ = \(cs : d.ClassSpec) -> cs.id
        , Package_ = \(ps : d.PackageSpec) -> ps.id
        , Internal_ = \(is : d.InternalSpec) -> is.id
        }
        spec)


let Spec/getName
    : d.Spec -> Text
    = \(spec : d.Spec) ->
    merge
        { Data_ = \(ds : d.DataSpec) -> ds.name
        , Type_ = \(ts : d.TypeSpec) -> ts.name
        , Newtype_ = \(nts : d.NewtypeSpec) -> nts.name
        , Class_ = \(cs : d.ClassSpec) -> cs.name
        , Package_ = \(ps : d.PackageSpec) -> ps.name
        , Internal_ = \(is : d.InternalSpec) -> is.name
        }
        spec


let Spec/extractWhat
    : d.Spec -> What
    = \(spec : d.Spec) ->
    merge
        { Data_ = \(_ : d.DataSpec) -> What.Data_
        , Type_ = \(_ : d.TypeSpec) -> What.Type_
        , Newtype_ = \(_ : d.NewtypeSpec) -> What.Newtype_
        , Class_ = \(_ : d.ClassSpec) -> What.Class_
        , Package_ = \(_ : d.PackageSpec) -> What.Package_
        , Internal_ = \(_ : d.InternalSpec) -> What.Internal_
        }
        spec


let Spec/extractVars
    : d.Spec -> List Var
    = \(spec : d.Spec) ->
    List/map
        e.Arg
        Var
        e.Arg/varName
        (merge
            { Data_ = \(ds : d.DataSpec) -> ds.vars
            , Type_ = \(ts : d.TypeSpec) -> ts.vars
            , Newtype_ = \(nts : d.NewtypeSpec) -> nts.vars
            , Class_ = \(cs : d.ClassSpec) -> cs.vars
            , Package_ = \(ps : d.PackageSpec) -> [] : List e.Arg
            , Internal_ = \(is : d.InternalSpec) -> [] : List e.Arg
            }
            spec)


let Spec/extractParents
    : d.Spec -> List Id
    = \(spec : d.Spec) ->
    List/map
        d.Parent
        Id
        (\(p : d.Parent) -> d.Id/render p.id)
        (merge
            { Data_ = \(ds : d.DataSpec) -> [] : List d.Parent
            , Type_ = \(ts : d.TypeSpec) -> [] : List d.Parent
            , Newtype_ = \(nts : d.NewtypeSpec) -> [] : List d.Parent
            , Class_ = \(cs : d.ClassSpec) -> cs.parents
            , Package_ = \(ps : d.PackageSpec) -> [] : List d.Parent
            , Internal_ = \(is : d.InternalSpec) -> [] : List d.Parent
            }
            spec)

let Spec/extractConnections
    : d.Spec -> List Connection
    = \(spec : d.Spec) ->
    List/map
        d.Parent
        Connection
        Parent/toConnection
        (merge
            { Data_ = \(ds : d.DataSpec) -> [] : List d.Parent
            , Type_ = \(ts : d.TypeSpec) -> [] : List d.Parent
            , Newtype_ = \(nts : d.NewtypeSpec) -> [] : List d.Parent
            , Class_ = \(cs : d.ClassSpec) -> cs.parents
            , Package_ = \(ps : d.PackageSpec) -> [] : List d.Parent
            , Internal_ = \(is : d.InternalSpec) -> [] : List d.Parent
            }
            spec)


let Package/makeLink
    : Package -> Module -> Text -> Text
    = \(pkg : Package) ->
      \(module : Module) ->
      \(name : Text) ->
    pkg.name
    ++ "/" ++ Text/concatSep "."
        (List/map Natural Text Natural/show
            (List/map Integer Natural Integer/clamp pkg.version))
    ++ "/docs/"
    ++ (Text/concatSep "." module)
    ++ "." ++ name


let Package/makeTLink
    : Package -> Module -> Text -> Text
    = \(pkg : Package) ->
      \(module : Module) ->
      \(name : Text) ->
    Package/makeLink pkg module name ++ "#t:" ++ name

let test_makeLink1
    = assert : Package/makeLink { name = "purescript-bifunctors", version = [ +5, +0, +0 ] } [ "Control" ] "Biapplicative"
    ≡ "purescript-bifunctors/5.0.0/docs/Control.Biapplicative"

let test_makeLink2
    = assert : Package/makeLink { name = "purescript-control", version = [ +1, +2, +3 ] } [ "Data", "Monoid" ] "Alternate"
    ≡ "purescript-control/1.2.3/docs/Data.Monoid.Alternate"

let test_makeTLink3
    = assert : Package/makeTLink { name = "purescript-control", version = [ +1, +2, +3 ] } [ "Data", "Monoid" ] "Alternate"
    ≡ "purescript-control/1.2.3/docs/Data.Monoid.Alternate#t:Alternate"

    -- purescript-bifunctors/5.0.0/docs/Control.Biapplicative"
    -- "purescript-control/5.0.0/docs/Data.Monoid.Alternate#t:Alternate"
    -- purescript-control/5.0.0/docs/Control.Alt#t:Alt

let TClassText =
    { id : Id
    , what : What
    , vars : List Var
    , link : Text
    , name : Text
    , info  : Text
    , parents : List Id
    , connections : List Connection
    , spec : d.SpecText
    , package : Package
    , module : Module
    , laws : List LawText
    , members : List MemberText
    , instances : List InstanceText
    , values : List Value
    , statements : List StatementText
    , weight : Double
    }


let TClass/toText
    : TClass -> TClassText
    = \(t : TClass) ->
    { id = {- t.id -} Spec/getId t.spec
    , what = {- t.what -} Spec/extractWhat t.spec
    , vars = {- t.vars -}  Spec/extractVars t.spec
    , link = {- t.link -} Package/makeLink t.package t.module t.name
    , name = {- t.name -} Spec/getName t.spec
    , weight = Weight/toValue t.weight
    , info = t.info
    , parents = Spec/extractParents t.spec
    , package = t.package
    , module = t.module
    , spec = d.Spec/render t.spec
    , connections = Spec/extractConnections t.spec
    , laws =
        List/map
            Law
            LawText
            Law/toText
            t.laws
    , members =
        List/map
            Member
            MemberText
            Member/toText
            t.members
    , instances =
        List/map
            Instance
            InstanceText
            Instance/toText
            t.instances
    , values = t.values
    , statements =
        List/map
            Statement
            StatementText
            Statement/toText
            t.statements
    }

let noOp : Optional Text = None Text

let noParents = { parents = [] : List Id }

let noInstances = { instances = [] : List Instance }

let noOps = { op = noOp, opEmoji = noOp }

let noLaws = { laws = [] : List Law }

let noMembers = { members = [] : List Member }

let noValues = { values = [] : List Value }

let noVars = { vars = [] : List Var }

let noStatements = { statements = [] : List Statement }

let noExamples = { examples = [] : List Example }

let autoWeight = { weight = Weight.Auto }

let aw = autoWeight

let weight = \(n : Double) -> { weight = Weight.Custom n }

let w = weight

let lr =
    \(v : { left : e.Expr, right : e.Expr })
    -> { type = "lr", v = LawExample.LR v }

let lmr =
    \(v : { left : e.Expr, middle : e.Expr, right : e.Expr })
    -> { type = "lmr", v = LawExample.LMR v }

let lrc =
    \(v : { left : e.Expr, right : e.Expr, conditions : List e.Expr })
    -> { type = "lrc", v = LawExample.LRC v }

let fc =
    \(v : { fact : e.Expr, conclusion : e.Expr })
    -> { type = "fc", v = LawExample.FC v }

let of =
    \(v : { fact : e.Expr })
    -> { type = "of", v = LawExample.OF v }

let one
    : forall (t : Type) -> forall (a : t) -> List t
    = \(t : Type) -> \(a : t) -> [ a ]

let oneEx
    : LawExample -> List LawExample
    = one LawExample

let pk
    : Text -> Integer -> Integer -> Integer -> Package
    = \(name : Text) -> \(major : Integer) -> \(minor : Integer) -> \(patch : Integer) ->
    { name, version = [ major, minor, patch ]}

let pkmn
    : Text -> Integer -> Integer -> Package
    = \(name : Text) -> \(major : Integer) -> \(minor : Integer) ->
    { name, version = [ major, minor, +0 ]}

let pkmj
    : Text -> Integer -> Package
    = \(name : Text) -> \(major : Integer) ->
    { name, version = [ major, +0, +0 ]}

in
    { TClass, TClassText, TClass/toText
    , Id, Value
    , Law, LawExample, Member, What, Belongs
    , one, oneEx
    , noOp, noOps, noLaws, noParents, noMembers, noInstances, noValues, noStatements, noVars, noExamples
    , autoWeight, aw, weight, w
    , lr, lmr, lrc, fc, of
    , pk, pkmn, pkmj
    }