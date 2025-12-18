import * as THREE from 'three'

const defaultSkipUniforms = ['u_resolution', 'u_time', 'u_pr', 'u_mouse']

export const cleanupUniforms = (
    material: THREE.ShaderMaterial,
    skipUniforms = defaultSkipUniforms
) => {
    const uniforms = material.uniforms
    for (const key of Object.keys(uniforms)) {
        if (!skipUniforms.includes(key)) {
            uniforms[key].value = null
        }
    }
}

export const findShaderError = (renderer: THREE.WebGLRenderer) => {
    let programs = renderer.info && renderer.info.programs
    let errs = ''
    console.log('programs length: ', programs?.length)
    programs?.forEach((p, i) => {
        // @ts-ignore
        let diagnostics = p.diagnostics
        let err = diagnostics && diagnostics.fragmentShader && diagnostics.fragmentShader.log
        if (err)
            errs += `
        program ${i}: ${err}`
    })
    return errs
}
