# all the pdf generation methods
module PDFGen
  require 'prawn/measurement_extensions'
  include RGBColors

  def generate_cover_page(pdf)
    pdf = common_page_elements(pdf)

    top = pdf.bounds.top
    right = pdf.bounds.right

    pdf.image 'app/assets/images/greycircleelement.jpg',
              width: right - 32.mm, vposition: 7.mm

    pdf.bounding_box [0, (top - 7.mm)],
                     width: (right - 33.mm),
                     height: (right - 33.mm) do
      pdf.font_size 72
      pdf.formatted_text_box [{ text: "#{first_name} #{last_name}'s\n",
                                color: "#{orange}" },
                              { text: "Innovation Quotient Edge\n" },
                              { text: "(IQE)\n" },
                              { text: 'Report' }],
                             at: [2.mm, pdf.bounds.height - 55.mm],
                             width: pdf.bounds.width - 0.mm,
                             height: pdf.bounds.height - 100.mm,
                             overflow: :shrink_to_fit,
                             align: :center,
                             valign: :center
      pdf.font_size 12
    end
    pdf
  end

  def common_page_elements(pdf, page_title = nil, top_title = nil)
    pdf.canvas do

      @top = pdf.bounds.top
      @bottom = pdf.bounds.bottom
      @left = pdf.bounds.left
      @right = pdf.bounds.right

      pdf.rectangle [0, 30.mm], @right, 16.mm
      pdf.fill

      current_fill = pdf.fill_color
      pdf.fill_color orange
      pdf.rectangle [@right - 30.mm, @top], 21.mm, @top
      pdf.fill
      pdf.fill_color current_fill

      pdf.image 'app/assets/images/IQE - The Shuuk - with Black.jpg',
                at: [15.mm, 37.mm], width: 30.mm

      if page_title
        current_fill = pdf.fill_color
        pdf.fill_color = white
        pdf.text_box 'IQE: ' + page_title,
                     at: [pdf.bounds.right - 50, pdf.bounds.top - 24.mm],
                     width: 10.0.in,
                     size: 28,
                     height: 1.in,
                     style: :bold,
                     rotate_around: :upper_left,
                     rotate: -90,
                     overflow: :shrink_to_fit
      end

      pdf.font_size 16
      pdf.text_box (pdf.page_number - 1).to_s,
                   at: [2.in, 0.9.in],
                   styles: [:bold]

      if top_title
        pdf.fill_color gray
        pdf.rectangle [0, @top - 7.mm], @right, 16.mm
        pdf.fill
        pdf.font_size 40
        pdf.fill_color = white
        pdf.text_box top_title,
                     at: [pdf.bounds.left + 0.5.in, pdf.bounds.top - 9.mm],
                     width: 7.5.in,
                     height: 1.in,
                     style: :bold,
                     overflow: :shrink_to_fit
      end

      pdf.fill_color = current_fill

    end
    pdf
  end

  def generate_page_1(pdf)
    pdf.start_new_page
    pdf = common_page_elements(pdf, 'OVERVIEW')

    pdf.bounding_box [4.5, pdf.bounds.top - 9],
                     width: (pdf.bounds.right - 1.in) do
      pdf.font_size 18
      pdf.text "<color rgb='#{orange}'><b>Understanding Your "\
               'Innovation Quotient Edge (IQE)</b></color>',
               kerning: false,
               inline_format: true
      pdf.font_size 14
      pdf.text "\n<color rgb='#{orange}'>The IQE</color> is your opportunity "\
       'to discover your unique innovation style and strengths. This means '\
       'you can do more of the things that make you innovative and stop doing '\
       "the things you think you should do but that aren't working for you.",
               inline_format: true
      pdf.text("\nEach person has a unique combination, creating a brand of "\
      'innovation that is unique to you. With the IQE you will learn:')
      pdf.move_down 6
      pdf.table [['•', '<b>Your Style of Innovation:</b> This is where you '\
      'fit on the innovation scale. All 3 parts of the scale are equally '\
      'important and each plays a crucial role. You will discover where you '\
      'fit on the scale and how to leverage your innovation style.'],
                 ['•', '<b>Your Strengths in Innovation:</b>  Your top two '\
                 'Power Triggers indicate where you thrive the most. These '\
                 'are the areas where you are naturally more innovative in '\
                 'mindset, behaviors and actions. They are the areas of '\
                 'strength to leverage for success.'],
                 ['•', '<b>Your Unique Combination:</b> Like a stereo '\
                 'equalizer, each person has a unique blend of style and '\
                 'strength. The bar charts in this report visually represent '\
                 'your unique blend in relation to all 9 Triggers of '\
                 'innovation.'],
                 ['•', '<b>Your Dormant Trigger:</b> Of the 9 Power Triggers, '\
                 'your Dormant Trigger is the trigger you use the least. Your '\
                 'Dormant Trigger is less active than the other triggers. We '\
                 'believe in focusing on your strengths for greater success. '\
                 'However, knowing your Dormant Trigger is important so you '\
                 'are aware of which innovations style you find most '\
                 'challenging, in yourself and others, and so may want '\
                 'support in.']],
                cell_style: { borders: [],
                              inline_format: true,
                              padding: [0, 0, 0, 0] }
      pdf.text "\nUnderstanding and using your "\
      "<color rgb='#{orange}'>IQE</color> will help you:",
               inline_format: true
      pdf.move_down 6
      pdf.table [['•', 'Perform at your peak'],
                 ['•', 'Add more innovative thinking and value to your work'],
                 ['•', 'Build the right team of people around you (hint: '\
                 'people with strengths different from yours)'],
                 ['•', 'Unleash your unique competitive advantage']],
                cell_style: { borders: [],
                              padding: [0, 0, 0, 0] }
      pdf.text("\nHere's to knowing your IQE and achieving game-changing "\
      'results! - Tamara')
    end
    pdf
  end

  def generate_page_2(pdf)
    pdf.start_new_page
    pdf = common_page_elements(pdf, 'STYLE')

    pdf.bounding_box [4.5, pdf.bounds.top],
                     width: (pdf.bounds.right - 23.mm) do

      pdf.font_size 20
      pdf.text "<b>#{first_name}'s Innovation Style:</b> <color "\
      "rgb='#{orange}'><i>#{innovation_style}</i><color>",
               inline_format: true
      pdf.move_down 0

      pdf.image 'app/assets/images/Icons with names/'\
                "#{innovation_hash[innovation_style]['Innovation icon'][0]}",
                width: 75.mm,
                at: [0, pdf.cursor]

      pdf.bounding_box [79.mm, pdf.cursor],
                       width: pdf.bounds.right - 79.mm,
                       height: 75.mm do
        pdf.font_size 14
        pdf.text innovation_hash[innovation_style]['Definition'][0],
                 inline_format: true,
                 align: :center,
                 valign: :center
      end
    end
    pdf.move_down 30

    pdf.bounding_box [0, pdf.cursor], width: pdf.bounds.right - 23.mm do
      pdf.font_size 14
      paragraph = innovation_hash[innovation_style]['You as the'][0] +
        first_name + innovation_hash[innovation_style]['You as the'][1]
      pdf.text paragraph
      pdf.move_down 16

      pdf.font_size 18
      header = "<b>How You Add Value as an <color rgb='#{orange}'>Innovation "\
      "#{innovation_style}</color>:</b>"
      pdf.text header, inline_format: true
      pdf.font_size 14
      pdf.move_down 16

      table_array = innovation_hash[innovation_style]['How you add value']
      .map { |text| ['•', text] }
      pdf.table table_array,
                cell_style: { inline_format: true,
                              borders: [],
                              padding: [0, 0, 6, 0] }
    end
    pdf
  end

  def generate_page_3(pdf)
    pdf.start_new_page
    pdf = common_page_elements(pdf,
                               'YOU AT YOUR PEAK', 'Your Power Triggers')

    icon_width = 70.mm
    text_shift = 20.mm
    @pdf_cursor = pdf.cursor

    # pdf.float do
    pdf.bounding_box [-pdf.bounds.absolute_left, pdf.cursor - 31.mm],
                     width: pdf.bounds.width do
      pdf.image 'app/assets/images/Icons with names/'\
                  "#{strength_icon_file(driving_strength_1)}",
                width: icon_width
      pdf.font_size 16
      pdf.bounding_box [text_shift, pdf.cursor],
                       width: icon_width - text_shift do
        ss_words = strength_and_style(driving_strength_1)
        pdf.text "❏ #{ss_words[0]}"
        pdf.text "❏ #{ss_words[1]}"
        pdf.move_down 16
      end
    end
    # end

    @pdf_cursor_icon = pdf.cursor
    pdf.move_cursor_to @pdf_cursor

    pdf.bounding_box [icon_width - pdf.bounds.absolute_left,
                      pdf.cursor - 23.mm],
                     width: pdf.bounds.width - icon_width - 10.mm do

      pdf.font_size 16
      pdf.text "<color rgb='#{orange}'>YOU, AT YOUR PEAK:</color>",
               inline_format: true
      pdf.move_down 16
      pdf.font_size 12
      table_array = trigger_hash[driving_strength_1]['You at your peak']
      .map { |text| ['•', text] }
      pdf.table table_array,
                cell_style: { inline_format: true,
                              borders: [],
                              padding: [0, 0, 6, 0] }
      pdf.move_down 20
    end

    @pdf_cursor = pdf.cursor
    pdf.move_cursor_to [@pdf_cursor, @pdf_cursor_icon].min

    # pdf.float do
    pdf.bounding_box [-pdf.bounds.absolute_left, pdf.cursor + 7.mm],
                     width: pdf.bounds.width do
      pdf.image 'app/assets/images/Icons with names/'\
                  "#{strength_icon_file(driving_strength_2)}",
                width: icon_width
      pdf.font_size 16
      pdf.bounding_box [text_shift, pdf.cursor],
                       width: icon_width - text_shift do
        ss_words = strength_and_style(driving_strength_2)
        pdf.text "❏ #{ss_words[0]}"
        pdf.text "❏ #{ss_words[1]}"
      end

    end
    # end

    pdf.move_cursor_to [@pdf_cursor, @pdf_cursor_icon].min

    pdf.bounding_box [icon_width - pdf.bounds.absolute_left, pdf.cursor],
                     width: pdf.bounds.width - icon_width - 10.mm do
      pdf.font_size 12
      table_array = trigger_hash[driving_strength_2]['You at your peak']
      .map { |text| ['•', text] }
      pdf.table table_array,
                cell_style: { inline_format: true,
                              borders: [],
                              padding: [0, 0, 6, 0] }
    end
    pdf
  end

  def generate_page_4(pdf)
    pdf.start_new_page
    pdf = common_page_elements(pdf,
                               'HOW YOU ADD VALUE', 'Your Power Triggers')

    icon_width = 70.mm

    pdf.float do
      pdf.bounding_box [-pdf.bounds.absolute_left, pdf.cursor - 31.mm],
                       width: pdf.bounds.width do
        pdf.image 'app/assets/images/Icons with names/'\
                  "#{strength_icon_file(driving_strength_1)}",
                  width: icon_width
      end
    end

    pdf.bounding_box [icon_width - pdf.bounds.absolute_left,
                      pdf.cursor - 23.mm],
                     width: pdf.bounds.width - icon_width - 10.mm do

      pdf.font_size 16
      pdf.text "<color rgb='#{orange}'>HOW YOU ADD VALUE:</color>",
               inline_format: true
      pdf.move_down 16
      pdf.font_size 12

      table_array = trigger_hash[driving_strength_1]['How you add value']
      .map { |text| ['•', text] }
      pdf.table table_array,
                cell_style: { inline_format: true,
                              borders: [],
                              padding: [0, 0, 6, 0] }
      pdf.move_down 20
    end

    pdf.float do
      pdf.bounding_box [-pdf.bounds.absolute_left, pdf.cursor + 7.mm],
                       width: pdf.bounds.width do
        pdf.image 'app/assets/images/Icons with names/'\
                  "#{strength_icon_file(driving_strength_2)}",
                  width: icon_width
      end
    end

    pdf.bounding_box [icon_width - pdf.bounds.absolute_left, pdf.cursor],
                     width: pdf.bounds.width - icon_width - 10.mm do
      table_array = trigger_hash[driving_strength_2]['How you add value']
      .map { |text| ['•', text] }
      pdf.table table_array,
                cell_style: { inline_format: true,
                              borders: [],
                              padding: [0, 0, 6, 0] }
    end
    pdf
  end

  def generate_page_5(pdf)
    pdf.start_new_page
    pdf = common_page_elements(pdf, 'DORMANT', 'Your Dormant Trigger')

    icon_width = 70.mm

    pdf.float do
      pdf.bounding_box [-pdf.bounds.absolute_left, pdf.cursor - 10.5.mm],
                       width: pdf.bounds.width do
        pdf.image 'app/assets/images/Icons with names/'\
                  "#{strength_icon_file(latent_strength)}",
                  width: icon_width
      end
    end

    pdf.bounding_box [icon_width - pdf.bounds.absolute_left,
                      pdf.cursor - 23.mm],
                     width: pdf.bounds.width - icon_width - 10.mm do

      pdf.move_down 32
      pdf.font_size 14
      pdf.text trigger_hash[latent_strength]['Latent strength'][0],
               inline_format: true

    end

    pdf.bounding_box [0, pdf.cursor], width: pdf.bounds.right - 50.mm do

      pdf.move_down 70
      pdf.line_width = 2
      pdf.dash 2, space: 6
      pdf.stroke_horizontal_line (-10).mm, 170.mm, at: pdf.cursor
      pdf.move_down 20
      pdf.font_size 16
      pdf.text '<b>Managing Your Dormant Trigger:</b>', inline_format: true
      pdf.bounding_box [4.5, pdf.cursor],
                       width: pdf.bounds.right + 1.in do
        pdf.move_down 16
        pdf.text trigger_hash[latent_strength]['Overcoming Latent Strengths'][0]
        pdf.font_size 14
        pdf.move_down 14
        latent_text = trigger_hash[latent_strength][
          'Overcoming Latent Strengths']
        latent_text.shift
        table_array = latent_text.map { |text| ['•', text] }
        pdf.table table_array,
                  cell_style: { inline_format: true,
                                borders: [],
                                padding: [0, 0, 6, 0] }
      end
    end
    pdf
  end

  def generate_page_6(pdf)
    pdf.start_new_page
    pdf = common_page_elements(pdf, 'ACTION PLAN')

    pdf.bounding_box [0, pdf.cursor], width: pdf.bounds.width - 25.mm do

      pdf.text "<b>#{first_name}'s Action Plan:</b>", inline_format: true
      pdf.move_down 16
      pdf.font_size 24
      pdf.text "<color rgb='#{orange}'>"\
               '<b>Being You, At Your Peak:</color></b>', inline_format: true
      pdf.font_size 12
      pdf.text '(The situations where you thrive)'
      pdf.move_down 16
      pdf.font_size 14

      action_steps = trigger_hash[driving_strength_1]['Action step'] +
        trigger_hash[driving_strength_2]['Action step']
      table_array = []
      action_steps.each_with_index do |text, index|
        table_array << ["<b>#{index + 1}.</b>", text]
      end
      pdf.table table_array,
                cell_style: { inline_format: true,
                              borders: [],
                              padding: [0, 6, 6, 0] }

      pdf.move_down 16
      pdf.font_size 24
      pdf.text "<color rgb='#{orange}'>"\
               'Exercises To Strengthen Innovative Muscles</color>',
               inline_format: true
      pdf.font_size 12
      pdf.text '(Tools & templates to exercise your Power Triggers)'
      pdf.move_down 12

      pdf.font_size 14

      exercises = trigger_hash[driving_strength_1]['Exercise'] +
        trigger_hash[driving_strength_2]['Exercise']
      table_array = []
      exercises.each { |text| table_array << ['<b>•</b>', text] }
      pdf.table table_array,
                cell_style: { inline_format: true,
                              borders: [],
                              padding: [0, 0, 3, 0] }

      pdf.move_down 16
      pdf.line_width = 1
      pdf.dash 2, space: 0

      pdf.text 'The above list shares exercises to help you. Go to '\
      "<color rgb='#{link_blue}'><u><link "\
      "href='www.theshuuk.com/innovation-quotient-edge'>"\
      'www.theshuuk.com/innovation-quotient-edge</link></u></color> to '\
      "download more about these tools. Use the password 'myiq'.",
               inline_format: true
    end
    pdf
  end

  def generate_page_7(pdf)
    pdf.start_new_page
    pdf = common_page_elements(pdf, 'SCORES')

    pdf.bounding_box [0, pdf.cursor],
                     width: pdf.bounds.width - 25.mm,
                     height: pdf.cursor do

      pdf.text "<b>#{first_name} #{last_name}'s Scores</b>",
               inline_format: true, align: :center
      pdf.font_size 12
      pdf.move_down 8
      pdf.text 'The Innovation Quotient Edge (IQE) is a dynamic '\
      'representation of your innovative style and strengths. The charts '\
      'below represent your unique mix of innovation in relation to all 9 '\
      'triggers. Think of the results as a stereo equalizer with some areas '\
      'dialed up and some areas dialed down to create your unique results. '\
      'You may find multiple triggers dialed up or there may be large '\
      'differences between a few triggers. Results vary per person. Consider '\
      'your unique combination as a key contributor to your personal brand of '\
      'innovation.'
      pdf.move_down 12

      x_baseline = 16.mm
      y_position = 130.mm
      x_step = 16.mm
      bar_width = 6.mm
      points_per_trigger_unit = 35.mm / 15

      # Generate bar graph y-axis

      [0, 5, 10, 15, 20, 25, 30].each do |y_axis|
        pdf.stroke_color black
        pdf.line_width 1
        y_axis_line = y_axis * points_per_trigger_unit + y_position
        pdf.stroke_horizontal_line bar_width, x_step * 10, at: y_axis_line
        pdf.text_box y_axis.to_s,
                     at: [0, y_axis_line + 5],
                     size: 10,
                     width: bar_width - 2,
                     align: :right
      end

      # Generate bars

      trigger_total = 0

      trigger_weights.each_pair do |trigger, score|

        trigger_total += score

        pdf.fill_color orange_bar
        if (trigger == driving_strength_1) ||
          (trigger == driving_strength_2)
          pdf.fill_color green_bar
        elsif trigger == latent_strength
          pdf.fill_color blue_bar
        end

        bar_height = points_per_trigger_unit * trigger_weights[trigger]

        pdf.fill_rectangle [x_baseline, y_position + bar_height],
                           bar_width, bar_height

        # place name of trigger at base of each bar

        pdf.fill_color black
        pdf.text_box trigger,
                     at: [0, y_position - 2],
                     size: 10,
                     align: :right,
                     rotate: 45,
                     width: x_baseline + bar_width / 2,
                     height: 12,
                     rotate_around: :upper_right

        x_baseline += x_step
      end

      # generate percentage graph

      x_baseline = 16.mm
      y_position = 100.mm
      bar_width = 16.mm
      bar_length = 140.mm

      (trigger_weights.sort_by do |_trigger, value|
        value
      end).each do |trigger, value|

        trigger_percent = value / trigger_total
        trigger_percent_integer = (trigger_percent * 100 + 0.5).to_i
        trigger_width = (trigger_percent * bar_length).to_i

        # draw the colored rectangle with percentage of total length

        pdf.fill_color trigger_hash[trigger]['Color'][0]
        pdf.fill_rectangle [x_baseline, y_position], trigger_width, bar_width

        # label the trigger name to each percentage

        pdf.fill_color black
        label = trigger.dup

        label << " (#{trigger_percent_integer}%)" if trigger_percent_integer < 3
        pdf.text_box label,
                     at: [-50, y_position - bar_width - 2],
                     size: 10,
                     width: x_baseline + 50 + trigger_width / 2,
                     height: 12,
                     rotate: 45,
                     rotate_around: :upper_right,
                     align: :right

        # label the percentage textually

        if trigger_percent_integer >= 3
          pdf.text_box "#{trigger_percent_integer}%",
                       at: [x_baseline, y_position],
                       size: 10,
                       width: trigger_width,
                       height: bar_width,
                       overflow: :shrink_to_fit,
                       align: :center,
                       valign: :center
        end
        x_baseline += trigger_width
      end

    end
    pdf
  end

  def generate_page_8(pdf)
    pdf.start_new_page
    pdf = common_page_elements(pdf, '(IQE)', 'Innovation Style & Strengths')

    pdf.bounding_box [4.5, pdf.bounds.top - 20.mm],
                     width: (pdf.bounds.right - 23.mm) do

      pdf.font_size 20
      pdf.text "<b>#{first_name} #{last_name}</b>",
               inline_format: true
      pdf.move_down 10

      pdf.image 'app/assets/images/Icons with names/'\
                "#{innovation_hash[innovation_style]['Innovation icon'][0]}",
                width: 75.mm,
                at: [38.mm, pdf.cursor]

      pdf.bounding_box [0, pdf.cursor], width: pdf.bounds.right - 55.mm do

        pdf.move_down 210
      end
    end

    new_width = (pdf.bounds.width - 5.mm) / 2
    text_shift = 20.mm
    pdf.font_size 24

    pdf.float do
      pdf.bounding_box [-pdf.bounds.absolute_left, pdf.cursor],
                       width: new_width do
        pdf.image 'app/assets/images/Icons with names/'\
                  "#{strength_icon_file(driving_strength_1)}",
                  width: new_width

        pdf.bounding_box [text_shift, pdf.cursor],
                         width: new_width - text_shift do
          ss_words = strength_and_style(driving_strength_1)
          pdf.text "❏ #{ss_words[0]}"
          pdf.text "❏ #{ss_words[1]}"
        end

      end
    end
    pdf.float do
      pdf.bounding_box [new_width - pdf.bounds.absolute_left, pdf.cursor],
                       width: new_width do

        pdf.image 'app/assets/images/Icons with names/'\
                  "#{strength_icon_file(driving_strength_2)}",
                  width: new_width

        pdf.bounding_box [text_shift, pdf.cursor],
                         width: new_width - text_shift do
          ss_words = strength_and_style(driving_strength_2)
          pdf.text "❏ #{ss_words[0]}"
          pdf.text "❏ #{ss_words[1]}"
        end
      end
    end
    pdf.bounding_box [new_width - pdf.bounds.absolute_left - 1,
                      pdf.cursor - 50.mm], width: new_width do
      pdf.text '+', style: :bold
    end

    pdf.bounding_box [95, 75], width: 6.in do
      pdf.font_size 11
      pdf.text 'Print this page and keep it visible to remind you of your '\
    'unique IQE every day!'
      pdf.text 'http://InnovationQuotientTest.com',
               :align => :center
    end
    pdf
  end

  def generate_pdf_report
    pdf = Prawn::Document.new
    pdf = generate_cover_page(pdf)
    pdf = generate_page_1(pdf)
    pdf = generate_page_2(pdf)
    pdf = generate_page_3(pdf)
    pdf = generate_page_4(pdf)
    pdf = generate_page_5(pdf)
    pdf = generate_page_6(pdf)
    pdf = generate_page_7(pdf)
    pdf = generate_page_8(pdf)
    pdf
  end
end
