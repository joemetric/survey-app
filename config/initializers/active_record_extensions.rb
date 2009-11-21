# Following method - To skip the ActiveRecord callback
# Added by SUHAS - Jan 12, 2009

class ActiveRecord::Base
  def self.skip_callback(callback, &block)
    method = instance_method(callback)
    remove_method(callback) if respond_to?(callback)
    define_method(callback){ true }
    yield
    remove_method(callback)
    define_method(callback, method)
  end
end
