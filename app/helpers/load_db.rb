# initial db values
module LoadDB
  require 'csv'

  def load_db
    # set to initial version

    version = Version.new
    version.major_version = 0
    version.minor_version = 0
    version.save

    # load up questions

    CSV.foreach(Rails.root + 'app/assets/questions.csv', 'r') do |csv|
      question = Question.new(question_number: csv[0],
                              question_words: csv[1],
                              inverted: csv[2])
      old_q = Question.where(question_number: question.question_number)
      .map { |q| q.id }
      unless old_q.empty?
        old_v = VersionQuestion.where(question_id: old_q).map { |v| v.id }
        VersionQuestion.destroy(old_v)
        Question.destroy(old_q)
      end
      question.save
      VersionQuestion.new(version_id: version.id,
                          question_id: question.id).save
    end

    # load up triggers

    if Rails.env.production?
      trigger_file = 'app/assets/triggers.csv'
    else
      trigger_file = 'app/assets/triggers_test.csv'
    end

    CSV.foreach(Rails.root + trigger_file, 'r') do |csv|
      trigger = Trigger.new(trigger_name: csv[0],
                            trigger_type: csv[1],
                            order: csv[2],
                            trigger_words: csv[3])
      old_t = Trigger.where(trigger_name: trigger.trigger_name,
                            trigger_type: trigger.trigger_type,
                            order: trigger.order).map { |t| t.id }
      unless old_t.empty?
        old_v = VersionTrigger.where(trigger_id: old_t).map { |v| v.id }
        VersionTrigger.destroy(old_v)
        Trigger.destroy(old_t)
      end
      trigger.save
      VersionTrigger.new(version_id: version.id, trigger_id: trigger.id).save
    end

    # load up innovations

    if Rails.env.production?
      innovation_file = 'app/assets/innovation.csv'
    else
      innovation_file = 'app/assets/innovation_test.csv'
    end

    CSV.foreach(Rails.root + innovation_file, 'r') do |csv|
      innovation = Innovation.new(style: csv[0],
                                  innovation_type: csv[1],
                                  order: csv[2],
                                  innovation_words: csv[3])
      old_i = Innovation.where(style: innovation.style,
                               innovation_type: innovation.innovation_type,
                               order: innovation.order).map { |i| i.id }
      unless old_i.empty?
        old_v = VersionInnovation.where(innovation_id: old_i).map { |v| v.id }
        VersionInnovation.destroy(old_v)
        Innovation.destroy(old_i)
      end
      innovation.save
      VersionInnovation.new(version_id: version.id,
                            innovation_id: innovation.id).save
    end

    # load up weights

    csv = CSV.open(Rails.root + 'app/assets/weight.csv', 'r')
    9.times do
      weights = csv.shift
      double_weights = csv.shift
      trigger_name = weights.shift
      double_weights.shift
      weights.shift
      double_weights.shift
      (1..weights.count).each do |question_number|
        weight = Weight.new(version_id: version.id,
                            question_number: question_number,
                            trigger_name: trigger_name,
                            normal_weight: weights.shift,
                            double_weight: double_weights.shift)
        old_w  = Weight.where(question_number: weight.question_number,
                              trigger_name: weight.trigger_name)
        .map { |w| w.id }
        Weight.destroy(old_w)
        weight.save
      end
    end
  end
end
