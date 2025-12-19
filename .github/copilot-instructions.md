# Copilot Instructions for this Repo

## Overview

-   **App Stack:** Vue 3 + TypeScript + Vite with Three.js for rendering fragment shaders on a plane, and `vite-plugin-glsl` to import GLSL as strings.
-   **Runtime Flow:** Route `/sketches/:sketch` → load `src/glsl/<name>.glsl` (string) → set as `fragmentShader` in `CanvasThree.vue` → apply uniforms & textures from `src/uniforms/<name>.ts` → render frame in a RAF loop.
-   **Key Files:** Router and app boot in [src/main.ts](../src/main.ts), shader render in [src/components/CanvasThree.vue](../src/components/CanvasThree.vue), GUI in [src/components/GuiThree.vue](../src/components/GuiThree.vue), shader strings in [src/glsl](../src/glsl), uniforms in [src/uniforms](../src/uniforms), helper utils in [src/utils/three-utils.ts](../src/utils/three-utils.ts).

## Build & Run

-   **Install:** `pnpm install`
-   **Dev:** `pnpm dev` (Vite dev server)
-   **Build:** `pnpm build` (type-check via `vue-tsc`, then Vite build)
-   **Preview:** `pnpm preview`

## Shader Authoring

-   **Fragment Source:** Place shaders in [src/glsl](../src/glsl) as `<name>.glsl`. They are imported as strings via `vite-plugin-glsl` and set to `ShaderMaterial.fragmentShader`.
-   **Auto uniforms:** Provided by `CanvasThree`: `u_resolution`, `u_time`, `u_pr`, `u_mouse`, `u_viewport`. Do not redefine these in your uniforms module.
-   **Available varyings:** Vertex shader supplies `vUv`, `vPosition`, and view/model/projection varyings; most shaders use `vUv`.
-   **Three.js chunks:** You can include `#include <colorspace_fragment>` and `#include <tonemapping_fragment>` at the end of fragment shaders (see examples in [src/glsl](../src/glsl)).
-   **LYGIA includes:** The repo vendors LYGIA at [src/glsl/lygia](../src/glsl/lygia). Include via relative paths, e.g. `#include "lygia/generative/cnoise.glsl"` or `#include "lygia/filter/gaussianBlur.glsl"`.
-   **List visibility:** Files prefixed with `_` are hidden from the UI list (see [src/components/SketchesList.vue](../src/components/SketchesList.vue)) but remain routable.

## Uniforms & GUI

-   **Define per-shader uniforms** in [src/uniforms](../src/uniforms) with the same basename as the shader file, exporting `ShaderInfo` with `uniforms` and optional `presets`, `textures`, `sizeControls`.
-   **Types & controls:** The GUI auto-detects types from `THREE.Color`, numbers, booleans, and `THREE.Vector2`, wiring min/max/step sliders where provided (see [src/types/types.ts](../src/types/types.ts) and [src/components/GuiThree.vue](../src/components/GuiThree.vue)).
-   **Textures:** Provide a `textures` object with keys matching uniform names and `path` relative to `public/`. They are loaded via `THREE.TextureLoader` (see `setTextures()` in [src/components/CanvasThree.vue](../src/components/CanvasThree.vue)).
-   **Size controls:** Set `sizeControls: true` to expose width/height and `pixelRatio` in the GUI. `u_viewport` reflects the logical plane size; `u_resolution` is the actual canvas pixel size.

## Rendering & Error Handling

-   **RAF loop:** `u_time`, `u_mouse`, and rendering are updated per-frame (see `tick()` in [src/components/CanvasThree.vue](../src/components/CanvasThree.vue)).
-   **Switching shaders:** `cleanupUniforms()` nulls previous non-default uniforms to avoid stale values (see [src/utils/three-utils.ts](../src/utils/three-utils.ts)). Always call it before swapping shaders.
-   **Compile errors:** Three’s `renderer.debug.onShaderError` is used and logs are extracted via `findShaderError()` (see [src/utils/three-utils.ts](../src/utils/three-utils.ts)); the UI displays errors, although this is sometimes flawed.

## Conventions & Patterns

-   **Naming:** Shader `<name>.glsl` ↔ uniforms `<name>.ts`. You must use matching basenames for the uniforms to be loaded along with the shader.
-   **GUI presets:** Optional `presets` array in `ShaderInfo` lets `GuiThree` swap uniform sets.
-   **Includes folder:** A few common local helpers live under [src/glsl/includes](../src/glsl/includes). Prefer LYGIA for robust primitives.
-   **Commenting style:** Favor self-explanatory code; comment WHY, not WHAT. Use type-driven uniform metadata for clarity instead of explanatory comments.

## Minimal Examples

-   **Uniforms module:**

```ts
// src/uniforms/my-shader.ts
import * as THREE from 'three'
import type { ShaderUniform, ShaderInfo } from '../types/types'

const uniforms = {
    u_colorDark: { value: new THREE.Color('#111') },
    u_colorLight: { value: new THREE.Color('#eee') },
    u_amount: { value: 0.5, min: 0, max: 1, step: 0.01 },
} satisfies { [key: string]: ShaderUniform }

const shaderInfo: ShaderInfo<keyof typeof uniforms> = {
    uniforms,
}

export default shaderInfo
```

-   **Fragment snippet:**

```glsl
precision mediump float;
uniform vec2 u_resolution; uniform float u_time; varying vec2 vUv;
uniform vec3 u_colorDark, u_colorLight; uniform float u_amount;
void main(){
  float t = 0.5 + 0.5*sin(u_time);
  vec3 col = mix(u_colorDark, u_colorLight, mix(t, vUv.x, u_amount));
  gl_FragColor = vec4(col, 1.0);
  #include <colorspace_fragment>
  #include <tonemapping_fragment>
}
```

## Common Gotchas

-   **Do not** add default uniforms (`u_resolution`, `u_time`, `u_pr`, `u_mouse`, `u_viewport`) in your `uniforms` module; they are injected automatically.
-   **Keep paths** correct for LYGIA and textures; LYGIA is under `src/glsl/lygia`, textures under `public/`.
-   **When changing canvas sizes**, `u_resolution` and `u_viewport` are updated by `updateSizes()`; rely on those for pixel/viewport conversions.

## Adding a New Sketch

-   **Create shader:** Add [src/glsl/<name>.glsl](../src/glsl) with a minimal fragment:

```glsl
precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_viewport;
uniform float u_time;
uniform float u_pr;

varying vec2 vUv;

// custom uniforms, e.g.
uniform vec3 u_colorDark;
uniform vec3 u_colorLight;
uniform float u_amount;

#define PI 3.14159265358979323846

void main(){
	vec2 st = gl_FragCoord.xy / u_resolution.xy;

  float t = 0.5 + 0.5*sin(u_time);
  vec3 col = mix(u_colorDark, u_colorLight, mix(t, st.x, u_amount));
  gl_FragColor = vec4(col, 1.0);

  #include <colorspace_fragment>
  #include <tonemapping_fragment>
}
```

-   **Create uniforms module:** Add [src/uniforms/<name>.ts](../src/uniforms) exporting `ShaderInfo` with matching basename:

```ts
import * as THREE from 'three'
import type { ShaderInfo, ShaderUniform } from '../types/types'

const uniforms = {
    u_colorDark: { value: new THREE.Color('#111') },
    u_colorLight: { value: new THREE.Color('#eee') },
    u_amount: { value: 0.5, min: 0, max: 1, step: 0.01 },
} satisfies { [key: string]: ShaderUniform }

const shaderInfo: ShaderInfo<keyof typeof uniforms> = {
    uniforms,
}

export default shaderInfo
```

-   **Auto uniforms:** Do not add `u_resolution`, `u_time`, `u_pr`, `u_mouse`, `u_viewport` in your uniforms module; [src/components/CanvasThree.vue](../src/components/CanvasThree.vue) injects them.

-   **GUI controls:** Number uniforms with `min/max/step` become sliders; `THREE.Color` becomes a color picker; `THREE.Vector2` exposes `x/y`. Enable `sizeControls` to adjust width/height and pixel ratio.

-   **Textures (optional):** If requested, add entries under `textures` with keys matching uniform names and paths relative to `public/`. Example:

```ts
export default {
    uniforms,
    textures: { u_myTex: { value: null, path: '/images/myTex.png' } },
} satisfies ShaderInfo
```

-   **Includes:** Use vendored LYGIA via relative paths, e.g. `#include "lygia/generative/cnoise.glsl"`, `#include "lygia/filter/gaussianBlur.glsl"` from [src/glsl/lygia](../src/glsl/lygia).
