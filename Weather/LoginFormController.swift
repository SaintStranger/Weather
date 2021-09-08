//
//  LoginFormController.swift
//  Weather
//
//  Created by Антон Чечевичкин on 27.09.2020.
//  Copyright © 2020 Антон Чечевичкин. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginFormController: UIViewController {
    
    private var handle: AuthStateDidChangeListenerHandle!
    
    @IBOutlet weak var loginInput: UITextField!
    
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var UIScrollView: UIScrollView!
    
    @IBOutlet weak var AppTitle: UILabel!
    
    @IBOutlet weak var loginLabel: UILabel!

    @IBOutlet weak var pasLabel: UILabel!
    
    @IBOutlet weak var logIn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        animatedTitleAppearing()
//        animatedLabelsAppearing()
//        animatedFieldsAppearing()
//        animateAuthButton()
        
        logAnimation()
        
//        var email = loginInput.text
//        var password = passwordInput.text
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        self.view.addGestureRecognizer(recognizer)
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        UIScrollView?.addGestureRecognizer(hideKeyboardGesture)
        
    }
    
    @IBAction func logIn(_ sender: Any) {
        
        guard loginInput.text != nil, passwordInput.text != nil else {
            let alert = UIAlertController(title: "Ошибка", message: "Логин или пароль введены неверно", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ок", style: .cancel)
            alert.addAction(action)
            present(alert, animated: true)
            return
        }
    
        Auth.auth().signIn(withEmail: loginInput.text!, password: passwordInput.text!) { [weak self] user, error in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ок", style: .cancel)
                alert.addAction(action)
                self?.present(alert, animated: true)
                print("\(self?.loginInput.text ?? "0")", "\(self?.passwordInput.text ?? "0")")
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        let alert = UIAlertController(title: "Register", message: "Регистрация", preferredStyle: .alert)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Введите Ваш Email"
        }
        
        alert.addTextField { textPassword in
            textPassword.placeholder = "Введите пароль"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            guard let emailField = alert.textFields?[0],
                  let passField = alert.textFields?[1],
                  let email = emailField.text,
                  let password = passField.text else { return }
            
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
                if let error = error {
                    let errorAlert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ок", style: .cancel)
                    errorAlert.addAction(okAction)
                    self?.present(errorAlert, animated: true)
                    print(error.localizedDescription as Any)
                } else {
                    Auth.auth().signIn(withEmail: email, password: password)
                    print("Пользователь успешно зарегестрирован")
                }
            }
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    @objc func keyboardWasShown(notification: Notification) {
        
        
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        
        
        self.UIScrollView?.contentInset = contentInsets
        UIScrollView?.contentInset = contentInsets
    }
    
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        
        
        let contentInsets = UIEdgeInsets.zero
        UIScrollView?.contentInset = contentInsets
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.handle = Auth.auth().addStateDidChangeListener{ auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "logInSegue", sender: nil)
                self.loginInput.text = nil
                self.passwordInput.text = nil
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(handle)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func hideKeyboard() {
        self.UIScrollView?.endEditing(true)
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        return true
        

    }
    
    var interactiveAnimator: UIViewPropertyAnimator!
    
    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            interactiveAnimator?.startAnimation()
            interactiveAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.5, animations: {
                self.logIn.transform = CGAffineTransform(translationX: 0, y: 150)
            })
            interactiveAnimator.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: self.view)
            interactiveAnimator.fractionComplete = translation.y / 100
        case .ended:
            interactiveAnimator.stopAnimation(true)
            interactiveAnimator.addAnimations {
                self.logIn.transform = .identity
            }
            interactiveAnimator.startAnimation()
        default:
            return
        }
    }
    
    
    func logAnimation() {
        
        let offset = abs(self.loginLabel.frame.midY - self.pasLabel.frame.midY)
        
        self.loginLabel.transform = CGAffineTransform(translationX: 0, y: offset)
        self.pasLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
        
        UIView.animateKeyframes(withDuration: 1, delay: 1, options: .calculationModePaced) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.loginLabel.transform = CGAffineTransform(translationX: 150, y: 50)
                self.pasLabel.transform = CGAffineTransform(translationX: -150, y: -50)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.loginLabel.transform = .identity
                self.pasLabel.transform = .identity
            }
        } completion: { (_) in
            
        }

        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1
        
        
        let scaleAnimation = CASpringAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1
        scaleAnimation.stiffness = 150
        scaleAnimation.mass = 2
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1
        animationGroup.beginTime = CACurrentMediaTime() + 1
        animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animationGroup.fillMode = CAMediaTimingFillMode.backwards
        animationGroup.animations = [fadeInAnimation, scaleAnimation]
        
        self.loginLabel.layer.add(animationGroup, forKey: nil)
        self.pasLabel.layer.add(animationGroup, forKey: nil)
        
        
        self.AppTitle.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height / 2)
        
        let animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.5) {
            self.AppTitle.transform = .identity
        }
        
        animator.startAnimation(afterDelay: 1)
    }
    
    

}
