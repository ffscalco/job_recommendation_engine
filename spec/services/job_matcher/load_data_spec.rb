require "csv"

RSpec.describe JobMatcher::LoadData do
  let(:jobseekers_file) { "spec/fixtures/jobseekers.csv" }
  let(:jobs_file) { "spec/fixtures/jobs.csv" }

  describe ".call" do
    it "loads jobseekers and jobs correctly" do
      jobseekers, jobs = described_class.call(jobseekers_file, jobs_file)

      expect(jobseekers.size).to eq(2)
      expect(jobseekers.first.id).to eq(1)
      expect(jobseekers.first.name).to eq("Alice")
      expect(jobseekers.first.skills).to eq(["Ruby", "JavaScript"])

      expect(jobs.size).to eq(3)
      expect(jobs.first.id).to eq(1)
      expect(jobs.first.title).to eq("Ruby Developer")
      expect(jobs.first.required_skills).to eq(["Ruby", "JavaScript"])
    end
  end

  describe ".normalize_skills" do
    it "splits and trims skill strings correctly" do
      skills = " Ruby , JavaScript , Python "
      normalized_skills = described_class.send(:normalize_skills, skills)
      expect(normalized_skills).to eq(["Ruby", "JavaScript", "Python"])
    end
  end
end
