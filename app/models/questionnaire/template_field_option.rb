class Questionnaire::TemplateFieldOption < Gw::Database
  include System::Model::Base
  include System::Model::Base::Content

  after_validation :validate_rel_cols

  def validate_rel_cols
    return true if @skip_validation

    required = Proc.new {|a| a.to_a.each {|n| errors.add_on_blank(n) if send(n).to_s == ''}}
    required.call [:state, :title]

    return true
  end
end
