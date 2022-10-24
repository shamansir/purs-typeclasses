let List/map =
      https://prelude.dhall-lang.org/List/map

let e = ./expr.dhall
let d = ./typedef.dhall

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


let TClass =
    { id : Id -- TODO: remove in favor of TypeDef
    , what : What -- TODO: remove in favor of TypeDef
    , vars : List Var -- TODO: remove in favor of TypeDef
    , link : Text -- TODO: version -- TODO: remove, contained in Package + Version
    , name : Text -- TODO: remove in favor of TypeDef
    , info  : Text -- TODO: support multiline
    , parents : List Id -- TODO: remove in favor of TypeDef
    , def : d.Def
    , package : Package
    , module : Module
    , laws : List Law
    , members : List Member
    , instances : List Instance
    , values : List Value
    , statements : List Statement
    }

let TClassText =
    { id : Id
    , what : What
    , vars : List Var
    , link : Text
    , name : Text
    , info  : Text
    , parents : List Id
    , def : d.DefText
    , package : Package
    , module : Module
    , laws : List LawText
    , members : List MemberText
    , instances : List InstanceText
    , values : List Value
    , statements : List StatementText
    }

let TClass/toText
    : TClass -> TClassText
    = \(t : TClass) ->
    { id = t.id
    , what = t.what
    , vars = t.vars
    , link = t.link
    , name = t.name
    , info = t.info
    , parents = t.parents
    , package = t.package
    , module = t.module
    , def = d.Def/render t.def
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
    , lr, lmr, lrc, fc, of
    , pk, pkmn, pkmj
    }