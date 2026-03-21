import { ShaderInfo, ShaderUniform } from '../types/uniforms'
import * as THREE from 'three'

const uniforms = {
    u_a: {
        value: new THREE.Color('#7f7f7f'),
    },
    u_b: {
        // value: new THREE.Color('#112233'),
        value: new THREE.Vector3(0.5, 0.5, 0.5),
        min: 0,
        max: 1,
        step: 0.01,
    },
    u_c: {
        // value: new THREE.Color('#112233'),
        value: new THREE.Vector3(1.0, 1.0, 1.0),
        min: 0,
        max: 3,
        step: 0.01,
    },
    u_d: {
        // value: new THREE.Color('#aa22ff'),
        value: new THREE.Vector3(0.0, 0.33, 0.67),
        min: 0,
        max: 1,
        step: 0.01,
    },
    u_stretch: {
        value: 1,
        min: 0,
        max: 5,
        step: 0.1,
    },
} satisfies { [key: string]: ShaderUniform }

const shaderInfo: ShaderInfo<typeof uniforms> = {
    uniforms,
    presets: [
        {
            u_a: new THREE.Color('#7f7f7f'),
            u_b: { x: 0.5, y: 0.5, z: 0.5 },
            // u_b: new THREE.Vector3(0.5, 0.5, 0.5),
            u_c: new THREE.Vector3(1.0, 1.0, 1.0),
            u_d: new THREE.Vector3(0, 0.1, 0.2),
        },
        {
            u_a: new THREE.Color('#7f7f7f'),
            u_b: new THREE.Vector3(0.5, 0.5, 0.5),
            u_c: new THREE.Vector3(2, 1, 0),
            u_d: new THREE.Vector3(0.5, 0.2, 0.25),
        },
        {
            u_a: new THREE.Color('#fad000'),
            u_b: new THREE.Vector3(0.5, 0.5, 0.5),
            u_c: new THREE.Vector3(1.0, 1.0, 1.0),
            u_d: new THREE.Vector3(0, 0.33, 0.67),
        },
        {
            u_a: new THREE.Color('#883388'),
            u_b: new THREE.Vector3(0.25, 0.25, 0.25),
            u_c: new THREE.Vector3(1, 1, 2),
            u_d: new THREE.Vector3(0.5, 0.45, 0.45),
        },
    ],
}

export default shaderInfo
