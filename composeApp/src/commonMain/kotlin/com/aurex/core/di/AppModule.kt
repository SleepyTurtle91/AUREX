package com.aurex.core.di

import com.aurex.core.application.FoundationStatus
import org.koin.dsl.module

val appModule = module {
    single { FoundationStatus() }
}
