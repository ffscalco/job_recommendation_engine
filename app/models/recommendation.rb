class Recommendation
  attr_accessor :jobseeker_id, :jobseeker_name, :job_id, :job_title,
    :matching_skill_count, :matching_skill_percent

  def initialize(jobseeker_id:, jobseeker_name:, job_id:, job_title:,
    matching_skill_count:, matching_skill_percent:)
    @jobseeker_id = jobseeker_id
    @jobseeker_name = jobseeker_name
    @job_id = job_id
    @job_title = job_title
    @matching_skill_count = matching_skill_count
    @matching_skill_percent = matching_skill_percent
  end
end
