package com.openlogin.flutter.openlogin_flutter.types

data class LoginConfigItem(
    var verifier: String,
    var typeOfLogin: TypeOfLogin,
    var name: String,
    var description: String? = null,
    var clientId: String? = null,
    var verifierSubIdentifier: String? = null,
    var logoHover: String? = null,
    var logoLight: String? = null,
    var logoDark: String? = null,
    var mainOption: Boolean? = false,
    var showOnModal: Boolean? = true,
    var showOnDesktop: Boolean? = true,
    var showOnMobile: Boolean? = true,
)