class AddQuestionAnswerRefToQtest < ActiveRecord::Migration
  def change
    add_reference :qtests, :question_answers, index: true
    add_reference :qtests, :trigger_scores, index: true
    add_reference :versions, :version_innovations, index: true
    add_reference :innovations, :version_innovations, index: true
    add_reference :versions, :version_triggers, index: true
    add_reference :triggers, :version_triggers, index: true
    add_reference :versions, :version_questions, index: true
    add_reference :questions, :version_questions, index: true
    add_reference :versions, :weights, index: true
  end
end
