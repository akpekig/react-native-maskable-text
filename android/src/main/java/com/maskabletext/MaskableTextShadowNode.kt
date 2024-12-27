package com.maskabletext

import android.text.Spannable
import android.text.Spanned
import android.view.View
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.UiThreadUtil
import com.facebook.react.uimanager.NativeViewHierarchyManager
import com.facebook.react.uimanager.Spacing
import com.facebook.react.uimanager.UIManagerModule
import com.facebook.react.uimanager.UIViewOperationQueue
import com.facebook.react.views.text.ReactTextShadowNode
import com.facebook.react.views.text.ReactTextUpdate
import com.facebook.react.views.text.ReactTextView
import com.maskabletext.utils.LinearGradientSpan


abstract class MaskableTextShadowNode(
    private val reactApplicationContext: ReactApplicationContext
): ReactTextShadowNode() {
    protected abstract val mColors: IntArray
    protected abstract val mPositions: FloatArray

    override fun onCollectExtraUpdates(uiViewOperationQueue: UIViewOperationQueue) {
        super.onCollectExtraUpdates(uiViewOperationQueue)
        val superclass = this.javaClass.superclass
        val mPreparedSpannableText = superclass
            .javaClass
            .getDeclaredField("mPreparedSpannableText")
            .run {
                isAccessible = true
                get(superclass)
            } as Spannable? ?: return
        val view = resolveView(reactTag) as ReactTextView ?: return
        val layout = view.layout

        mPreparedSpannableText.setSpan(
            LinearGradientSpan(layout, mColors, mPositions),
            0,
            mPreparedSpannableText.length,
            Spanned.SPAN_INCLUSIVE_INCLUSIVE
        )

        val textUpdate = ReactTextUpdate(
            mPreparedSpannableText,
            -1,
            this.mContainsImages,
            getPadding(Spacing.START),
            getPadding(Spacing.TOP),
            getPadding(Spacing.END),
            getPadding(Spacing.BOTTOM),
            this.mTextAlign,
            this.mTextBreakStrategy,
            this.mJustificationMode
        )

        uiViewOperationQueue.enqueueUpdateExtraData(reactTag, textUpdate)
    }

    private fun resolveView(tag: Int): View? {
        UiThreadUtil.assertOnUiThread()
        val uiManager = reactApplicationContext.getNativeModule(UIManagerModule::class.java)
            ?: return null
        val mOperationsQueue = uiManager
            .javaClass
            .getDeclaredField("mOperationsQueue")
            .run {
                isAccessible = true
                get(uiManager)
            } as UIViewOperationQueue ?: return null
        val nativeViewHierarchyManager = mOperationsQueue
            .javaClass
            .getDeclaredField("mNativeViewHierarchyManager")
            .run {
                isAccessible = true
                get(mOperationsQueue)
            } as NativeViewHierarchyManager ?: return null

        return nativeViewHierarchyManager.resolveView(tag)
    }
}
