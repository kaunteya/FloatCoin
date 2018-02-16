//
//  Locale.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 16/02/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation

extension Locale {
    init?(_ currencySymbol: String) {
        guard let locale = dict[currencySymbol] else { return nil }
        self.init(identifier: locale)
    }
}

let dict = ["XAF" : "en_CM", "MYR" : "en_MY", "RON" : "en_RO", "ANG" : "en_SX", "BTN" : "dz_BT", "NGN" : "en_NG", "SSP" : "en_SS", "BWP" : "en_BW", "MRO" : "fr_MR", "MAD" : "shi_MA", "HTG" : "es_HT", "RWF" : "en_RW", "SGD" : "en_SG", "ALL" : "en_AL", "SEK" : "en_SE", "TZS" : "en_TZ", "AMD" : "hy_AM", "USD" : "en_US", "TWD" : "en_TW", "GEL" : "ka_GE", "MVR" : "en_MV", "SLL" : "en_SL", "LAK" : "lo_LA", "BND" : "ms_BN", "GYD" : "en_GY", "KGS" : "ru_KG", "FJD" : "en_FJ", "AOA" : "pt_AO", "GNF" : "ff_GN", "CUP" : "es_CU", "MZN" : "pt_MZ", "OMR" : "ar_OM", "INR" : "en_IN", "BDT" : "en_BD", "JOD" : "ar_JO", "THB" : "en_TH", "CNY" : "en_CN", "COP" : "es_CO", "MKD" : "mk_MK", "ZAR" : "en_ZA", "AUD" : "en_AU", "PKR" : "en_PK", "EUR" : "en_FR", "LBP" : "ar_LB", "TJS" : "tg_TJ", "SHP" : "en_SH", "IQD" : "ar_IQ", "VND" : "vi_VN", "CAD" : "en_CA", "SBD" : "en_SB", "DKK" : "en_DK", "DJF" : "so_DJ", "WST" : "en_WS", "KES" : "en_KE", "PLN" : "en_PL", "TND" : "ar_TN", "RUB" : "en_RU", "BRL" : "en_BR", "KZT" : "ru_KZ", "LRD" : "en_LR", "CDF" : "fr_CD", "PEN" : "es_PE", "CVE" : "kea_CV", "JPY" : "en_JP", "PYG" : "es_PY", "SRD" : "es_SR", "TMT" : "tk_TM", "KYD" : "en_KY", "HKD" : "en_HK", "MNT" : "mn_MN", "MXN" : "es_MX", "GHS" : "en_GH", "UZS" : "uz_UZ", "PAB" : "es_PA", "KHR" : "km_KH", "ILS" : "en_IL", "IDR" : "en_ID", "XCD" : "en_AG", "DOP" : "es_DO", "ERN" : "en_ER", "XOF" : "ee_TG", "VUV" : "en_VU", "MWK" : "en_MW", "IRR" : "fa_IR", "SDG" : "en_SD", "KWD" : "ar_KW", "BHD" : "ar_BH", "FKP" : "en_FK", "MDL" : "ro_MD", "MUR" : "en_MU", "ARS" : "en_AR", "GBP" : "en_GB", "BMD" : "en_BM", "CZK" : "en_CZ", "MMK" : "my_MM", "STD" : "pt_ST", "TTD" : "en_TT", "ZMW" : "en_ZM", "NZD" : "en_NZ", "NAD" : "en_NA", "BSD" : "en_BS", "UYU" : "es_UY", "BAM" : "en_BA", "HRK" : "en_HR", "BGN" : "en_BG", "GIP" : "en_GI", "EGP" : "ar_EG", "CRC" : "es_CR", "LYD" : "ar_LY", "HNL" : "es_HN", "MOP" : "en_MO", "NOK" : "en_NO", "KRW" : "en_KR", "BBD" : "en_BB", "NIO" : "es_NI", "DZD" : "ar_DZ", "JMD" : "en_JM", "BOB" : "qu_BO", "GMD" : "en_GM", "HUF" : "en_HU", "GTQ" : "es_GT", "KMF" : "ar_KM", "QAR" : "ar_QA", "AED" : "ar_AE", "SZL" : "en_SZ", "SAR" : "en_SA", "UAH" : "uk_UA", "ISK" : "en_IS", "AZN" : "az_AZ", "BZD" : "en_BZ", "AFN" : "ps_AF", "PHP" : "en_PH", "PGK" : "en_PG", "ETB" : "so_ET", "BIF" : "en_BI", "VEF" : "es_VE", "AWG" : "nl_AW", "SOS" : "ar_SO", "TOP" : "en_TO", "KPW" : "ko_KP", "MGA" : "en_MG", "SCR" : "en_SC", "SYP" : "ar_SY", "TRY" : "en_TR", "RSD" : "sr_RS", "BYN" : "ru_BY", "NPR" : "ne_NP", "UGX" : "en_UG", "CHF" : "en_CH", "CLP" : "es_CL", "YER" : "ar_YE", "XPF" : "fr_WF", "LKR" : "si_LK"]

