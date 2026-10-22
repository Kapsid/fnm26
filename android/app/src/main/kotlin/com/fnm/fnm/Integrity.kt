package com.fnm.fnm

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.util.Base64
import java.security.KeyFactory
import java.security.MessageDigest
import java.security.Signature
import java.security.spec.X509EncodedKeySpec

/** Signing-certificate and Play purchase-signature checks for EntitlementService. */
object Integrity {
    /** SHA-256 (upper-case hex) of every certificate that signed this APK. */
    fun signingCertificates(context: Context): List<String> {
        val pm = context.packageManager
        val name = context.packageName
        val signatures = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            val info = pm.getPackageInfo(name, PackageManager.GET_SIGNING_CERTIFICATES)
            val signing = info.signingInfo ?: return emptyList()
            if (signing.hasMultipleSigners()) {
                signing.apkContentsSigners
            } else {
                signing.signingCertificateHistory
            }
        } else {
            @Suppress("DEPRECATION")
            pm.getPackageInfo(name, PackageManager.GET_SIGNATURES).signatures
        } ?: return emptyList()
        return signatures.map { sha256Hex(it.toByteArray()) }
    }

    /**
     * Whether [signature] is Play's SHA1withRSA over [originalJson] under the
     * Base64 X.509 [publicKey]. A key that will not parse throws (Dart reads
     * that as "could not check"); a signature that will not decode or verify
     * is simply false.
     */
    fun verifyPurchase(originalJson: String, signature: String, publicKey: String): Boolean {
        val key = KeyFactory.getInstance("RSA").generatePublic(
            X509EncodedKeySpec(Base64.decode(publicKey, Base64.DEFAULT)),
        )
        val signatureBytes = try {
            Base64.decode(signature, Base64.DEFAULT)
        } catch (e: IllegalArgumentException) {
            return false
        }
        return try {
            Signature.getInstance("SHA1withRSA").run {
                initVerify(key)
                update(originalJson.toByteArray(Charsets.UTF_8))
                verify(signatureBytes)
            }
        } catch (e: java.security.SignatureException) {
            false
        }
    }

    private fun sha256Hex(bytes: ByteArray): String =
        MessageDigest.getInstance("SHA-256").digest(bytes)
            .joinToString("") { "%02X".format(it) }
}
