# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

Interactive visualization of PureScript typeclasses as a graph. Data is defined in Dhall, compiled to JSON, served statically, and rendered by an Elm browser app using SVG.

## Commands

**Generate JSON from Dhall definitions:**
```sh
./generate.sh
# equivalent: dhall-to-json --file ./classes.dhall > ./gen/purs-typeclasses.json
```

**Run dev server (Elm live reload):**
```sh
./run.sh
# equivalent: elm-live ./src/Main.elm --start-page=./index.html -- --output=./app.js
```

**Serve generated JSON locally (for dev, on port 8042):**
```sh
./serve-data.sh
# equivalent: http-server ./gen --port 8042 --cors
```

**Nix dev shell (provides dhall, elm, purs, spago, etc.):**
```sh
nix develop
```

To point the app at local data instead of GitHub Pages, edit `serverUrl` in `src/Main.elm`:
```elm
-- serverUrl = "https://shamansir.github.io/purs-typeclasses/gen/"
serverUrl = "http://localhost:8042/"
```

## Architecture

### Data pipeline

```
def/**/*.dhall   →  classes.dhall  →  generate.sh  →  gen/purs-typeclasses.json
```

- **`typeclass.dhall`** — core schema: `TClass`, `Member`, `Law`, `LawExample`, `Belongs`, `What`, `Connection`, etc. Also helper aliases (`pk`, `aw`, `lr`, `lmr`, …).
- **`spec.dhall`** / **`expr.dhall`** — lower-level types for specs (`ClassSpec`, `DataSpec`, …) and expressions (`Expr`, `Arg`, …) used inside typeclass definitions.
- **`def/<package>/<typeclass>.dhall`** — one file per typeclass/type/newtype, imported by `classes.dhall`.
- `classes.dhall` collects all `def/` entries into a list and maps them through `TClass/toText` to produce serialisable `TClassText` records. The output JSON is an object `{ defs: [...] }`.

### Elm app

Loaded from `gen/purs-typeclasses.json` via HTTP on init. No user file upload in current build (code is commented out).

| Module | Role |
|---|---|
| `Main` | Browser.element wiring — `Model`, `Msg`, `init`/`update`/`view` |
| `PureScript.TypeClass` | Core Elm types mirroring `TClassText` from Dhall |
| `PureScript.Decode` | JSON decoders; `decodeMany` produces `Dict TextId TypeClass` |
| `PureScript.Graph` | Converts the dict to `elm-community/graph` `EGraph`; `extractToc` builds package→classes index |
| `PureScript.State` | UI state (`collapsed`, `packagesShown`, `focus`, toggles), `Msg`, `update` |
| `PureScript.Render` | SVG rendering of the graph and typeclass cards |
| `PureScript.Render.Setup` | Layout constants (sizes, positions) |
| `PureScript.Tokenize` | Tokenises typeclass definition strings for syntax-highlighted rendering |

### Key data flow in Elm

1. `init` fetches JSON → decodes to `Dict TextId TypeClass` → `PS.toGraph` → `Graph (Selected, TypeClass) Extends`
2. `view` passes both `State` and the graph to `PS.graph` / `PS.toc` / `PS.stateControl`
3. UI interactions emit `PS.Msg` (wrapped as `ToPS`), handled by `PS.update` which only mutates `State` — the graph is immutable after load

### Graph structure

Nodes: `TypeClass` (one per Dhall def). Edges: `Extends { parentId, childId }` derived from `parents` field in each typeclass. Node ordering in the graph is by `.weight` descending (higher weight = rendered earlier/more prominently).

## Adding a new typeclass

1. Create `def/<package>/<name>.dhall` following existing examples.
2. Add its path to `classes.dhall`.
3. Run `./generate.sh` to update `gen/purs-typeclasses.json`.
