//
//  KeyboardAdjustingScrollView.swift
//  
//
//  Created by Neil Horton on 13/07/2020.
//

import UIKit
import Combine

final class KeyboardAdjustingScrollView: UIScrollView {

    private var cancellableBag: Set<AnyCancellable> = []

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardDidShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { UIEdgeInsets(top: 0, left: 0, bottom: $0.height, right: 0) }
            .sink {
                self.contentInset = $0
                self.scrollIndicatorInsets = $0
        }.store(in: &cancellableBag)

        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) }
            .sink {
                self.contentInset = $0
                self.scrollIndicatorInsets = $0
        }.store(in: &cancellableBag)
    }
}
