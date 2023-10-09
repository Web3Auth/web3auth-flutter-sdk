package com.web3auth.flutter.web3auth_flutter.types

import com.web3auth.core.types.Language
import com.web3auth.core.types.ThemeModes
import com.web3auth.core.types.WhiteLabelData

data class WLData(
    private var appName: String? = null,
    private var appUrl: String? = null,
    private var logoLight: String? = null,
    private var logoDark: String? = null,
    private var defaultLanguage: Language? = Language.EN,
    private var mode: ThemeModes? = ThemeModes.LIGHT,
    private var theme: HashMap<String, String>? = null,
    private var useLogoLoader: Boolean? = false
) {
    fun toWhiteLabelData() : WhiteLabelData {
        return WhiteLabelData(
            appName = appName,
            appUrl = appUrl,
            logoLight = logoLight,
            logoDark = logoDark,
            defaultLanguage = defaultLanguage,
            mode = mode,
            theme = theme,
            useLogoLoader = useLogoLoader
        )
    }
}