package com.fnm.fnm

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.OpenableColumns
import java.io.File
import java.util.UUID

/**
 * Copies a `.fnmdb` opened from another app (Files, Gmail, WhatsApp, a
 * downloads folder) into the app's cache, for lib/features/world_pack/
 * incoming_file.dart to import. Dart deletes the copy once it has read it.
 *
 * The file is always read through the ContentResolver, never by path: a
 * `content://` URI from another app has no path we may open, and the
 * resolver reads `file://` too.
 */
object IncomingFile {
    /** PackCodec.maxFileBytes on the Dart side. */
    const val MAX_BYTES: Long = 8L shl 20

    /** In place of a path: over [MAX_BYTES], so never copied. */
    const val TOO_BIG = "fnm:tooBig"

    /** In place of a path: the file could not be read. */
    const val UNREADABLE = "fnm:unreadable"

    /** The opened file of [intent], or null when it opens nothing. */
    fun uriOf(intent: Intent?): Uri? {
        if (intent?.action != Intent.ACTION_VIEW) return null
        // Brought back from Recents, the activity is handed the intent that
        // first started it: that file was imported then.
        if (intent.flags and Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY != 0) return null
        val uri = intent.data ?: return null
        return if (uri.scheme == "content" || uri.scheme == "file") uri else null
    }

    /** Copies [uri] into the cache: the copy's path, [TOO_BIG] or [UNREADABLE]. */
    fun copy(context: Context, uri: Uri): String {
        val declared = declaredSize(context, uri)
        if (declared != null && declared > MAX_BYTES) return TOO_BIG
        val dir = File(context.cacheDir, "incoming").apply { mkdirs() }
        val out = File(dir, "${UUID.randomUUID()}.fnmdb")
        return try {
            val input = context.contentResolver.openInputStream(uri) ?: return UNREADABLE
            var total = 0L
            var tooBig = false
            input.use { stream ->
                out.outputStream().use { sink ->
                    val buffer = ByteArray(64 * 1024)
                    while (true) {
                        val n = stream.read(buffer)
                        if (n < 0) break
                        total += n
                        // A provider that did not say its size (or said it
                        // wrong) is still never copied past the limit.
                        if (total > MAX_BYTES) {
                            tooBig = true
                            break
                        }
                        sink.write(buffer, 0, n)
                    }
                }
            }
            if (tooBig) {
                out.delete()
                TOO_BIG
            } else {
                out.absolutePath
            }
        } catch (e: Exception) {
            out.delete()
            UNREADABLE
        }
    }

    /** The size the provider declares, when it declares one. */
    private fun declaredSize(context: Context, uri: Uri): Long? {
        if (uri.scheme != "content") return null
        return try {
            context.contentResolver
                .query(uri, arrayOf(OpenableColumns.SIZE), null, null, null)
                ?.use { cursor ->
                    val column = cursor.getColumnIndex(OpenableColumns.SIZE)
                    if (column >= 0 && cursor.moveToFirst() && !cursor.isNull(column)) {
                        cursor.getLong(column)
                    } else {
                        null
                    }
                }
        } catch (e: Exception) {
            null
        }
    }
}
