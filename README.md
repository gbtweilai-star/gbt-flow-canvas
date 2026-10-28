# flow_canvas

**One capability bit from GBT V8, packaged standalone.** No. 36 of 341,
`creation` domain (Creation).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 工作流画布（蒸馏自 2026-09-28 主人给的周榜卡 Langflow 155.3k★，只取**可视化架构**，不引拖拽编辑器）：工作流定义 → 图（nodes/edges，数据只走引擎正规出口 `engine.list_workflows()`，R-H99b，不偷读 store/workflows.json）+ dag 运行账 → 运行图（带 done/failed 读数）→ **自包含 SVG 画布页**（零外链零脚本，离线可开可审计）落 outputs/flow-canvas/。**只画不跑**：执行仍走 wf_run/dagrun 的门，产物不掺页面登记面。op=from_wf/from_dag/render/where

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-flow-canvas.git
cd gbt-flow-canvas
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_flow_canvas info                  # capability card
python -m gbt_flow_canvas spec --json           # machine-readable contract
python -m gbt_flow_canvas check --payload '{}'
python -m gbt_flow_canvas run   --payload '{}'
```

Real `info` output from this machine:

```text
flow_canvas  (creation)  v1.0.0
----------------------------------------
工作流画布（蒸馏自 2026-09-28 主人给的周榜卡 Langflow 155.3k★，只取**可视化架构**，不引拖拽编辑器）：工作流定义 → 图（nodes/edges，数据只走引擎正规出口 `engine.list_workflows()`，R-H99b，不偷读 store/workflows.json）+ dag 运行账 → 运行图（带 done/failed 读数）→ **自包含 SVG 画布页**（零外链零脚本，离线可开可审计）落 outputs/flow-canvas/。**只画不跑**：执行仍走 wf_run/dagrun 的门，产物不掺页面登记面。op=from_wf/from_dag/render/where

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : from_wf, from_dag, render, where
```

Wire a real implementation:

```python
from gbt_flow_canvas import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（4 个）**：`from_wf`、`from_dag`、`render`、`where`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.13s
```

## Provenance

| field | value |
|---|---|
| capability | `flow_canvas` |
| domain | `creation` |
| handler | `flow_canvas` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [creation/flow_canvas](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/creation/flow_canvas.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
