package com.aurex.app

import android.app.Application
import com.aurex.core.di.appModule
import org.koin.core.context.startKoin

/**
 * Owns process-wide dependency injection initialization.
 *
 * Keeping Koin startup here avoids restarting the global Koin context when
 * Android recreates an Activity after configuration changes or process flows.
 */
class AurexApplication : Application() {
    override fun onCreate() {
        super.onCreate()

        startKoin {
            modules(appModule)
        }
    }
}
