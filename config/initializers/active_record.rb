class ActiveRecord::Base
has_many :jobs, :class_name => "Delayed::Job", :as => :owner
  def send_at(time, method, *args)
    Delayed::Job.transaction do
      job = Delayed::Job.enqueue(Delayed::PerformableMethod.new(self, 
             method.to_sym, args), 10, time)
      job.owner = self
      job.save
    end
  end

  def find_all_by_owner_type
  end

  def self.jobs
    # to address the STI scenario we use base_class.name. 
    # downside: you have to write extra code to filter STI class specific instance.
    Delayed::Job.find_all_by_owner_type(self.base_class.name)
  end
end