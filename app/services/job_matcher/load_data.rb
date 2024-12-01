require "csv"

module JobMatcher
  class LoadData
    class << self
      def call(jobseekers_file, jobs_file)
        @jobseekers_file = jobseekers_file
        @jobs_file = jobs_file

        return load_jobseekers, load_jobs
      end

      private

      attr_accessor :jobseekers_file, :jobs_file

      def load_jobseekers
        CSV.read(jobseekers_file, headers: true).map do |row|
          Jobseeker.new(
            id: row['id'].to_i,
            name: row['name'],
            skills: normalize_skills(row['skills'])
          )
        end
      end

      def load_jobs
        CSV.read(jobs_file, headers: true).map do |row|
          Job.new(
            id: row['id'].to_i,
            title: row['title'],
            required_skills: normalize_skills(row['required_skills'])
          )
        end
      end

      def normalize_skills(skills)
        skills.split(',').map(&:strip)
      end
    end
  end
end
