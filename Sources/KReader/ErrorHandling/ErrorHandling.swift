//
//  File.swift
//  
//
//  Created by vince on 13/12/2023.
//
import SwiftUI

struct ErrorAlert: Identifiable {
    var id = UUID()
    var title:String?
    var message: String
    var dismissAction: (() -> Void)?
}


@Observable
public class ErrorHandling {
    
    var currentAlert: ErrorAlert?
    
    public init(){}
    
    public func handle(title:String? = nil, error: Error, dismissAction: (() -> Void)? = nil) {
        currentAlert = ErrorAlert(title:title, message: error.localizedDescription) {
            dismissAction?()
        }
    }
}


struct HandleErrorViewModifier: ViewModifier {

    private var errorHandling:ErrorHandling = ErrorHandling()
    
    public func body(content: Content) -> some View {
        content
            .environment(errorHandling)
            .background(
                EmptyView()
                .alert(item: Bindable(errorHandling).currentAlert) { currentAlert in
                    Alert(
                        title: Text(currentAlert.title ?? "Erreur"),
                        message: Text(currentAlert.message),
                        dismissButton: .default(Text("Ok")) {
                            currentAlert.dismissAction?()
                        }
                    )
                }
            )
    }
}

public extension View {
     func withErrorHandling() -> some View {
        modifier(HandleErrorViewModifier())
    }
}

