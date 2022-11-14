module PureScript.TypeClass exposing (..)


import Dict exposing (Dict)


type Id = Id String


type alias TextId = String


type alias Name = String


idToString : Id -> TextId
idToString (Id id) = id


type LawExample
    = LR  { left : String, right : String }
    | LMR { left : String, middle : String, right : String }
    | LRC { left : String, right : String, conditions : List String }
    | FC  { fact : String, conclusion : String }
    | OF  { fact : String }


type alias Statement =
    { left : String
    , right : String
    }


type alias Law =
    { law : String
    , examples : List LawExample
    }


type alias Member =
    { name : String
    , def : Def
    , op : Maybe Op
    , opEmoji : Maybe Op
    , laws : List Law
    , examples : List Example
    }


type alias What = String


type alias PackageName = String


type alias Package = { name : PackageName, version : List Int }


type alias ParentName = String


type alias ParentRef = { name : ParentName, id : Id }


type alias VarName = String


type alias VarKind = String


type alias VarWithKind = { kind : VarKind, name : VarName }


type alias Connection = { parent : ParentRef, vars : List VarWithKind }


type alias Instance = String


type alias Module = String


type alias Def = String


type alias Value = String


type alias Op = String


type alias Link = String


type alias Parent = Id


type alias Var = String


type alias Example = String


type alias TypeClass =
    { id : Id
    , name : Name
    , info : String
    , what : What
    , vars : List Var
    , link : Link
    , weight : Float
    , connections : List Connection
    , parents : List Parent
    , package : Package
    , module_ : List Module
    , instances : List Instance
    , statements : List Statement
    , members : List Member
    , values : List Value
    , laws : List Law
    }


type alias Toc = Dict PackageName (List ( Id, Name ))
