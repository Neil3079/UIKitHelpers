//
//  CombineHelpers.swift
//  
//
//  Created by Neil Horton on 13/07/2020.
//

import UIKit
import Combine

public protocol TargetActionPublisher {}
extension UIControl: TargetActionPublisher {}
public extension TargetActionPublisher where Self: UIControl {

    /// Creates a publisher for a given UIControl event
    /// - Parameter events: The event which will trigger the publisher.
    func publisher(forEvent events: UIControl.Event) -> UIControlPublisher<Self> {
        return UIControlPublisher(control: self, events: events)
    }
}

public final class UIControlPublisher<Control: UIControl>: Publisher {

    public typealias Output = Control
    public typealias Failure = Never

    let control: Control
    let controlEvents: UIControl.Event

    init(control: Control, events: UIControl.Event) {
        self.control = control
        self.controlEvents = events
    }

    public func receive<S>(subscriber: S) where S : Subscriber, S.Failure == UIControlPublisher.Failure, S.Input == UIControlPublisher.Output {
        let subscription = UIControlSubscription(subscriber: subscriber, control: control, event: controlEvents)
        subscriber.receive(subscription: subscription)
    }
}

/// A custom subscription to capture UIControl target events.
public final class UIControlSubscription<SubscriberType: Subscriber, Control: UIControl>: Subscription where SubscriberType.Input == Control {
    private var subscriber: SubscriberType?
    private let control: Control

    init(subscriber: SubscriberType, control: Control, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        control.addTarget(self, action: #selector(eventHandler), for: event)
    }

    public func request(_ demand: Subscribers.Demand) {
        // We do nothing here as we only want to send events when they occur.
        // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
    }

    public func cancel() {
        subscriber = nil
    }

    @objc private func eventHandler() {
        _ = subscriber?.receive(control)
    }
}

struct GesturePublisher<T: UIGestureRecognizer>: Publisher {
    typealias Output = T
    typealias Failure = Never
    private let view: UIView
    init(view: UIView) {
        self.view = view
    }
    func receive<S>(subscriber: S) where S : Subscriber,
    GesturePublisher.Failure == S.Failure, GesturePublisher.Output
    == S.Input {
        let subscription = GestureSubscription<S, T>(
            subscriber: subscriber,
            view: view,
            gesture: T.init()
        )
        subscriber.receive(subscription: subscription)
    }
}

class GestureSubscription<S: Subscriber, T: UIGestureRecognizer>: Subscription where S.Input == T, S.Failure == Never {
    private var subscriber: S?
    private var gesture: T
    private var view: UIView
    init(subscriber: S, view: UIView, gesture: T) {
        self.subscriber = subscriber
        self.view = view
        self.gesture = gesture
        configureGesture()
    }
    private func configureGesture() {
        gesture.addTarget(self, action: #selector(handler))
        view.addGestureRecognizer(gesture)
    }
    func request(_ demand: Subscribers.Demand) { }
    func cancel() {
        subscriber = nil
    }
    @objc
    private func handler() {
        _ = subscriber?.receive(gesture)
    }
}

extension UIView {

    func onTap() -> GesturePublisher<UITapGestureRecognizer> {
        return GesturePublisher(view: self)
    }

    func onSwipe() -> GesturePublisher<UISwipeGestureRecognizer> {
        return GesturePublisher(view: self)
    }

    func onLongPress() -> GesturePublisher<UILongPressGestureRecognizer> {
        return GesturePublisher(view: self)
    }

    func onPan() -> GesturePublisher<UIPanGestureRecognizer> {
        return GesturePublisher(view: self)
    }

    func onPinch() -> GesturePublisher<UIPinchGestureRecognizer> {
        return GesturePublisher(view: self)
    }

    func onScreenEdgePan() -> GesturePublisher<UIScreenEdgePanGestureRecognizer> {
        return GesturePublisher(view: self)
    }
}
