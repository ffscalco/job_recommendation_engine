require "csv"

RSpec.describe Export::RecommendationsCsv do
  let(:file_path) { Export::RecommendationsCsv::FILE_PATH }
  let(:recommendations) do
    [
      Recommendation.new(
        jobseeker_id: 1,
        jobseeker_name: "Alice",
        job_id: 5,
        job_title: "Ruby Developer",
        matching_skill_count: 3,
        matching_skill_percent: 100
      ),
      Recommendation.new(
        jobseeker_id: 2,
        jobseeker_name: "Bob",
        job_id: 3,
        job_title: "Python Developer",
        matching_skill_count: 2,
        matching_skill_percent: 50
      )
    ]
  end

  before do
    allow(JobMatcher::Recommendations).to receive(:call).and_return(recommendations)

    File.delete(file_path) if File.exist?(file_path)
  end

  after do
    File.delete(file_path) if File.exist?(file_path)
  end

  describe ".call" do
    it "creates a CSV file at the specified path" do
      expect(File.exist?(file_path)).to be false
      described_class.call
      expect(File.exist?(file_path)).to be true
    end

    it "writes the correct headers to the CSV file" do
      described_class.call
      csv_content = CSV.read(file_path)
      expect(csv_content.first).to eq(%w[jobseeker_id jobseeker_name job_id job_title matching_skill_count matching_skill_percent])
    end

    it "writes the recommendations to the CSV file" do
      described_class.call
      csv_content = CSV.read(file_path)

      expect(csv_content[1..]).to eq([
        ["1", "Alice", "5", "Ruby Developer", "3", "100"],
        ["2", "Bob", "3", "Python Developer", "2", "50"]
      ])
    end

    it "prints a success message with the file path" do
      expect { described_class.call }.to output("Recommendations exported to #{file_path}\n").to_stdout
    end
  end
end
