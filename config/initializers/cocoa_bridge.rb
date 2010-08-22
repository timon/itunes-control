require 'osx/cocoa'
OSX.require_framework 'ScriptingBridge'

class Object
  def bridge_block
    retries = 0
    begin
      r = yield
      r.inspect
      r
    rescue => e
      raise e if retries > 0
      retries += 1
      retry
    end
  end
end

