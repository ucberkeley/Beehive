class AddApplicationQuestions < ActiveRecord::Migration
  def change
    add_column :jobs, :question_1, :string
    add_column :jobs, :question_2, :string
    add_column :jobs, :question_3, :string

    add_column :applics, :answer_1, :string
    add_column :applics, :answer_2, :string
    add_column :applics, :answer_3, :string
  end
end
