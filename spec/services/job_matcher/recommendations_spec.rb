RSpec.describe JobMatcher::Recommendations do
  before do
    allow(JobMatcher::LoadData).to receive(:call).and_return([
      [
        Jobseeker.new(id: 1, name: "Alice", skills: ["Ruby", "JavaScript"]),
        Jobseeker.new(id: 2, name: "Bob", skills: ["Python", "Java"])
      ],
      [
        Job.new(id: 1, title: "Ruby Developer", required_skills: ["Ruby", "JavaScript"]),
        Job.new(id: 2, title: "Python Developer", required_skills: ["Python", "Django"]),
        Job.new(id: 3, title: "Full-Stack Developer", required_skills: ["Ruby", "Python", "JavaScript"])
      ]
    ])
  end

  describe ".call" do
    it "generates recommendations with correct matching skills and percentages" do
      recommendations = described_class.call

      expect(recommendations.size).to eq(4)

      alice_rec1 = recommendations[0]
      expect(alice_rec1.jobseeker_id).to eq(1)
      expect(alice_rec1.jobseeker_name).to eq("Alice")
      expect(alice_rec1.job_id).to eq(1)
      expect(alice_rec1.job_title).to eq("Ruby Developer")
      expect(alice_rec1.matching_skill_count).to eq(2)
      expect(alice_rec1.matching_skill_percent).to eq(100)

      alice_rec2 = recommendations[1]
      expect(alice_rec2.jobseeker_id).to eq(1)
      expect(alice_rec2.job_id).to eq(3)
      expect(alice_rec2.matching_skill_percent).to eq(67)

      bob_rec1 = recommendations[2]
      expect(bob_rec1.jobseeker_id).to eq(2)
      expect(bob_rec1.job_id).to eq(2)
      expect(bob_rec1.matching_skill_percent).to eq(50)

      bob_rec2 = recommendations[3]
      expect(bob_rec2.jobseeker_id).to eq(2)
      expect(bob_rec2.job_id).to eq(3)
      expect(bob_rec2.matching_skill_percent).to eq(33)
    end

    it "sorts recommendations correctly by jobseeker_id, matching percentage, and job_id" do
      recommendations = described_class.call

      sorted = recommendations.sort_by do |rec|
        [rec.jobseeker_id, -rec.matching_skill_percent, rec.job_id]
      end

      expect(recommendations).to eq(sorted)
    end

    it "does not generate recommendations for jobseekers with no matching skills" do
      allow(JobMatcher::LoadData).to receive(:call).and_return([
        [
          Jobseeker.new(id: 1, name: "Alice", skills: ["C++"]),
        ],
        [
          Job.new(id: 1, title: "Ruby Developer", required_skills: ["Ruby", "JavaScript"]),
        ]
      ])

      recommendations = described_class.call
      expect(recommendations).to be_empty
    end
  end
end
