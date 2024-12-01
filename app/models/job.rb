class Job
  attr_accessor :id, :title, :required_skills

  def initialize(id:, title:, required_skills:)
    @id = id
    @title = title
    @required_skills = required_skills
  end
end
