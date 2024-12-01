class Jobseeker
  attr_accessor :id, :name, :skills

  def initialize(id:, name:, skills:)
    @id = id
    @name = name
    @skills = skills
  end
end
