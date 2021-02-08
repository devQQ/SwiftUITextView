//
//  TextView.swift
//  
//
//  Created by Q Trang on 7/21/20.
//

import SwiftUI
import SwiftUIStyleKit
import SwiftUIToolbox

public struct TextView: UIViewRepresentable {
    public class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView
        
        public init(_ parent: TextView) {
            self.parent = parent
        }
        
        public func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
        
        public func scrollViewDidScroll(_ scrollView: UIScrollView) {
            guard !parent.isScrollable else {
                return
            }
            
            scrollView.setContentOffset(.zero, animated: false)
        }
    }
    
    @Binding public var text: String
    @Binding public var textURLs: [TextURL]
    @Binding public var isSelectable: Bool
    @Binding public var isEditable: Bool
    @Binding public var isUserInteractionEnabled: Bool
    @Binding public var isScrollable: Bool
    @Binding public var dataDetectorTypes: UIDataDetectorTypes
    @Binding public var font: UIFont
    @Binding public var textColor: UIColor
    @Binding public var tintColor: UIColor
    @Binding public var textAlignment: NSTextAlignment
    
    public init(text: Binding<String>, textURLs: Binding<[TextURL]> = .constant([]),  isSelectable: Binding<Bool> = .constant(true), isEditable: Binding<Bool> = .constant(true), isUserInteractionEnabled: Binding<Bool> = .constant(true), isScrollable: Binding<Bool> = .constant(true), dataDetectorTypes: Binding<UIDataDetectorTypes> = .constant(.all), font: Binding<UIFont> = .constant(UIFont.systemFont(ofSize: FontSize.body.value)), textColor: Binding<UIColor> = .constant(UIColor.systemBlack), tintColor: Binding<UIColor> = .constant(UIColor.systemBlue), textAlignment: Binding<NSTextAlignment> = .constant(.natural)) {
        self._text = text
        self._textURLs = textURLs
        self._isSelectable = isSelectable
        self._isEditable = isEditable
        self._isUserInteractionEnabled = isUserInteractionEnabled
        self._isScrollable = isScrollable
        self._dataDetectorTypes = dataDetectorTypes
        self._font = font
        self._textColor = textColor
        self._tintColor = tintColor
        self._textAlignment = textAlignment
    }
    
    public static func heightForTextView(width: CGFloat, font: UIFont, text: String) -> CGFloat {
        text.height(constraintToWidth: width, font: font)
    }
    
    public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        textView.backgroundColor = UIColor.clear
        textView.contentInset = .zero
        textView.textContainerInset = .zero
        textView.textColor = textColor
        textView.tintColor = tintColor
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
        textView.isSelectable = isSelectable
        textView.isEditable = isEditable
        textView.isUserInteractionEnabled = isUserInteractionEnabled
        textView.font = font
        textView.delegate = context.coordinator
        
        return textView
    }
    
    public func updateUIView(_ uiView: UITextView, context: Context) {
        if textURLs.count > 0 {
            uiView.attributedText = NSAttributedString.addAttributedText(text: text, textURLs: textURLs, font: font, textColor: textColor)
        } else {
            uiView.text = text
        }
        
        uiView.isSelectable = isSelectable
        uiView.isEditable = isEditable
        uiView.isUserInteractionEnabled = isUserInteractionEnabled
        uiView.dataDetectorTypes = dataDetectorTypes
        uiView.textAlignment = textAlignment
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

