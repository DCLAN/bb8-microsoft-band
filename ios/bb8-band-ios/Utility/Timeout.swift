import Foundation

/// Timeout wraps a callback deferral that may be cancelled.
///
/// Modified From: https://gist.github.com/macu/9a825b53d8b968bd36b8#file-timeout-swift
/// Source: https://gist.github.com/DCLAN/ef3831da557883ddaf7f57ea4a3619a6
///
class Timeout: NSObject
{
  enum TimeoutError: ErrorType {
    case InvalidDelay
    case InvalidCallback
  }

  
  private var timer: NSTimer?
  private var callback: (Void -> Void)?
  private var delaySeconds: NSTimeInterval?
  
  init(_ delaySeconds: Double)
  {
    super.init()
    self.delaySeconds = delaySeconds
  }
  
  init(_ delaySeconds: Double, _ callback: Void -> Void) {
    self.delaySeconds = delaySeconds
    self.callback = callback
  }
  
  func start() throws {
    if self.callback == nil {
      throw TimeoutError.InvalidCallback
    }
    
    start(self.callback!)
  }
  
  func start(callback: Void -> Void) {
    if self.timer != nil {
      return
    }
    
    self.callback = callback
    
    dispatch_async(dispatch_get_main_queue(), {
      self.timer = NSTimer.scheduledTimerWithTimeInterval(self.delaySeconds!, target: self, selector: #selector(self.invoke), userInfo: nil, repeats: false)
    })
  }
  
  @objc private func invoke() {
    self.callback?()
    self.callback = nil
    self.timer = nil
  }
  
  func cancel() {
    self.timer?.invalidate()
    self.timer = nil
  }
}