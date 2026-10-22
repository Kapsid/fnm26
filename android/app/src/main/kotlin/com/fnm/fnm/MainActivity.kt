package com.fnm.fnm

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // The two integrity questions Dart cannot answer itself; see
        // lib/domain/services/entitlement/integrity.dart. Any failure goes
        // back as an error, which Dart reads as "could not ask" and passes.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "fnm/integrity")
            .setMethodCallHandler { call, result ->
                try {
                    when (call.method) {
                        "signingCertificates" ->
                            result.success(Integrity.signingCertificates(this))
                        "verifyPurchase" -> result.success(
                            Integrity.verifyPurchase(
                                call.argument<String>("originalJson") ?: "",
                                call.argument<String>("signature") ?: "",
                                call.argument<String>("publicKey") ?: "",
                            ),
                        )
                        else -> result.notImplemented()
                    }
                } catch (e: Exception) {
                    result.error("integrity", e.message, null)
                }
            }
    }
}
