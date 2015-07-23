# Responsible for scheduling recurring delayed jobs for a micropost
#
#
class ScheduleMicropostCheckIns
  include Interactor

  # UNTESTED BY RSPEC
  # Schedule multiple delayed job based on number of days and task
  def schedule_check_in_deadlines
    number_of = 1
    self.days_to_complete.downto(1) do |n|  # Value from column
      job = self.delay(run_at: number_of.days.from_now).check_in # RUN THIS JOB AFTER SCHEDULED TIME
      update_column(:delayed_job_id, job.id)
      number_of += 1
    end
  end
  
end


