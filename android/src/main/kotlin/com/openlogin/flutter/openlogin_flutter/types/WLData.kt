package com.openlogin.flutter.openlogin_flutter.types

import com.web3auth.core.types.WhiteLabelData

data class WLData (
    private var name : String? = null,
    private var logoLight : String? = null,
    private var logoDark : String? = null,
    private var defaultLanguage : String? = "en",
    private var dark : Boolean? = false,
    private var theme : HashMap<String, String>? = null
) {
    fun toWhiteLabelData() : WhiteLabelData {
        return WhiteLabelData(
            name = name,
            logoLight = logoLight,
            logoDark = logoDark,
            defaultLanguage = defaultLanguage,
            dark = dark,
            theme = theme
        )
    }
}