import { type ShaderInfo } from '../types/uniforms'
import * as THREE from 'three'
import { COLORS } from '../utils/colors'

const uniforms = {
    u_versionOverlap: {
        value: true,
    },
    u_color1: {
        // value: new THREE.Color('#e1c1c5'),
        value: COLORS.blue,
    },
    u_color2: {
        // value: new THREE.Color('#704855'),
        value: COLORS.indigo,
    },
    u_color3: {
        value: COLORS.darkIndigo,
    },
    // u_color4: {
    //     value: new THREE.Color('#9b538b'),
    // },
    u_managedColors: {
        value: true,
        hide: true,
    },
}

const ShaderInfo: ShaderInfo<typeof uniforms> = {
    uniforms,
}

export default ShaderInfo
