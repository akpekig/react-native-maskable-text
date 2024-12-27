package com.maskabletext

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.views.text.ReactTextAnchorViewManager
import com.facebook.react.views.text.ReactTextViewManager

class MaskableTextViewManager(reactContext: ReactApplicationContext) :
  ReactTextAnchorViewManager<MaskableTextView, MaskableTextShadowNode>() {
  private val mManager = ReactTextViewManager()

  override fun getName() = "MaskableTextView"

  override fun getShadowNodeClass(): Class<out MaskableTextShadowNode> {
    return MaskableTextShadowNode::class.java
  }

  override fun createViewInstance(context: ThemedReactContext): MaskableTextView {
    return MaskableTextView(context)
  }

  override fun updateExtraData(view: MaskableTextView, extraData: Any?) {
    mManager.updateExtraData(view, extraData)
  }
}
