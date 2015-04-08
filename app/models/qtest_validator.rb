# validates presence of answers to test
class QtestValidator < ActiveModel::Validator
  include QtestHelper

  def validate(record)
    return if record.question_finished <= 0
    question_no = [record.question_finished, record.question_count].min
    QuestionAnswer.where(qtest_id: record.id,
                         question_seq: 1..question_no).each do |ans|
      next unless ans.answer.nil?
      record.errors.add("Answer #{ans.question_seq}", "can't be blank.")
    end
  end
end
