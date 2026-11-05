package com.fnm.fnm

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    /** `fnm/incoming_file`: see lib/features/world_pack/incoming_file.dart. */
    private var incoming: MethodChannel? = null

    /** Whether Dart has asked `initial()`: from then on files go to `opened`. */
    private var incomingReady = false

    /** The file that started the app, until Dart asks for it. */
    private var pendingIncoming: String? = null

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
        // A `.fnmdb` opened from another app. `initial` hands over the file
        // that started the app, once; a hot restart asks again and gets null.
        incoming = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "fnm/incoming_file")
            .also { channel ->
                channel.setMethodCallHandler { call, result ->
                    when (call.method) {
                        "initial" -> {
                            incomingReady = true
                            result.success(pendingIncoming)
                            pendingIncoming = null
                        }
                        else -> result.notImplemented()
                    }
                }
            }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // A recreated activity is handed its old intent again.
        if (savedInstanceState == null) receive(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        receive(intent)
    }

    /** Copies the file [intent] opens, off the main thread, then hands it over. */
    private fun receive(intent: Intent?) {
        val uri = IncomingFile.uriOf(intent) ?: return
        val context = applicationContext
        Thread {
            val path = IncomingFile.copy(context, uri)
            Handler(Looper.getMainLooper()).post { deliver(path) }
        }.start()
    }

    private fun deliver(path: String) {
        val channel = incoming
        if (incomingReady && channel != null) {
            channel.invokeMethod("opened", path)
        } else {
            pendingIncoming = path
        }
    }
}
