package com.nitrosubject

import com.margelo.nitro.nitrosubject.HybridNitroSubjectSpec

class HybridNitroSubject: HybridNitroSubjectSpec() {    
    override fun sum(num1: Double, num2: Double): Double {
        return num1 + num2
    }
}
