package com.aurex.core.application

/**
 * Minimal application-layer use case used to verify common-code execution.
 * Keep this free of UI, Android, database and network dependencies.
 */
class FoundationStatus {
    fun message(): String = "Your business ecosystem starts here."
}
