package com.techcomparison.kmm.models

import platform.Foundation.NSUUID
import platform.Foundation.NSDate

actual fun generateUUID(): String {
    return NSUUID().UUIDString()
}

actual fun getCurrentTimestamp(): Long {
    return (NSDate().timeIntervalSince1970 * 1000).toLong()
} 