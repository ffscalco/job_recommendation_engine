module Export
  class RecommendationsCsv
    FILE_PATH = "./app/files/recommendations.csv".freeze

    def self.call
      recommendations = JobMatcher::Recommendations.call
      CSV.open(FILE_PATH, "wb") do |csv|
        csv << %w[jobseeker_id jobseeker_name job_id job_title matching_skill_count matching_skill_percent]

        recommendations.each do |rec|
          csv << [
            rec.jobseeker_id,
            rec.jobseeker_name,
            rec.job_id,
            rec.job_title,
            rec.matching_skill_count,
            rec.matching_skill_percent
          ]
        end
      end

      puts "Recommendations exported to #{FILE_PATH}"
    end

    def self.print_csv
      File.foreach(FILE_PATH, headers: true) do |line|
        puts line.strip
      end
    end
  end
end
