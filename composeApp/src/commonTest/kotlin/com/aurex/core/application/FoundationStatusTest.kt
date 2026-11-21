package com.aurex.core.application

import kotlin.test.Test
import kotlin.test.assertEquals

class FoundationStatusTest {
    @Test
    fun returnsFoundationMessage() {
        assertEquals(
            "Your business ecosystem starts here.",
            FoundationStatus().message()
        )
    }
}
