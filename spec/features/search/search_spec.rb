require 'sphinx_helper'

feature 'User can use search', '
  In order to find recource of community
  As an authenticated user
  I`d like to be able to use search
' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer) }
  given!(:comment) { create(:comment, commentable: question) }

  given!(:another_user) { create(:user) }
  given!(:another_question) { create(:question, body: 'same body') }
  given!(:another_answer) { create(:answer, body: 'same body') }
  given!(:another_comment) { create(:comment, commentable: question, body: 'same body') }


  background do
    sign_in(user)

    visit questions_path
  end

  scenario 'Find question', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'search_keywords', with: question.title
      page.check('search_resource_question')

      click_on 'Search'

      expect(page).to have_link question.title, href: question_path(question)
      expect(page).to_not have_content another_question.body
      expect(page).to_not have_content 'answer'
      expect(page).to_not have_content 'comment'
      expect(page).to_not have_content 'user'
    end
  end

  scenario 'Find answer', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'search_keywords', with: answer.body
      page.check('search_resource_answer')

      click_on 'Search'

      expect(page).to have_content answer.body
      expect(page).to have_link answer.question.title, href: question_path(answer.question)
      expect(page).to_not have_content another_answer.body
      expect(page).to_not have_content 'question'
      expect(page).to_not have_content 'comment'
      expect(page).to_not have_content 'user'
    end
  end

  scenario 'Find comment', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'search_keywords', with: comment.body
      page.check('search_resource_comment')

      click_on 'Search'

      expect(page).to have_content comment.body
      expect(page).to have_link comment.commentable.title, href: question_path(comment.commentable)
      expect(page).to_not have_content another_comment.body
      expect(page).to_not have_content 'question'
      expect(page).to_not have_content 'answer'
      expect(page).to_not have_content 'user'
    end
  end

  scenario 'Find same text', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'search_keywords', with: 'same body'
      page.check('search_resource_question')
      page.check('search_resource_answer')
      page.check('search_resource_comment')

      click_on 'Search'

      expect(page).to have_content 'same body', count: 3
    end
  end

  scenario 'Find user', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'search_keywords', with: user.email
      page.check('search_resource_user')

      click_on 'Search'

      expect(page).to have_content user.email
      expect(page).to_not have_content another_user.email
      expect(page).to_not have_content 'question'
      expect(page).to_not have_content 'answer'
      expect(page).to_not have_content 'comment'
    end
  end

end
