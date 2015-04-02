require 'rails_helper'

describe "the add a user process" do
  it "adds a new user" do
    visit root_path
    click_on "Sign Up"
    fill_in "Email", with: Faker::Internet.email
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign Up"
    expect(page).to have_content "Welcome! You have signed up successfully."
  end

  it "errors when nothing is filled in" do
    visit root_path
    click_on "Sign Up"
    click_button "Sign Up"
    expect(page).to have_content "Email can't be blank"
  end
end

describe "the login user process" do
  it "logs the user in" do
    user = FactoryGirl.create(:user)
    visit root_path
    click_on "Login"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Login"
    expect(page).to have_content "Signed in successfully"
  end

  it "will return errors if user doesn't exist" do
    visit root_path
    click_on "Login"
    fill_in "Email", with: Faker::Internet.email
    fill_in "Password", with: Faker::Internet.password(8)
    click_button "Login"
    expect(page).to have_content "Invalid email or password"
  end

  it "logs the user out" do
    user = FactoryGirl.create(:user)
    visit root_path
    click_on "Login"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Login"
    click_on "Logout"
    expect(page).to have_content "Signed out successfully"
  end
end

describe "the edit user information process" do
  it "edits user information" do
    user = FactoryGirl.create(:user)
    visit root_path
    click_on "Login"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Login"
    click_on "Edit Profile"
    fill_in "Email", with: user.email
    fill_in "Password", with: "new_password"
    fill_in "Password confirmation", with: "new_password"
    fill_in "Current password", with: user.password
    click_on "Update"
    expect(page).to have_content "Your account has been updated successfully."
  end

  it "edits user information incorrectly" do
    user = FactoryGirl.create(:user)
    visit root_path
    click_on "Login"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Login"
    click_on "Edit Profile"
    fill_in "Email", with: user.email
    fill_in "Password", with: "new_password"
    fill_in "Password confirmation", with: "new_passwords"
    fill_in "Current password", with: user.password
    click_on "Update"
    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  it "deletes the user account" do
    user = FactoryGirl.create(:user, password: "password", password_confirmation: "password")
    visit root_path
    click_on "Login"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Login"
    click_on "Edit Profile"
    click_on "Cancel my account"
    expect(page).to have_content "Bye! Your account has been successfully cancelled. We hope to see you again soon."
  end
end

describe "the user forgot password process" do
  it "successfully sends the user an email" do
    user = FactoryGirl.create(:user)
    visit new_user_password_path
    fill_in "Email", with: user.email
    click_button "Send me reset password instructions"
    expect(page).to have_content "You will receive an email with instructions on how to reset your password in a few minutes."
  end

  it "will give an error message if user email doesn't exist" do
    visit new_user_password_path
    fill_in "Email", with: "mail@mail.com"
    click_button "Send me reset password instructions"
    expect(page).to have_content "Email not found"
  end
end
