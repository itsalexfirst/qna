class AddAuthorToQuestionsAndAnswers < ActiveRecord::Migration[6.0]
  def change
    add_reference :questions, :author, null: false, foreign_key: { to_table: :users }
    add_reference :answers, :author, null: false, foreign_key: { to_table: :users }
  end
end
