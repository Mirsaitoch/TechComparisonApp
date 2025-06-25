package com.techcomparison.kmp

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform