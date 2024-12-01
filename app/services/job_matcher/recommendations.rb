module JobMatcher
  class Recommendations
    def self.call(batch_size: 100)
      jobseekers, jobs = JobMatcher::LoadData.call(
        "./app/files/jobseekers.csv",
        "./app/files/jobs.csv"
      )
      recommendations = []

      jobseekers.each_slice(batch_size) do |jobseeker_batch|
        jobseeker_batch.each do |jobseeker|
          jobseeker_skills = jobseeker.skills
          jobs.each_slice(batch_size) do |job_batch|
            job_batch.each do |job|
              matching_skills = jobseeker_skills & job.required_skills

              recommendations << Recommendation.new(
                jobseeker_id: jobseeker.id,
                jobseeker_name: jobseeker.name,
                job_id: job.id,
                job_title: job.title,
                matching_skill_count: matching_skills.size,
                matching_skill_percent: (matching_skills.size.to_f / job.required_skills.size * 100).round
                ) if matching_skills.size > 0
            end
          end
        end
      end

      recommendations.sort_by! do |rec|
        [rec.jobseeker_id, -rec.matching_skill_percent, rec.job_id]
      end
    end
  end
end
