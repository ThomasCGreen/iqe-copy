# all kinds of helpers for qtest!
module QtestHelper
  include LoadDB
  include PDFGen

  def version_id
    unless @version_id
      load_db if Version.count == 0
      version = Version.select(:id)
      .where(major_version: major_version,
             minor_version: minor_version).last
      @version_id = version.id
    end
    @version_id
  end

  def version_question
    unless @version_question
      @version_question =
        VersionQuestion.select(:question_id).where(version_id: version_id)
    end
    @version_question
  end

  def question_ids
    unless @question_ids
      @question_ids = version_question.map { |vq| vq.question_id }
    end
    @question_ids
  end

  def question_count
    question(1) unless @questions
    @questions.count - 1
  end

  def question(question_number)
    unless @questions
      @questions = []
      @inverted = []
      Question.select(:question_words, :inverted, :question_number)
      .where(id: question_ids)
      .order(question_number: :asc).each do |i|
        @questions[i.question_number] = i.question_words
        @inverted[i.question_number] = i.inverted
      end
    end
    @questions[question_number]
  end

  def quest_seq_to_num(sequence)
    QuestionAnswer.where(qtest_id: id,
                         question_seq: sequence).pluck(:question_number)[0]
  end

  def question_text(sequence)
    question(quest_seq_to_num(sequence))
  end

  def inverted(question_number)
    question(1) unless @inverted
    @inverted[question_number]
  end

  def question_start
    if question_finished <= 0
      1
    else
      question_finished + 1
    end
  end

  def question_end
    question_end = question_finished + max_questions_per_page
    [question_end, question_count].min
  end

  def answer(question_number)
    QuestionAnswer.where(qtest_id: id,
                         question_number: question_number).pluck(:answer)[0]
  end

  def move_forward
    if question_finished < 0
      self.question_finished = 0
    elsif question_finished < question_count
      self.question_finished = question_end
    else
      self.question_finished += 1
    end
  end

  def move_backward
    if self.question_finished > question_count || self.question_finished < 1
      self.question_finished -= 1
    elsif self.question_finished < question_count
      self.question_finished -= max_questions_per_page
    else
      self.question_finished = (question_count / max_questions_per_page) *
        max_questions_per_page
    end
  end

  def max_questions_per_page
    5
  end

  def total_pages
    (question_count.to_f / max_questions_per_page.to_f).ceil
  end

  def version_trigger
    unless @version_trigger
      @version_trigger = VersionTrigger.select(:trigger_id)
      .where(version_id: version_id)
    end
    @version_trigger
  end

  def trigger_ids
    unless @trigger_ids
      @trigger_ids = version_trigger.map { |vt| vt.trigger_id }
    end
    @trigger_ids
  end

  def strength_icon_file(trigger)
    unless @strength_icons
      @strength_icons = {}
      Trigger.where(id: trigger_ids, trigger_type: 'Strength icon')
      .uniq.each do |i|
        @strength_icons[i.trigger_name] = i.trigger_words
      end
    end
    @strength_icons[trigger]
  end

  def strength_and_style(trigger)
    unless @strength_and_style
      @strength_and_style = {}
      Trigger.where(id: trigger_ids,
                    trigger_type: 'Strength and style').each do |i|
        unless @strength_and_style[i.trigger_name]
          @strength_and_style[i.trigger_name] = []
        end
        @strength_and_style[i.trigger_name] << i.trigger_words
      end
    end
    @strength_and_style[trigger]
  end

  def tie_break_factor
    [-1.0, -0.5, 0.1, 0.5, 1.0, 1.5]
  end

  def ordered_answers
    unless @ordered_answers
      @ordered_answers = []
      QuestionAnswer.where(qtest_id: id)
      .order(question_number: :asc).each do |i|
        @ordered_answers << i.answer
      end
    end
    @ordered_answers
  end

  def calculate_test

  end

  def version_innovation
    unless @version_innovation
      @version_innovation = VersionInnovation.select(:innovation_id)
      .where(version_id: version_id)
    end
    @version_innovation
  end

  def innovation_ids
    unless @innovation_ids
      @innovation_ids = version_innovation.map { |vi| vi.innovation_id }
    end
    @innovation_ids
  end

  def innovation_styles
    unless @innovation_styles
      @innovation_styles = Innovation.where(id: innovation_ids)
      .uniq.pluck(:style)
    end
    @innovation_styles
  end

  def innovation_types
    unless @innovation_types
      @innovation_types = Innovation.where(id: innovation_ids)
      .uniq.pluck(:innovation_type)
    end
    @innovation_types
  end

  def innovation_hash
    unless @innovation_hash
      @innovation_hash = {}
      innovation_styles.each do |style|
        styles = {}
        innovation_types.each do |type|
          words = Innovation.select(:innovation_words)
          .where(id: innovation_ids,
                 style: style,
                 innovation_type: type)
          .order(:order).map do |i|
            i.innovation_words
          end
          styles[type] = words
        end
        @innovation_hash[style] = styles
      end
    end
    @innovation_hash
  end

  def innovation_score
    unless @innovation_score_hash
      @innovation_score_hash = {}
      innovation_styles.each do |style|
        score = Innovation.select(:order)
        .where(id: innovation_ids,
               style: style,
               innovation_type: 'Max Score')
        .order(:order).pluck(:order)  # if more than one, take higher number
        @innovation_score_hash[style] = score[0]
      end
    end
    @innovation_score_hash
  end

  def innovation_tag
    unless @innovation_tag
      @innovation_tag = {}
      innovation_styles.each do |style|
        tag = Innovation.select(:order)
        .where(id: innovation_ids,
               style: style,
               innovation_type: 'Innovation Tag')
        .order(:order).pluck(:order)  # if more than one, take higher number
        @innovation_tag[style] = tag[0]
      end
    end
    @innovation_tag
  end

  def trigger_names
    unless @tigger_names
      @trigger_names = Trigger.where(id: trigger_ids).uniq.pluck(:trigger_name)
    end
    @trigger_names
  end

  def trigger_types
    unless @trigger_types
      @trigger_types = Trigger.where(id: trigger_ids).uniq.pluck(:trigger_type)
    end
    @trigger_types
  end

  def trigger_hash
    unless @trigger_hash
      @trigger_hash = {}
      trigger_names.each do |trigger|
        types = {}
        trigger_types.each do |type|
          words = Trigger.select(:trigger_words)
          .where(id: trigger_ids,
                 trigger_name: trigger,
                 trigger_type: type)
          .order(:order).map do |i|
            i.trigger_words
          end
          types[type] = words
        end
        @trigger_hash[trigger] = types
      end
    end
    @trigger_hash
  end

  def trigger_tag(trigger_name, strength)
    unless @trigger_tag_hash
      @trigger_tag_hash = {}
      trigger_names.each do |trigger|
        types = {}
        %w(PS_tag SS_tag LS_tag).each do |type|
          tag_value = Trigger.select(:order)
          .where(id: trigger_ids,
                 trigger_name: trigger,
                 trigger_type: type)
          .order(:order).pluck(:order) # if more than one, take higher number
          types[type] = tag_value[0]
        end
        @trigger_tag_hash[trigger] = types
      end
    end
    @trigger_tag_hash[trigger_name][strength]
  end

  def trigger_weights
    unless @trigger_weights
      @trigger_weights = {}
      TriggerScore.where(qtest_id: id)
      .pluck(:trigger_name, :score).map do |trigger, score|
        @trigger_weights[trigger] = score
      end
    end
    @trigger_weights
  end
end
