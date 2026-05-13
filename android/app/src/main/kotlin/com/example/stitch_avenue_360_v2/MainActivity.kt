package com.example.stitch_avenue_360_v2

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Locale
import android.speech.tts.TextToSpeech

class MainActivity : FlutterActivity(), TextToSpeech.OnInitListener {
    private val channelName = "cove/text_to_speech"
    private var textToSpeech: TextToSpeech? = null
    private var isTextToSpeechReady = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        textToSpeech = TextToSpeech(this, this)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "speak" -> {
                    val text = call.argument<String>("text")?.trim().orEmpty()
                    val languageCode = call.argument<String>("languageCode")?.trim().orEmpty()
                    if (!isTextToSpeechReady || text.isEmpty()) {
                        result.success(false)
                        return@setMethodCallHandler
                    }

                    if (languageCode.isNotEmpty()) {
                        val locale = Locale.forLanguageTag(languageCode)
                        val availability = textToSpeech?.setLanguage(locale)
                        if (
                            availability == TextToSpeech.LANG_MISSING_DATA ||
                            availability == TextToSpeech.LANG_NOT_SUPPORTED
                        ) {
                            result.success(false)
                            return@setMethodCallHandler
                        }
                    }

                    textToSpeech?.speak(
                        text,
                        TextToSpeech.QUEUE_FLUSH,
                        null,
                        "guard_notice_${System.currentTimeMillis()}"
                    )
                    result.success(true)
                }
                "stop" -> {
                    textToSpeech?.stop()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onInit(status: Int) {
        isTextToSpeechReady = status == TextToSpeech.SUCCESS
        if (isTextToSpeechReady) {
            textToSpeech?.language = Locale.getDefault()
            textToSpeech?.setSpeechRate(0.92f)
        }
    }

    override fun onDestroy() {
        textToSpeech?.stop()
        textToSpeech?.shutdown()
        textToSpeech = null
        super.onDestroy()
    }
}
