package com.maskabletext.utils

import android.graphics.LinearGradient
import android.graphics.Shader
import android.text.Layout
import android.text.TextPaint
import android.text.style.CharacterStyle
import android.text.style.UpdateAppearance

class LinearGradientSpan(layout: Layout, colors: IntArray, positions: FloatArray) : CharacterStyle(), UpdateAppearance {
  private val gradientColors: IntArray = colors
  private val gradientPositions: FloatArray = positions
  private val gradientLayout: Layout = layout

  override fun updateDrawState(tp: TextPaint?) {
    tp ?: return
    val shader = LinearGradient(
      0f,
      0f,
      gradientLayout.width.toFloat(),
      gradientLayout.height.toFloat(),
      gradientColors,
      gradientPositions,
      Shader.TileMode.REPEAT
    )

    tp.shader = shader
  }
}
