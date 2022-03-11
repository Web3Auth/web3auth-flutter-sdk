package com.openlogin.flutter.openlogin_flutter.types

import com.web3auth.core.types.TypeOfLogin

data class LoginConfig(val loginConfig : HashMap<String, LoginConfigItem>?) {
    fun toLoginConfig() : HashMap<String, com.web3auth.core.types.LoginConfigItem>? {
        val loginConfigMap : HashMap<String, com.web3auth.core.types.LoginConfigItem> = HashMap()

        if (loginConfig == null) return null

        for (key in loginConfig.keys) {
            val loginConfigVal = loginConfig[key]
            if (loginConfigVal != null) {
                loginConfigMap[key] = com.web3auth.core.types.LoginConfigItem(
                    verifier = loginConfigVal.verifier,
                    typeOfLogin = TypeOfLogin.valueOf(loginConfigVal.typeOfLogin.toString()),
                    name = loginConfigVal.name,
                    description = loginConfigVal.description,
                    clientId = loginConfigVal.clientId,
                    verifierSubIdentifier = loginConfigVal.verifierSubIdentifier,
                    logoHover = loginConfigVal.logoHover,
                    logoLight = loginConfigVal.logoLight,
                    logoDark = loginConfigVal.logoDark,
                    mainOption = loginConfigVal.mainOption,
                    showOnModal = loginConfigVal.showOnModal,
                    showOnDesktop = loginConfigVal.showOnDesktop,
                    showOnMobile = loginConfigVal.showOnMobile
                )
            }

        }
        return loginConfigMap
    }
}