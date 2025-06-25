package com.techcomparison.kmp.models

import platform.Foundation.NSUUID
import kotlin.random.Random

actual fun generateUUID(): String {
    return NSUUID().UUIDString()
}

actual fun getCurrentTimestamp(): Long {
    // Simple timestamp simulation for demo
    return 1703070000000L // Fixed timestamp for demo
} 